#define COMSIG_ASSEMBLY_SIGNALER_RECEIVED "assembly_signaler_received" // (code, frequency)
#define COMSIG_ASSEMBLY_INFRA_TRIGGERED "assembly_infra_triggered"     // (atom/movable/entered)
#define COMSIG_ASSEMBLY_VOICE_TRIGGERED "assembly_voice_triggered"     // ()


#define COMSIG_BUTTON_PRESSED "pc_button_pressed"
/// Send to a networked atom to move it between networks: (new_network_id, allow_restricted = FALSE)
#define COMSIG_NETWORKED_SET_NETWORK "networked_set_network"
/// Sent by the atom after it moved networks: (old_network_id, new_network_id)
#define COMSIG_NETWORKED_NETWORK_CHANGED "networked_network_changed"

/// (/obj/machinery/pc_printer, title of the printed painting or "test page")
#define COMSIG_PC_PRINTER_PRINTED "pc_printer_printed"
/// (/obj/machinery/pc_printer)
#define COMSIG_PC_PRINTER_OUT_OF_PAPER "pc_printer_out_of_paper"
/// (/obj/machinery/pc_printer, new paper count)
#define COMSIG_PC_PRINTER_PAPER_LOADED "pc_printer_paper_loaded"

#define COMSIG_BLACKBOX_REMOVED "blackbox_removed"
#define COMSIG_BLACKBOX_INSERTED "blackbox_inserted"
#define COMSIG_MSG_SERVER_PDA_LOGGED "msg_server_pda_logged"
#define COMSIG_MSG_SERVER_RC_LOGGED "msg_server_rc_logged"
#define COMSIG_MSG_SERVER_CALIBRATED "msg_server_calibrated"
#define COMSIG_ATM_CARD_SWIPED "atm_card_swiped"
#define COMSIG_ATM_LOGIN "atm_login"
#define COMSIG_ATM_LOGIN_FAILED "atm_login_failed"
#define COMSIG_ATM_WITHDRAW "atm_withdraw"
#define COMSIG_ATM_DEPOSIT "atm_deposit"
#define COMSIG_RETAIL_PURCHASE "retail_purchase"
#define COMSIG_RETAIL_SOLD_OUT "retail_sold_out"
#define COMSIG_BARCODE_SCAN "barcode_scan"
