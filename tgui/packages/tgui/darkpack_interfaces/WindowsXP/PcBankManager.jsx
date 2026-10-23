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
  if (typeof a === 'string' || typeof a === 'number') {
    return String(a);
  }
  if (typeof b === 'string' || typeof b === 'number') {
    return String(b);
  }
  if (a && typeof a === 'object' && a.target != null) {
    return String(a.target.value ?? '');
  }
  return '';
};

export const PcBankManager = (props, context) => {
  const { act, data = {} } = useProgram(props.programId, context);

  const holder = data.holder;
  const balance = Number(data.balance) || 0;
  const debt = Number(data.debt) || 0;
  const mining_points = Number(data.mining_points) || 0;
  const history = Array.isArray(data.history) ? data.history : [];
  const pay_token = data.pay_token;
  const error = data.error;

  const [target, setTarget] = useState('');
  const [amount, setAmount] = useState('1');

  const amountNum = Math.max(0, parseInt(String(amount), 10) || 0);
  const targetStr = typeof target === 'string' ? target : '';

  if (error) {
    return (
      <Box color="bad" p={2}>
        {String(error)}
      </Box>
    );
  }

  if (holder == null && data.balance == null) {
    return (
      <Box p={2} style={{ color: '#555' }}>
        No account data. Log in with a credit card and open Bank Manager again.
      </Box>
    );
  }

  return (
    <Box
      p={1}
      style={{ color: '#000', height: '100%', boxSizing: 'border-box' }}
    >
      <Stack fill vertical>
        <Stack.Item>
          <Section title={`Account — ${holder || 'Unknown'}`}>
            <Stack>
              <Stack.Item grow>
                <Box fontSize="18px">
                  Balance:{' '}
                  <Box inline color="good" fontWeight="bold">
                    {balance.toLocaleString()} ₡
                  </Box>
                </Box>
                {debt > 0 && (
                  <Box color="average" mt={0.5}>
                    Outstanding debt: {debt.toLocaleString()} ₡
                  </Box>
                )}
                {mining_points > 0 && (
                  <Box mt={0.5} style={{ color: '#555' }}>
                    Mining points: {mining_points}
                  </Box>
                )}
              </Stack.Item>
              <Stack.Item>
                <Box
                  textAlign="right"
                  fontSize="11px"
                  style={{ color: '#555' }}
                >
                  Pay Token
                  <Box fontFamily="monospace" style={{ color: '#000' }}>
                    {pay_token || '—'}
                  </Box>
                </Box>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>

        <Stack.Item>
          <Section title="Transfer / Pay Underling">
            <Box mb={0.5} style={{ color: '#555' }}>
              Target (name or pay token)
            </Box>
            <Input
              fluid
              value={targetStr}
              placeholder="Jane Doe or MO-F-6983"
              onInput={(a, b) => setTarget(readInput(a, b))}
              onChange={(a, b) => setTarget(readInput(a, b))}
            />
            <Box mt={1} mb={0.5} style={{ color: '#555' }}>
              Amount
            </Box>
            <Box style={{ width: 120 }}>
              <Input
                fluid
                value={String(amount)}
                placeholder="1"
                onInput={(a, b) => setAmount(readInput(a, b))}
                onChange={(a, b) => setAmount(readInput(a, b))}
              />
            </Box>
            <Box mt={1}>
              <Button
                icon="exchange-alt"
                content="Transfer"
                disabled={!targetStr || amountNum <= 0}
                onClick={() =>
                  act('transfer', {
                    target: targetStr,
                    amount: amountNum,
                  })
                }
              />
              <Button
                icon="hand-holding-usd"
                content="Pay Underling"
                color="good"
                disabled={!targetStr || amountNum <= 0}
                onClick={() =>
                  act('pay_underling', {
                    name: targetStr,
                    amount: amountNum,
                  })
                }
              />
              {debt > 0 && (
                <Button
                  icon="file-invoice-dollar"
                  content="Pay Debt"
                  color="average"
                  onClick={() =>
                    act('pay_debt', {
                      amount: Math.min(amountNum || debt, debt),
                    })
                  }
                />
              )}
            </Box>
          </Section>
        </Stack.Item>

        <Stack.Item grow>
          <Section title="Transaction History" fill scrollable>
            {history.length === 0 ? (
              <Box p={1} style={{ color: '#555' }}>
                No transactions yet.
              </Box>
            ) : (
              <Table>
                <Table.Row header>
                  <Table.Cell>Amount</Table.Cell>
                  <Table.Cell>Reason</Table.Cell>
                </Table.Row>
                {[...history].reverse().map((entry, i) => {
                  const money = Number(entry?.adjusted_money) || 0;
                  return (
                    <Table.Row key={i}>
                      <Table.Cell
                        color={money >= 0 ? '' : 'bad'}
                        fontFamily="monospace"
                      >
                        {money >= 0 ? '+' : ''}
                        {money}
                      </Table.Cell>
                      <Table.Cell>{entry?.reason || '—'}</Table.Cell>
                    </Table.Row>
                  );
                })}
              </Table>
            )}
          </Section>
        </Stack.Item>
      </Stack>
    </Box>
  );
};
