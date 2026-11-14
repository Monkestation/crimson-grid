import { useState } from 'react';
import { Box, Button, Section, Stack, Tabs } from 'tgui-core/components';
import { useProgram } from './useProgram';

const black = { color: '#000' };

export const PcHacking = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const network = data.network || 'Unknown';
  const revealCd = data.reveal_cooldown || 0;
  const hackCd = data.hack_cooldown || 0;
  const devices = Array.isArray(data.devices) ? data.devices : [];
  const results = Array.isArray(data.results) ? data.results : [];
  const intercepts = Array.isArray(data.intercepts) ? data.intercepts : [];
  const payments = Array.isArray(data.payments) ? data.payments : [];
  const selected = data.selected || null;

  const [tab, setTab] = useState('targets');

  const renderTargetPanel = () => {
    if (!selected) {
      return <Box style={black}>Select a device.</Box>;
    }

    const hacks = Array.isArray(selected.hacks) ? selected.hacks : [];
    const actions = Array.isArray(selected.actions) ? selected.actions : [];
    const showActions = !selected.is_pc;

    return (
      <>
        {hacks.map((hack) => (
          <Box key={hack.id} mb={1} style={black}>
            <Button
              icon="bug"
              disabled={hackCd > 0}
              onClick={() =>
                act('hack', { device: selected.id, hack: hack.id })
              }
            >
              {hackCd > 0 ? `${hack.name} (${hackCd}s)` : hack.name}
            </Button>
            <Box mt={0.5} fontSize="11px" style={{ color: '#555' }}>
              {hack.desc}
            </Box>
          </Box>
        ))}
        {showActions && (
          <>
            {hacks.length > 0 && (
              <Box bold mt={1} mb={0.5} style={black}>
                Actions
              </Box>
            )}
            {actions.length === 0 && hacks.length === 0 && (
              <Box style={{ color: '#555' }}>Nothing to attack here.</Box>
            )}
            {actions.map((item) => (
              <Box key={item.id} mb={1} style={black}>
                <Button
                  icon="terminal"
                  color="bad"
                  disabled={hackCd > 0}
                  onClick={() =>
                    act('run_action', {
                      device: selected.id,
                      action_id: item.id,
                    })
                  }
                >
                  {hackCd > 0 ? `${item.name} (${hackCd}s)` : item.name}
                </Button>
                <Box mt={0.5} fontSize="11px" style={{ color: '#555' }}>
                  {item.desc}
                </Box>
              </Box>
            ))}
          </>
        )}
      </>
    );
  };

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <Box style={black}>
            <Box inline fontWeight="bold">
              Network:
            </Box>{' '}
            {network}
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab
            selected={tab === 'targets'}
            onClick={() => setTab('targets')}
          >
            Targets ({devices.length})
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'intercepts'}
            onClick={() => setTab('intercepts')}
          >
            Intercepts ({intercepts.length})
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'payments'}
            onClick={() => setTab('payments')}
          >
            Payments ({payments.length})
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 'log'} onClick={() => setTab('log')}>
            Log
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>

      {tab === 'targets' && (
        <Stack.Item grow>
          <Stack fill>
            <Stack.Item basis="40%">
              <Section
                title="Devices"
                fill
                scrollable
                buttons={
                  <Button
                    icon="search"
                    disabled={revealCd > 0}
                    onClick={() => act('reveal')}
                  >
                    {revealCd > 0 ? `Reveal (${revealCd}s)` : 'Reveal'}
                  </Button>
                }
              >
                {devices.length === 0 && (
                  <Box p={1} style={black}>
                    No devices known. Run a reveal.
                  </Box>
                )}
                {devices.map((dev) => (
                  <Box
                    key={dev.id}
                    p={1}
                    mb={0.5}
                    fontFamily="monospace"
                    style={{
                      background:
                        selected && selected.id === dev.id ? '#cce0ff' : '#fff',
                      borderBottom: '1px solid #ddd',
                      cursor: 'pointer',
                      color: '#000',
                    }}
                    onClick={() => act('select', { device: dev.id })}
                  >
                    {dev.id} {dev.is_pc ? '(PC)' : ''}
                  </Box>
                ))}
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section
                title={selected ? `Attack ${selected.id}` : 'Attacks'}
                fill
                scrollable
              >
                {renderTargetPanel()}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}

      {tab === 'intercepts' && (
        <Stack.Item grow>
          <Section
            title="Intercepted posts"
            fill
            scrollable
            buttons={
              <Button
                icon="trash"
                disabled={intercepts.length === 0}
                onClick={() => act('clear_intercepts')}
              >
                Clear
              </Button>
            }
          >
            {intercepts.length === 0 && (
              <Box style={black}>Nothing intercepted yet.</Box>
            )}
            {intercepts.map((item, i) => (
              <Box
                key={i}
                p={1}
                mb={1}
                style={{ borderBottom: '1px solid #ddd', color: '#000' }}
              >
                <Box fontSize="11px" style={{ color: '#555' }}>
                  {item.device} / {item.board} - {item.time}
                </Box>
                <Box fontWeight="bold">
                  {item.name}
                  {item.subject ? `: ${item.subject}` : ''}
                </Box>
                <Box style={{ whiteSpace: 'pre-wrap' }}>{item.body}</Box>
                {!!item.has_image && (
                  <Box fontSize="11px" style={{ color: '#555' }}>
                    [image attached]
                  </Box>
                )}
              </Box>
            ))}
          </Section>
        </Stack.Item>
      )}

      {tab === 'payments' && (
        <Stack.Item grow>
          <Section
            title="Intercepted payments"
            fill
            scrollable
            buttons={
              <Button
                icon="trash"
                disabled={payments.length === 0}
                onClick={() => act('clear_payments')}
              >
                Clear
              </Button>
            }
          >
            {payments.length === 0 && (
              <Box style={black}>Nothing intercepted yet.</Box>
            )}
            {payments.map((item, i) => (
              <Box
                key={i}
                p={1}
                mb={1}
                style={{ borderBottom: '1px solid #ddd', color: '#000' }}
              >
                <Box fontSize="11px" style={{ color: '#555' }}>
                  {item.device} - {item.time}
                </Box>
                <Box fontWeight="bold">
                  {item.kind === 'withdrawal' &&
                    `${item.account || 'Unknown'} withdrew `}
                  {item.kind === 'deposit' &&
                    `${item.account || 'Unknown'} deposited `}
                  {item.kind === 'payment' &&
                    `${item.account || 'Unknown'} paid ${
                      item.counterparty || 'Unknown'
                    } `}
                  {Number(item.amount).toLocaleString()} ₡
                </Box>
                {item.skimmed > 0 && (
                  <Box style={{ color: '#0a7a0a' }}>
                    Skimmed +{Number(item.skimmed).toLocaleString()} ₡
                  </Box>
                )}
              </Box>
            ))}
          </Section>
        </Stack.Item>
      )}

      {tab === 'log' && (
        <Stack.Item grow>
          <Section title="Activity" fill scrollable>
            {results.length === 0 && <Box style={black}>No activity.</Box>}
            {results.map((line, i) => (
              <Box
                key={i}
                mb={0.5}
                fontFamily="monospace"
                fontSize="11px"
                style={black}
              >
                {line}
              </Box>
            ))}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};
