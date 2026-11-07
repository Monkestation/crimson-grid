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

const GREEN = '#1b7a34';
const RED = '#c62828';
const GREY = '#555';

const fmtMoney = (n) => `${Math.round(Number(n) || 0).toLocaleString()} ₡`;
const fmtPct = (n) => `${((Number(n) || 0) * 100).toFixed(1)}%`;
const fmtAge = (s) => {
  const secs = Math.max(0, Math.round(s));
  return `${Math.floor(secs / 60)}m ${String(secs % 60).padStart(2, '0')}s`;
};
const toInt = (v) => Math.max(0, parseInt(String(v), 10) || 0);

const AmountInput = ({ value, onChange, width = 100, placeholder = '0' }) => (
  <Box style={{ width }}>
    <Input
      fluid
      value={String(value)}
      placeholder={placeholder}
      onChange={(a, b) => onChange(readInput(a, b))}
    />
  </Box>
);

export const PcLedger = (props, context) => {
  const { act, data = {} } = useProgram(props.programId, context);

  const [creditAmt, setCreditAmt] = useState('');
  const [atmAmt, setAtmAmt] = useState('');
  const [loanAmt, setLoanAmt] = useState('');
  const [loanRate, setLoanRate] = useState('1');
  const [collectAmt, setCollectAmt] = useState('');

  if (data.error) {
    return (
      <Box color="bad" p={2}>
        {String(data.error)}
      </Box>
    );
  }
  if (data.available === false) {
    return (
      <Box p={2} style={{ color: GREY }}>
        This network has no treasury.
      </Box>
    );
  }
  if (data.available == null) {
    return (
      <Box p={2} style={{ color: GREY }}>
        No account data. Log in with a credit card and open Network Ledger
        again.
      </Box>
    );
  }

  const can = !!data.can_manage;
  const wealth = data.wealth || {};
  const rows = Array.isArray(wealth.commodity_rows)
    ? wealth.commodity_rows
    : [];
  const atms = Array.isArray(data.atms) ? data.atms : [];
  const pending = Array.isArray(data.pending) ? data.pending : [];
  const loans = Array.isArray(data.loans) ? data.loans : [];
  const owed = Number(data.owed) || 0;
  const limit = Number(data.credit_limit) || 0;
  const balance = Number(data.treasury_balance) || 0;
  const ratePct = Math.min(
    (Number(data.max_rate) || 0.1) * 100,
    Math.max((Number(data.min_rate) || 0.005) * 100, parseFloat(loanRate) || 0),
  );

  return (
    <Box
      p={1}
      style={{ color: '#000', height: '100%', boxSizing: 'border-box' }}
    >
      <Stack fill vertical>
        <Stack.Item>
          <Section title={`Network Ledger — ${data.network_name}`}>
            {!can && (
              <NoticeBox>
                Read only. You do not have authority over this network's funds.
              </NoticeBox>
            )}
            <Stack>
              <Stack.Item grow>
                Treasury:{' '}
                <Box inline fontWeight="bold" style={{ color: GREEN }}>
                  {fmtMoney(balance)}
                </Box>
              </Stack.Item>
              <Stack.Item grow>
                Total wealth:{' '}
                <Box inline fontWeight="bold">
                  {fmtMoney(wealth.total)}
                </Box>
              </Stack.Item>
              <Stack.Item grow>
                Owed:{' '}
                <Box
                  inline
                  fontWeight="bold"
                  style={{ color: owed > 0 ? RED : '#000' }}
                >
                  {fmtMoney(owed)}
                </Box>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>

        <Stack.Item grow>
          <Stack fill>
            <Stack.Item basis="50%">
              <Stack fill vertical>
                <Stack.Item grow>
                  <Section
                    title="Wealth"
                    fill
                    scrollable
                    buttons={
                      <Button
                        icon="rotate"
                        content="Rescan"
                        disabled={!can}
                        onClick={() => act('scan')}
                      />
                    }
                  >
                    <Table>
                      <Table.Row>
                        <Table.Cell>Vault cash</Table.Cell>
                        <Table.Cell textAlign="right">
                          {fmtMoney(wealth.dollars)}
                        </Table.Cell>
                      </Table.Row>
                      <Table.Row>
                        <Table.Cell>Treasury (net of debt)</Table.Cell>
                        <Table.Cell textAlign="right">
                          {fmtMoney(wealth.treasury)}
                        </Table.Cell>
                      </Table.Row>
                      {rows.map((r) => (
                        <Table.Row key={r.ticker}>
                          <Table.Cell style={{ color: GREY }}>
                            {r.units} × {r.name} @ {Number(r.price).toFixed(2)}
                          </Table.Cell>
                          <Table.Cell textAlign="right">
                            {fmtMoney(r.value)}
                          </Table.Cell>
                        </Table.Row>
                      ))}
                      <Table.Row>
                        <Table.Cell>Vault commodities</Table.Cell>
                        <Table.Cell textAlign="right">
                          {fmtMoney(wealth.commodity_value)}
                        </Table.Cell>
                      </Table.Row>
                      <Table.Row>
                        <Table.Cell>ETF pool</Table.Cell>
                        <Table.Cell textAlign="right">
                          {fmtMoney(wealth.etf)}
                        </Table.Cell>
                      </Table.Row>
                    </Table>
                    <Box mt={1} fontSize="11px" style={{ color: GREY }}>
                      {wealth.areas || 0} scanned area
                      {wealth.areas === 1 ? '' : 's'}
                      {data.last_scan_ago != null
                        ? ` · last scan ${fmtAge(data.last_scan_ago)} ago`
                        : ' · never scanned'}
                    </Box>
                  </Section>
                </Stack.Item>

                <Stack.Item>
                  <Section title="Credit line">
                    <Box mb={0.5} style={{ color: GREY }}>
                      Borrow up to 100% of wealth. Interest{' '}
                      {fmtPct(data.network_rate)} every {data.interest_minutes}{' '}
                      minutes, compounding.
                    </Box>
                    <Box mb={0.5}>
                      Available: <b>{fmtMoney(limit)}</b>
                    </Box>
                    <Stack>
                      <Stack.Item>
                        <AmountInput
                          value={creditAmt}
                          onChange={setCreditAmt}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          content="Max"
                          disabled={!can || limit <= 0}
                          onClick={() => setCreditAmt(String(limit))}
                        />
                        <Button
                          icon="arrow-down"
                          content="Borrow"
                          color="good"
                          disabled={
                            !can ||
                            toInt(creditAmt) <= 0 ||
                            toInt(creditAmt) > limit
                          }
                          onClick={() =>
                            act('borrow', { amount: toInt(creditAmt) })
                          }
                        />
                        <Button
                          icon="arrow-up"
                          content="Repay"
                          color="average"
                          disabled={!can || owed <= 0 || balance <= 0}
                          onClick={() =>
                            act('repay', { amount: toInt(creditAmt) })
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item grow>
              <Stack fill vertical>
                <Stack.Item grow>
                  <Section title="ATMs" fill scrollable>
                    <Stack mb={1}>
                      <Stack.Item>
                        <AmountInput value={atmAmt} onChange={setAtmAmt} />
                      </Stack.Item>
                      <Stack.Item style={{ color: GREY }} fontSize="11px">
                        Amount to move per click
                      </Stack.Item>
                    </Stack>
                    {atms.length === 0 && (
                      <Box style={{ color: GREY }}>
                        No ATMs are connected to this network.
                      </Box>
                    )}
                    <Table>
                      {atms.map((a) => (
                        <Table.Row key={a.ref}>
                          <Table.Cell>
                            {a.name}
                            <Box fontSize="11px" style={{ color: GREY }}>
                              {a.area} · {fmtMoney(a.cash)}
                            </Box>
                          </Table.Cell>
                          <Table.Cell textAlign="right">
                            <Button
                              content="Fill"
                              disabled={!can || toInt(atmAmt) <= 0}
                              onClick={() =>
                                act('fill_atm', {
                                  ref: a.ref,
                                  amount: toInt(atmAmt),
                                })
                              }
                            />
                            <Button
                              content="Drain"
                              disabled={
                                !can || toInt(atmAmt) <= 0 || a.cash <= 0
                              }
                              onClick={() =>
                                act('drain_atm', {
                                  ref: a.ref,
                                  amount: toInt(atmAmt),
                                })
                              }
                            />
                          </Table.Cell>
                        </Table.Row>
                      ))}
                    </Table>
                  </Section>
                </Stack.Item>

                <Stack.Item grow>
                  <Section title="Loans" fill scrollable>
                    <Box mb={0.5} style={{ color: GREY }}>
                      Scan a card at a loan terminal to list it here.
                    </Box>
                    <Stack mb={1}>
                      <Stack.Item>
                        <AmountInput
                          value={loanAmt}
                          onChange={setLoanAmt}
                          placeholder="Amount"
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <AmountInput
                          value={loanRate}
                          onChange={setLoanRate}
                          width={60}
                          placeholder="%"
                        />
                      </Stack.Item>
                      <Stack.Item style={{ color: GREY }} fontSize="11px">
                        % per {data.interest_minutes}m
                      </Stack.Item>
                    </Stack>
                    {pending.length > 0 && (
                      <Table>
                        {pending.map((p) => (
                          <Table.Row key={p.account_id}>
                            <Table.Cell>
                              {p.holder}
                              <Box fontSize="11px" style={{ color: GREY }}>
                                expires in {fmtAge(p.remaining)}
                              </Box>
                            </Table.Cell>
                            <Table.Cell textAlign="right">
                              <Button
                                content="Lend"
                                color="good"
                                disabled={
                                  !can ||
                                  p.has_loan ||
                                  toInt(loanAmt) <= 0 ||
                                  toInt(loanAmt) > balance
                                }
                                tooltip={
                                  p.has_loan ? 'Already has an open loan' : null
                                }
                                onClick={() =>
                                  act('issue_loan', {
                                    account_id: p.account_id,
                                    amount: toInt(loanAmt),
                                    rate: ratePct / 100,
                                  })
                                }
                              />
                            </Table.Cell>
                          </Table.Row>
                        ))}
                      </Table>
                    )}
                    {loans.length > 0 && (
                      <Box mt={1}>
                        <Box bold mb={0.5}>
                          Open loans
                        </Box>
                        <Stack mb={0.5}>
                          <Stack.Item>
                            <AmountInput
                              value={collectAmt}
                              onChange={setCollectAmt}
                              placeholder="Collect"
                            />
                          </Stack.Item>
                        </Stack>
                        <Table>
                          {loans.map((l) => (
                            <Table.Row key={l.account_id}>
                              <Table.Cell>
                                {l.holder}
                                <Box fontSize="11px" style={{ color: GREY }}>
                                  owes {fmtMoney(l.owed)} of{' '}
                                  {fmtMoney(l.principal)} · {fmtPct(l.rate)}
                                </Box>
                              </Table.Cell>
                              <Table.Cell textAlign="right">
                                <Button
                                  content="Collect"
                                  disabled={
                                    !can ||
                                    !l.card_published ||
                                    toInt(collectAmt) <= 0
                                  }
                                  tooltip={
                                    l.card_published
                                      ? null
                                      : 'Their card must be published'
                                  }
                                  onClick={() =>
                                    act('collect', {
                                      account_id: l.account_id,
                                      amount: toInt(collectAmt),
                                    })
                                  }
                                />
                                <Button
                                  content="Forgive"
                                  color="bad"
                                  disabled={!can}
                                  onClick={() =>
                                    act('forgive', { account_id: l.account_id })
                                  }
                                />
                              </Table.Cell>
                            </Table.Row>
                          ))}
                        </Table>
                      </Box>
                    )}
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};
