import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const TRIGGER_TYPES = [
  { value: 'device', displayText: 'A device fires a trigger' },
  { value: 'timer', displayText: 'Every N seconds' },
  { value: 'mail', displayText: 'Mail arrives at an address' },
];

const STEP_TYPES = [
  { value: 'action', displayText: 'Run device action' },
  { value: 'read_var', displayText: 'Read device value' },
  { value: 'wait', displayText: 'Wait' },
  { value: 'mail', displayText: 'Send mail' },
  { value: 'set_var', displayText: 'Set variable' },
];

const VAR_CONDS = [
  { value: 'var_equals', displayText: 'variable equals' },
  { value: 'var_not_equals', displayText: 'variable does not equal' },
  { value: 'compare', displayText: 'compare a value' },
];
const MAIL_CONDS = [
  { value: 'mail_from', displayText: 'mail is from' },
  { value: 'mail_subject_contains', displayText: 'subject contains' },
  { value: 'mail_body_contains', displayText: 'body contains' },
];

const COMPARE_SOURCES = [
  { value: 'var', displayText: 'variable' },
  { value: 'event', displayText: 'trigger data' },
  { value: 'device', displayText: 'device reading' },
];
const COMPARE_OPS = [
  { value: 'eq', displayText: '=' },
  { value: 'neq', displayText: '!=' },
  { value: 'gt', displayText: '>' },
  { value: 'lt', displayText: '<' },
  { value: 'gte', displayText: '>=' },
  { value: 'lte', displayText: '<=' },
];

const emptyDraft = () => ({
  name: 'New rule',
  cooldown: 1,
  trigger: {
    type: 'device',
    device: '',
    trigger_id: '',
    seconds: 60,
    address: '',
  },
  conditions: [] as any[],
  steps: [] as any[],
});

const Block = (props: { color: string; label: string; children?: any }) => (
  <Box
    mb={1}
    p={1}
    style={{
      borderLeft: `4px solid ${props.color}`,
      background: 'rgba(0,0,0,0.15)',
    }}
  >
    <Box bold mb={0.5} color={props.color}>
      {props.label}
    </Box>
    {props.children}
  </Box>
);

export const PcNetworkAutomation = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const devices: any[] = data.devices || [];
  const rules: any[] = data.rules || [];
  const vars = data.vars || {};
  const canCreate = !!data.can_create;

  const [draft, setDraft] = useState(emptyDraft());
  const patch = (p: any) => setDraft({ ...draft, ...p });
  const patchTrigger = (p: any) =>
    patch({ trigger: { ...draft.trigger, ...p } });
  const patchItem = (key: 'conditions' | 'steps', i: number, p: any) =>
    patch({ [key]: draft[key].map((x, j) => (j === i ? { ...x, ...p } : x)) });
  const removeItem = (key: 'conditions' | 'steps', i: number) =>
    patch({ [key]: draft[key].filter((_, j) => j !== i) });

  const triggerDevices = devices.filter((d) => d.triggers.length > 0);
  const actionDevices = devices.filter((d) => d.actions.length > 0);
  const variableDevices = devices.filter((d) => d.variables?.length > 0);
  const deviceOptions = (list: any[]) =>
    list.map((d) => ({ value: d.ref, displayText: d.name }));

  const usedDeviceRefs = new Set<string>([
    ...draft.conditions
      .filter((c) => c.type === 'compare' && c.source === 'device' && c.device)
      .map((c) => c.device),
    ...draft.steps
      .filter((s) => s.type === 'read_var' && s.device)
      .map((s) => s.device),
    ...rules.flatMap((r) => r.devices || []),
  ]);
  const shownReadingDevices = variableDevices.filter((d) =>
    usedDeviceRefs.has(d.ref),
  );

  const selTrigDevice = devices.find((d) => d.ref === draft.trigger.device);
  const selTrig = selTrigDevice?.triggers.find(
    (t) => t.id === draft.trigger.trigger_id,
  );
  const payloadNames: string[] =
    draft.trigger.type === 'device' ? selTrig?.payload || [] : [];
  const payloadOptions = payloadNames.map((n) => ({
    value: n,
    displayText: n,
  }));
  const readingOptions = (dev: any) =>
    (dev?.variables || []).map((v) => ({
      value: v.id,
      displayText: v.allowed ? v.name : `${v.name} [no access]`,
    }));
  const condOptions =
    draft.trigger.type === 'mail' ? [...VAR_CONDS, ...MAIL_CONDS] : VAR_CONDS;

  return (
    <Stack fill>
      <Stack.Item basis="38%">
        <Section title="Active Rules" fill scrollable>
          {rules.length === 0 && <Box>No rules yet.</Box>}
          {rules.map((r) => (
            <Box
              key={r.id}
              p={1}
              mb={0.5}
              style={{ borderBottom: '1px solid #444' }}
            >
              <Box bold color={r.enabled ? 'good' : 'bad'}>
                {r.name} {r.running && '(running)'}
              </Box>
              <Box fontSize="11px">
                {r.summary} - {r.steps} step(s) - owner {r.owner} - fired{' '}
                {r.last_fired}
              </Box>
              {!!r.can_manage && (
                <Box mt={0.5}>
                  <Button onClick={() => act('toggle_rule', { id: r.id })}>
                    {r.enabled ? 'Disable' : 'Enable'}
                  </Button>
                  <Button onClick={() => act('test_rule', { id: r.id })}>
                    Test
                  </Button>
                  <Button
                    color="bad"
                    onClick={() => act('delete_rule', { id: r.id })}
                  >
                    Delete
                  </Button>
                </Box>
              )}
            </Box>
          ))}
          {Object.keys(vars).length > 0 && (
            <Box mt={1}>
              <Box bold>Variables</Box>
              {Object.entries(vars).map(([k, v]) => (
                <Box key={k} fontSize="11px">
                  {k} = {String(v)}
                </Box>
              ))}
            </Box>
          )}
          {shownReadingDevices.length > 0 && (
            <Box mt={1}>
              <Box bold>Device readings</Box>
              {shownReadingDevices.map((d) => (
                <Box key={d.ref} mb={0.5}>
                  <Box fontSize="11px" bold>
                    {d.name}
                  </Box>
                  {d.variables.map((v) => (
                    <Box key={v.id} ml={1} fontSize="11px">
                      {v.name} ={' '}
                      {v.allowed ? String(v.value ?? '-') : '[no access]'}
                    </Box>
                  ))}
                </Box>
              ))}
            </Box>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section title="Rule Builder" fill scrollable>
          {!canCreate && (
            <Box color="bad" mb={1}>
              Log in with sufficient network clearance to create rules.
            </Box>
          )}
          <Input
            fluid
            value={draft.name}
            maxLength={40}
            onChange={(v: string) => patch({ name: v })}
          />

          <Block color="#e6a817" label="WHEN">
            <Dropdown
              width="100%"
              options={TRIGGER_TYPES}
              selected={draft.trigger.type}
              onSelected={(v: string) => patchTrigger({ type: v })}
            />
            {draft.trigger.type === 'device' && (
              <Stack vertical mt={0.5}>
                <Stack.Item>
                  <Dropdown
                    width="100%"
                    placeholder="Device..."
                    options={deviceOptions(triggerDevices)}
                    selected={draft.trigger.device}
                    onSelected={(v: string) =>
                      patchTrigger({ device: v, trigger_id: '' })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    width="100%"
                    placeholder="Trigger..."
                    options={(selTrigDevice?.triggers || []).map((t) => ({
                      value: t.id,
                      displayText: t.name,
                    }))}
                    selected={draft.trigger.trigger_id}
                    onSelected={(v: string) => patchTrigger({ trigger_id: v })}
                  />
                </Stack.Item>
              </Stack>
            )}
            {draft.trigger.type === 'timer' && (
              <Box mt={0.5}>
                Every{' '}
                <NumberInput
                  value={draft.trigger.seconds}
                  minValue={5}
                  maxValue={3600}
                  step={5}
                  onChange={(v: number) => patchTrigger({ seconds: v })}
                />{' '}
                seconds
              </Box>
            )}
            {draft.trigger.type === 'mail' && (
              <Box mt={0.5}>
                <Input
                  fluid
                  placeholder="address@network"
                  value={draft.trigger.address}
                  onChange={(v: string) => patchTrigger({ address: v })}
                />
              </Box>
            )}
            <Box mt={0.5}>
              Cooldown{' '}
              <NumberInput
                value={draft.cooldown}
                minValue={1}
                maxValue={600}
                step={1}
                onChange={(v: number) => patch({ cooldown: v })}
              />{' '}
              seconds
            </Box>
          </Block>

          <Block color="#4c97ff" label="IF (all must be true)">
            {draft.conditions.map((c, i) => {
              const condDev = devices.find((d) => d.ref === c.device);
              return (
                <Box
                  key={i}
                  mb={1}
                  p={1}
                  style={{
                    background: 'rgba(0,0,0,0.2)',
                    border: '1px solid #444',
                  }}
                >
                  <Stack vertical>
                    <Stack.Item>
                      <Dropdown
                        width="100%"
                        options={condOptions}
                        selected={c.type}
                        onSelected={(v: string) =>
                          patchItem(
                            'conditions',
                            i,
                            v === 'compare'
                              ? {
                                  type: v,
                                  source: 'var',
                                  op: 'eq',
                                  key: '',
                                  device: '',
                                }
                              : { type: v },
                          )
                        }
                      />
                    </Stack.Item>
                    {c.type === 'compare' && (
                      <>
                        <Stack.Item>
                          <Dropdown
                            width="100%"
                            options={COMPARE_SOURCES}
                            selected={c.source}
                            onSelected={(v: string) =>
                              patchItem('conditions', i, {
                                source: v,
                                key: '',
                                device: '',
                              })
                            }
                          />
                        </Stack.Item>
                        {c.source === 'var' && (
                          <Stack.Item>
                            <Input
                              fluid
                              placeholder="variable"
                              value={c.key || ''}
                              onChange={(v: string) =>
                                patchItem('conditions', i, { key: v })
                              }
                            />
                          </Stack.Item>
                        )}
                        {c.source === 'event' && (
                          <Stack.Item>
                            <Dropdown
                              width="100%"
                              placeholder="Data..."
                              options={payloadOptions}
                              selected={c.key}
                              onSelected={(v: string) =>
                                patchItem('conditions', i, { key: v })
                              }
                            />
                          </Stack.Item>
                        )}
                        {c.source === 'device' && (
                          <>
                            <Stack.Item>
                              <Dropdown
                                width="100%"
                                placeholder="Device..."
                                options={deviceOptions(variableDevices)}
                                selected={c.device}
                                onSelected={(v: string) =>
                                  patchItem('conditions', i, {
                                    device: v,
                                    key: '',
                                  })
                                }
                              />
                            </Stack.Item>
                            <Stack.Item>
                              <Dropdown
                                width="100%"
                                placeholder="Reading..."
                                options={readingOptions(condDev)}
                                selected={c.key}
                                onSelected={(v: string) =>
                                  patchItem('conditions', i, { key: v })
                                }
                              />
                            </Stack.Item>
                          </>
                        )}
                        <Stack.Item>
                          <Dropdown
                            width="100%"
                            options={COMPARE_OPS}
                            selected={c.op}
                            onSelected={(v: string) =>
                              patchItem('conditions', i, { op: v })
                            }
                          />
                        </Stack.Item>
                      </>
                    )}
                    {c.type.startsWith('var_') && (
                      <Stack.Item>
                        <Input
                          fluid
                          placeholder="variable"
                          value={c.key || ''}
                          onChange={(v: string) =>
                            patchItem('conditions', i, { key: v })
                          }
                        />
                      </Stack.Item>
                    )}
                    <Stack.Item>
                      <Input
                        fluid
                        placeholder="value"
                        value={c.value || ''}
                        onChange={(v: string) =>
                          patchItem('conditions', i, { value: v })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        fluid
                        color="bad"
                        icon="times"
                        content="Delete condition"
                        onClick={() => removeItem('conditions', i)}
                      />
                    </Stack.Item>
                  </Stack>
                </Box>
              );
            })}
            <Button
              icon="plus"
              disabled={draft.conditions.length >= 5}
              onClick={() =>
                patch({
                  conditions: [
                    ...draft.conditions,
                    { type: 'var_equals', key: '', value: '' },
                  ],
                })
              }
            >
              Add condition
            </Button>
          </Block>

          <Block color="#59c059" label="THEN">
            {draft.steps.map((s, i) => {
              const stepDev = devices.find((d) => d.ref === s.device);
              return (
                <Box
                  key={i}
                  mb={1}
                  p={1}
                  style={{
                    background: 'rgba(0,0,0,0.2)',
                    border: '1px solid #444',
                  }}
                >
                  <Stack vertical>
                    <Stack.Item>
                      <Dropdown
                        width="100%"
                        options={STEP_TYPES}
                        selected={s.type}
                        onSelected={(v: string) =>
                          patchItem('steps', i, { type: v })
                        }
                      />
                    </Stack.Item>
                    {s.type === 'action' && (
                      <>
                        <Stack.Item>
                          <Dropdown
                            width="100%"
                            placeholder="Device..."
                            options={deviceOptions(actionDevices)}
                            selected={s.device}
                            onSelected={(v: string) =>
                              patchItem('steps', i, {
                                device: v,
                                action_id: '',
                              })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Dropdown
                            width="100%"
                            placeholder="Action..."
                            options={(stepDev?.actions || []).map((a) => ({
                              value: a.id,
                              displayText: a.allowed
                                ? a.name
                                : `${a.name} [no access]`,
                            }))}
                            selected={s.action_id}
                            onSelected={(v: string) =>
                              patchItem('steps', i, { action_id: v })
                            }
                          />
                        </Stack.Item>
                      </>
                    )}
                    {s.type === 'read_var' && (
                      <>
                        <Stack.Item>
                          <Dropdown
                            width="100%"
                            placeholder="Device..."
                            options={deviceOptions(variableDevices)}
                            selected={s.device}
                            onSelected={(v: string) =>
                              patchItem('steps', i, { device: v, var_id: '' })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Dropdown
                            width="100%"
                            placeholder="Reading..."
                            options={readingOptions(stepDev)}
                            selected={s.var_id}
                            onSelected={(v: string) =>
                              patchItem('steps', i, { var_id: v })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Input
                            fluid
                            placeholder="store in variable"
                            value={s.key || ''}
                            onChange={(v: string) =>
                              patchItem('steps', i, { key: v })
                            }
                          />
                        </Stack.Item>
                      </>
                    )}
                    {s.type === 'wait' && (
                      <Stack.Item>
                        <NumberInput
                          value={s.seconds || 1}
                          minValue={1}
                          maxValue={60}
                          step={1}
                          onChange={(v: number) =>
                            patchItem('steps', i, { seconds: v })
                          }
                        />{' '}
                        sec
                      </Stack.Item>
                    )}
                    {s.type === 'mail' && (
                      <>
                        <Stack.Item>
                          <Input
                            fluid
                            placeholder="to"
                            value={s.to || ''}
                            onChange={(v: string) =>
                              patchItem('steps', i, { to: v })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Input
                            fluid
                            placeholder="subject"
                            value={s.subject || ''}
                            onChange={(v: string) =>
                              patchItem('steps', i, { subject: v })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Input
                            fluid
                            placeholder="body"
                            value={s.body || ''}
                            onChange={(v: string) =>
                              patchItem('steps', i, { body: v })
                            }
                          />
                        </Stack.Item>
                      </>
                    )}
                    {s.type === 'set_var' && (
                      <>
                        <Stack.Item>
                          <Input
                            fluid
                            placeholder="variable"
                            value={s.key || ''}
                            onChange={(v: string) =>
                              patchItem('steps', i, { key: v })
                            }
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Input
                            fluid
                            placeholder="value"
                            value={s.value || ''}
                            onChange={(v: string) =>
                              patchItem('steps', i, { value: v })
                            }
                          />
                        </Stack.Item>
                      </>
                    )}
                    <Stack.Item>
                      <Button
                        fluid
                        color="bad"
                        icon="times"
                        content="Delete step"
                        onClick={() => removeItem('steps', i)}
                      />
                    </Stack.Item>
                  </Stack>
                </Box>
              );
            })}
            <Button
              icon="plus"
              disabled={draft.steps.length >= 10}
              onClick={() =>
                patch({
                  steps: [
                    ...draft.steps,
                    { type: 'action', device: '', action_id: '' },
                  ],
                })
              }
            >
              Add step
            </Button>
            <Box mt={0.5} fontSize="11px">
              Text fields accept {'{var.name}'}
              {payloadNames.map((n) => ` {event.${n}}`)}
            </Box>
          </Block>

          <Button
            color="good"
            icon="save"
            disabled={!canCreate}
            onClick={() => act('save_rule', { rule: JSON.stringify(draft) })}
          >
            Save &amp; enable
          </Button>
          <Button onClick={() => setDraft(emptyDraft())}>Clear</Button>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
