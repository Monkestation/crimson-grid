import { useState } from 'react';
import {
  Box,
  Button,
  Input,
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

export const PcPermissions = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const isMasterUnlocked = data.is_master_unlocked || false;
  const currentRole = data.current_role || 'Guest';
  const roleHierarchy = Array.isArray(data.role_hierarchy)
    ? data.role_hierarchy
    : [];
  const users = Array.isArray(data.users) ? data.users : [];

  const [password, setPassword] = useState('');

  return (
    <Stack fill vertical p={1}>
      <Stack.Item>
        <Section title="Network Access Control">
          <Box mb={1}>
            <Box inline>Current Role: </Box>
            <Box inline fontWeight="bold" fontFamily="monospace">
              {currentRole}
            </Box>
          </Box>
          {!isMasterUnlocked ? (
            <Stack>
              <Stack.Item grow>
                <Input
                  fluid
                  type="password"
                  placeholder="Master Password"
                  value={password}
                  onInput={(a, b) => setPassword(readInput(a, b))}
                  onChange={(a, b) => setPassword(readInput(a, b))}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Authenticate"
                  icon="key"
                  disabled={!password}
                  onClick={() => {
                    act('auth_master', { password });
                    setPassword('');
                  }}
                />
              </Stack.Item>
            </Stack>
          ) : (
            <Box color="good">Master Session Active (Full Control)</Box>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section title="Connected Users & Roles" fill scrollable>
          {users.length === 0 ? (
            <Box p={1}>No users registered on this network yet.</Box>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>User / Address</Table.Cell>
                <Table.Cell>Assigned Role</Table.Cell>
                {isMasterUnlocked && <Table.Cell>Change Role</Table.Cell>}
              </Table.Row>
              {users.map((u, i) => (
                <Table.Row key={i}>
                  <Table.Cell fontFamily="monospace">{u.name}</Table.Cell>
                  <Table.Cell>{u.role}</Table.Cell>
                  {isMasterUnlocked && (
                    <Table.Cell>
                      {roleHierarchy.map((role) => (
                        <Button
                          key={role}
                          content={role}
                          size="compact"
                          color={u.role === role ? 'good' : 'default'}
                          disabled={u.role === role}
                          onClick={() =>
                            act('set_role', { target: u.name, role })
                          }
                        />
                      ))}
                    </Table.Cell>
                  )}
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
