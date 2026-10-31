import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const EVENT_INFO = {
  join: { label: 'Joined', color: 'good', icon: 'sign-in-alt' },
  leave: { label: 'Left', color: 'average', icon: 'sign-out-alt' },
  hack_fail: { label: 'Failed hack', color: 'bad', icon: 'user-secret' },
};

const FILTERS = [
  { id: 'all', label: 'All' },
  { id: 'join', label: 'Joins' },
  { id: 'leave', label: 'Leaves' },
  { id: 'hack_fail', label: 'Failed hacks' },
];

export const PcNetworkLog = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const entries = Array.isArray(data.entries) ? data.entries : [];
  const devices = Array.isArray(data.devices) ? data.devices : [];

  const [filter, setFilter] = useState('all');
  const [search, setSearch] = useState('');

  const needle = search.trim().toLowerCase();
  const shown = entries.filter(
    (e) =>
      (filter === 'all' || e.type === filter) &&
      (!needle ||
        String(e.device_id).toLowerCase().includes(needle) ||
        String(e.device_name).toLowerCase().includes(needle)),
  );

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title={`Network Log${data.network_name ? ` - ${data.network_name}` : ''}`}
        >
          <Stack>
            <Stack.Item>
              {FILTERS.map((f) => (
                <Button
                  key={f.id}
                  selected={filter === f.id}
                  onClick={() => setFilter(f.id)}
                >
                  {f.label}
                </Button>
              ))}
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={search}
                placeholder="Search device id or name..."
                onInput={(a, b) => setSearch(readInput(a, b))}
                onChange={(a, b) => setSearch(readInput(a, b))}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Connected devices" scrollable height="130px">
          {devices.length === 0 ? (
            <Box>No devices connected.</Box>
          ) : (
            <Table>
              {devices.map((d) => (
                <Table.Row key={d.device_id} className="candystripe">
                  <Table.Cell>
                    <Box inline style={{ fontFamily: 'monospace' }}>
                      {d.device_id}
                    </Box>
                  </Table.Cell>
                  <Table.Cell>
                    {d.device_name}
                    {!!d.is_self && ' (this computer)'}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button.Confirm
                      icon="plug"
                      color="bad"
                      disabled={!!d.is_self || !data.can_disconnect}
                      tooltip={
                        !data.can_disconnect
                          ? 'Administrator permissions required'
                          : undefined
                      }
                      confirmContent="Sure?"
                      onClick={() =>
                        act('disconnect', { device_id: d.device_id })
                      }
                    >
                      Disconnect
                    </Button.Confirm>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section fill scrollable>
          {shown.length === 0 ? (
            <NoticeBox info>No matching events recorded.</NoticeBox>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>Time</Table.Cell>
                <Table.Cell>Event</Table.Cell>
                <Table.Cell>Device ID</Table.Cell>
                <Table.Cell>Device</Table.Cell>
              </Table.Row>
              {shown.map((e, i) => {
                const info = EVENT_INFO[e.type] || {
                  label: e.type,
                  color: 'label',
                  icon: 'question',
                };
                return (
                  <Table.Row key={i} className="candystripe">
                    <Table.Cell>{e.time}</Table.Cell>
                    <Table.Cell>
                      <Box inline color={info.color} bold>
                        {info.label}
                      </Box>
                    </Table.Cell>
                    <Table.Cell>
                      <Box inline style={{ fontFamily: 'monospace' }}>
                        {e.device_id}
                      </Box>
                    </Table.Cell>
                    <Table.Cell>{e.device_name}</Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
