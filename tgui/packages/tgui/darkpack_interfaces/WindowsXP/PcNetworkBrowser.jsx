import { useLocalState } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { useProgram } from './useProgram';

export const PcNetworkBrowser = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const devices = Array.isArray(data.devices)
    ? data.devices
    : Array.isArray(data.browser?.devices)
      ? data.browser.devices
      : [];

  const currentRole = data.current_role || 'User';

  const [selectedRef, setSelectedRef] = useLocalState(context, 'net_sel', null);
  const selected = devices.find((d) => d.ref === selectedRef);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Box px={1} py={0.5} fontSize="11px">
          Network Role:{' '}
          <Box inline fontWeight="bold">
            {currentRole}
          </Box>
        </Box>
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item basis="45%">
            <Section title="Networked Devices" fill scrollable>
              {devices.length === 0 && (
                <Box p={1}>No networked devices found on this network.</Box>
              )}
              {devices.map((dev) => (
                <Box
                  key={dev.ref}
                  p={1}
                  mb={0.5}
                  style={{
                    background:
                      selectedRef === dev.ref ? '#cce0ff' : 'transparent',
                    cursor: 'pointer',
                    borderBottom: '1px solid #ddd',
                  }}
                  onClick={() => setSelectedRef(dev.ref)}
                >
                  <Box fontWeight="bold">{dev.name}</Box>
                </Box>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title={selected ? selected.name : 'Select a device'} fill>
              {selected ? (
                <Stack vertical>
                  {Object.entries(selected.actions || {}).map(
                    ([actionId, action]) => (
                      <Stack.Item key={actionId}>
                        <Button
                          fluid
                          disabled={!action.allowed}
                          content={`${action.name || actionId} ${!action.allowed ? `[Req: ${action.min_role}]` : ''}`}
                          tooltip={action.desc}
                          onClick={() =>
                            act('run_action', {
                              ref: selected.ref,
                              action_id: actionId,
                            })
                          }
                        />
                      </Stack.Item>
                    ),
                  )}
                  {Object.keys(selected.actions || {}).length === 0 && (
                    <Box>No actions available.</Box>
                  )}
                </Stack>
              ) : (
                <Box>Select a device to view available actions.</Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
