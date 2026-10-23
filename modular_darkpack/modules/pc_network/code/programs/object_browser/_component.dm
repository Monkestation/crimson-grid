/datum/component/networked
	/// "action_id" = list(AUTOMATION_NAME, AUTOMATION_DESC, "callback", AUTOMATION_MIN_ROLE, AUTOMATION_ALLOW_AUTOMATE)
	var/list/actions = list()
	/// "trigger_id" = list(AUTOMATION_NAME, AUTOMATION_DESC, AUTOMATION_SIGNAL, AUTOMATION_MIN_ROLE)
	var/list/triggers = list()
	/// trigger_id -> /datum/pc_trigger_listener
	var/list/listeners = list()
	/// "var_id" = list(AUTOMATION_NAME, AUTOMATION_DESC, AUTOMATION_CALLBACK (returns the value), AUTOMATION_MIN_ROLE)
	var/list/variables = list()
	/// Listeners that move this device to another network when a signal fires
	var/list/switch_listeners = list()
	var/network_id = PC_NETWORK_PUBLIC
	var/hack_difficulty = 0

/// network_switches: AUTOMATION_SIGNAL = list("network" = id, "allow_restricted" = FALSE)
///   (a bare network id string is accepted too). Use PC_NETWORK_OFFLINE as the target to disconnect.
/datum/component/networked/Initialize(list/available_actions, network = PC_NETWORK_PUBLIC, list/available_triggers, list/network_switches, list/available_variables)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	actions = available_actions || list()
	triggers = available_triggers || list()
	variables = available_variables || list()
	network_id = network || PC_NETWORK_PUBLIC

	for(var/trigger_id in triggers)
		var/list/trig = triggers[trigger_id]
		if(!trig[AUTOMATION_SIGNAL])
			continue
		var/datum/pc_trigger_listener/L = new(src, trigger_id)
		L.RegisterSignal(parent, trig[AUTOMATION_SIGNAL], TYPE_PROC_REF(/datum/pc_trigger_listener, on_signal))
		listeners[trigger_id] = L

	for(var/switch_signal in network_switches)
		var/list/entry = network_switches[switch_signal]
		if(!islist(entry))
			entry = list("network" = entry)
		var/datum/pc_switch_listener/S = new(src, entry["network"], entry["allow_restricted"])
		S.RegisterSignal(parent, switch_signal, TYPE_PROC_REF(/datum/pc_switch_listener, on_signal))
		switch_listeners += S

	RegisterSignal(parent, COMSIG_NETWORKED_SET_NETWORK, PROC_REF(on_set_network_signal))
	RegisterSignal(parent, COMSIG_ATOM_TOOL_ACT(TOOL_MULTITOOL), PROC_REF(on_multitool))
	attempt_network_join()

/datum/component/networked/proc/on_multitool(datum/source, mob/living/user, obj/item/multitool/tool)
	SIGNAL_HANDLER
	var/datum/pc_network/player/net = tool.buffer
	if(!istype(net))
		return NONE
	INVOKE_ASYNC(src, PROC_REF(hack_network), user, net.id) // st_roll can sleep
	net.log_event(NETWORK_LOG_HACK_FAIL, parent)
	return ITEM_INTERACT_SUCCESS

/datum/component/networked/proc/hack_network(mob/living/user, new_id)
	var/datum/pc_network/player/net = GLOB.pc_networks[new_id]
	if(!istype(net))
		return FALSE
	if(network_id != PC_NETWORK_OFFLINE)
		var/datum/storyteller_roll/hack_network/roll = new()
		roll.difficulty = net.hack_difficulty + hack_difficulty
		var/result = roll.st_roll(user, parent)
		qdel(roll)
		if(result != ROLL_SUCCESS)
			to_chat(user, span_warning("You fail to break into [net.name]."))
			return FALSE
	return set_network(new_id)

/datum/component/networked/Destroy()
	var/datum/pc_network/net = GLOB.pc_networks[network_id]
	net?.leave(parent)
	for(var/trigger_id in listeners)
		qdel(listeners[trigger_id]) // datum Destroy() unregisters its own signals
	listeners.Cut()
	QDEL_LIST(switch_listeners)
	return ..()

/datum/component/networked/proc/attempt_network_join()
	var/datum/pc_network/net = GLOB.pc_networks[network_id]
	net?.join(parent)

/datum/component/networked/proc/set_network(new_id, allow_restricted = FALSE)
	new_id ||= PC_NETWORK_OFFLINE
	if(new_id == network_id)
		return FALSE
	var/datum/pc_network/new_net = GLOB.pc_networks[new_id]
	if(new_id != PC_NETWORK_OFFLINE)
		if(!new_net)
			return FALSE
		if(new_net.is_restricted && !allow_restricted)
			return FALSE

	var/old_id = network_id
	var/datum/pc_network/old_net = GLOB.pc_networks[old_id]
	old_net?.leave(parent)
	network_id = new_id
	new_net?.join(parent)
	SEND_SIGNAL(parent, COMSIG_NETWORKED_NETWORK_CHANGED, old_id, new_id)
	return TRUE

/datum/component/networked/proc/on_set_network_signal(datum/source, new_network_id, allow_restricted = FALSE)
	SIGNAL_HANDLER
	set_network(new_network_id, allow_restricted)

/// Current value of a device reading, or null.
/datum/component/networked/proc/read_variable(var_id)
	var/list/def = variables[var_id]
	var/datum/callback/cb = def?[AUTOMATION_CALLBACK]
	return cb?.Invoke()

/// Called by a listener when one of our trigger signals fires.
/datum/component/networked/proc/fire_trigger(trigger_id, list/signal_args)
	var/datum/pc_network/net = GLOB.pc_networks[network_id]
	if(!net?.automation)
		return
	var/list/payload = list()
	var/list/names = triggers[trigger_id]?[AUTOMATION_PAYLOAD]
	for(var/i in 1 to min(length(names), length(signal_args)))
		var/value = signal_args[i]
		if(isnum(value))
			payload[names[i]] = value
		else if(istext(value))
			payload[names[i]] = copytext(value, 1, 129) // never leak datum refs into rule state
	net.automation.on_device_trigger(parent, trigger_id, payload)

/// One tiny listener per trigger, so on_signal() knows WHICH trigger fired
/// (a component can only register one proc per signal, and it can't tell which id it was for).
/datum/pc_trigger_listener
	var/datum/component/networked/component
	var/trigger_id

/datum/pc_trigger_listener/New(datum/component/networked/component, trigger_id)
	. = ..()
	src.component = component
	src.trigger_id = trigger_id

/datum/pc_trigger_listener/Destroy()
	component = null
	return ..()

/datum/pc_trigger_listener/proc/on_signal(datum/source, ...)
	SIGNAL_HANDLER
	component?.fire_trigger(trigger_id, args.Copy(2))

/// Same idea, but the effect is "switch to this network".
/datum/pc_switch_listener
	var/datum/component/networked/component
	var/target_network
	var/allow_restricted = FALSE

/datum/pc_switch_listener/New(datum/component/networked/component, target_network, allow_restricted = FALSE)
	. = ..()
	src.component = component
	src.target_network = target_network
	src.allow_restricted = allow_restricted

/datum/pc_switch_listener/Destroy()
	component = null
	return ..()

/datum/pc_switch_listener/proc/on_signal(datum/source, ...)
	SIGNAL_HANDLER
	component?.set_network(target_network, allow_restricted)
