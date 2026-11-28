import { useState } from 'react';
import {
  Box,
  Button,
  Chart,
  Input,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const GREEN = '#1b7a34';
const RED = '#c62828';
const upDown = (n) => (n >= 0 ? GREEN : RED);

const fmtMoney = (n) => `${Math.round(Number(n) || 0).toLocaleString()} ₡`;
const fmtPrice = (n) => (Number(n) || 0).toFixed(2);
const fmtUnits = (n) => (Number(n) || 0).toFixed(4);
const pctChange = (now, before) =>
  before > 0 ? ((now - before) / before) * 100 : 0;

const curveParams = (s) => {
  const float = Number(s?.float_shares) || 1;
  return {
    k: (Number(s?.impact_k) || 0) / float,
    F: Number(s?.fundamental) || 0,
    h0: Number(s?.held) || 0,
    cap: Math.max(0, Number(s?.max_buyable) || 0),
  };
};

const curveCost = (s, shares, buying) => {
  const { k, F, h0 } = curveParams(s);
  if (shares <= 0) return 0;
  if (!k) return F * shares;
  const h1 = h0 + (buying ? shares : -shares);
  return Math.abs((F * (Math.exp(k * h1) - Math.exp(k * h0))) / k);
};

const priceAfter = (s, shares, buying) => {
  const { k, F, h0 } = curveParams(s);
  const h1 = h0 + (buying ? shares : -shares);
  return Math.max(1, F * Math.exp(k * h1));
};

// Largest buy the pool cash covers and the market allows.
const maxAffordable = (s, cash) => {
  const { k, F, h0, cap } = curveParams(s);
  if (!(F > 0) || cash <= 0) return 0;
  let n;
  if (!k) {
    n = Math.floor(cash / F);
  } else {
    n = Math.floor(Math.log(Math.exp(k * h0) + (cash * k) / F) / k - h0);
  }
  n = Math.min(n, cap);
  while (n > 0 && Math.round(curveCost(s, n, true)) > cash) n--;
  return Math.max(0, n);
};

export const PcEtf = (props, context) => {
  const { act, data = {} } = useProgram(props.programId, context);

  const [tab, setTab] = useState(0);
  const [selected, setSelected] = useState(null);
  const [amount, setAmount] = useState('1');

  const holder = data.holder;
  const balance = Number(data.balance) || 0;
  const networkName = data.network_name || 'No Network';
  const etfAvailable = !!data.etf_available;
  const pending = Array.isArray(data.pending) ? data.pending : [];
  const members = Array.isArray(data.members) ? data.members : [];
  const stocks = Array.isArray(data.stocks) ? data.stocks : [];
  const etfNav = Number(data.etf_nav) || 0;
  const etfPoolValue = Number(data.etf_pool_value) || 0;
  const etfTotalShares = Number(data.etf_total_shares) || 0;
  const etfCash = Number(data.etf_cash) || 0;
  const error = data.error;

  const amountNum = Math.max(0, parseInt(String(amount), 10) || 0);

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
        No account data. Log in with a credit card and open the ETF program
        again.
      </Box>
    );
  }

  if (!etfAvailable) {
    return (
      <Box p={2} style={{ color: '#555' }}>
        This network has no ETF.
      </Box>
    );
  }

  const current =
    stocks.find((s) => s.ticker === selected) || stocks[0] || null;
  const price = Number(current?.price) || 0;
  const fundamental = Number(current?.fundamental) || 0;
  const owned = Number(current?.owned) || 0;
  const history = Array.isArray(current?.history) ? current.history : [];
  const chartData = history.map((y, i) => [i, Number(y) || 0]);
  const minY = history.length ? Math.min(...history) * 0.98 : 0;
  const maxY = history.length ? Math.max(...history) * 1.02 : 1;
  const trending = pctChange(price, Number(current?.last_price) || price);
  const premium = fundamental > 0 ? (price / fundamental - 1) * 100 : 0;

  // Buy preview, clamped to market depth
  const maxBuyable = Number(current?.max_buyable) || 0;
  const buyCount = Math.min(amountNum, maxBuyable);
  const buyCost = current ? Math.round(curveCost(current, buyCount, true)) : 0;
  const buyAvg = buyCount > 0 ? buyCost / buyCount : 0;
  const buyAfter =
    current && buyCount > 0 ? priceAfter(current, buyCount, true) : price;
  const maxAfford = current ? maxAffordable(current, etfCash) : 0;

  // Sell preview, clamped to pool holdings
  const sellCount = Math.min(amountNum, owned);
  const sellGross = current
    ? Math.round(curveCost(current, sellCount, false))
    : 0;
  const sellAvg = sellCount > 0 ? sellGross / sellCount : 0;
  const sellAfter =
    current && sellCount > 0 ? priceAfter(current, sellCount, false) : price;

  return (
    <Box
      p={1}
      style={{ color: '#000', height: '100%', boxSizing: 'border-box' }}
    >
      <Stack fill vertical>
        <Stack.Item>
          <Section title={`Night Exchange ETF — ${networkName}`}>
            <Stack>
              <Stack.Item grow>
                Operator:{' '}
                <Box inline fontWeight="bold">
                  {holder}
                </Box>
                <Box mt={0.5}>
                  Personal cash:{' '}
                  <Box inline fontWeight="bold" style={{ color: GREEN }}>
                    {fmtMoney(balance)}
                  </Box>
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box fontSize="12px" textAlign="right">
                  <Box>
                    NAV{' '}
                    <Box inline fontFamily="monospace" fontWeight="bold">
                      {fmtMoney(etfNav)}
                    </Box>
                  </Box>
                  <Box mt={0.3}>
                    Pool{' '}
                    <Box inline fontWeight="bold">
                      {fmtMoney(etfPoolValue)}
                    </Box>
                  </Box>
                  <Box mt={0.3} style={{ color: '#555' }}>
                    Cash {fmtMoney(etfCash)} · {fmtUnits(etfTotalShares)} units
                  </Box>
                </Box>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>

        <Stack.Item>
          <Tabs>
            <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>
              Trade Pool
            </Tabs.Tab>
            <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
              Members{pending.length > 0 ? ` (${pending.length})` : ''}
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>

        <Stack.Item grow>
          {tab === 0 && (
            <Stack fill>
              <Stack.Item basis="42%">
                <Section title="Listed Companies" fill scrollable>
                  <Table>
                    <Table.Row header>
                      <Table.Cell>Ticker</Table.Cell>
                      <Table.Cell textAlign="right">Price</Table.Cell>
                      <Table.Cell textAlign="right">Change</Table.Cell>
                      <Table.Cell textAlign="right">Pool</Table.Cell>
                    </Table.Row>
                    {stocks.map((s) => {
                      const change = pctChange(
                        Number(s.price) || 0,
                        Number(s.last_price) || 0,
                      );
                      return (
                        <Table.Row key={s.ticker}>
                          <Table.Cell>
                            <Button
                              fluid
                              selected={current?.ticker === s.ticker}
                              content={s.ticker}
                              tooltip={s.name}
                              onClick={() => setSelected(s.ticker)}
                            />
                          </Table.Cell>
                          <Table.Cell textAlign="right" fontFamily="monospace">
                            {fmtPrice(s.price)}
                          </Table.Cell>
                          <Table.Cell
                            textAlign="right"
                            fontFamily="monospace"
                            style={{ color: upDown(change) }}
                          >
                            {change >= 0 ? '+' : ''}
                            {change.toFixed(2)}%
                          </Table.Cell>
                          <Table.Cell textAlign="right">
                            {s.owned > 0 ? s.owned : '—'}
                          </Table.Cell>
                        </Table.Row>
                      );
                    })}
                  </Table>
                </Section>
              </Stack.Item>

              <Stack.Item grow>
                <Section
                  title={
                    current ? `${current.ticker} — ${current.name}` : 'Select'
                  }
                  fill
                  scrollable
                >
                  {current && (
                    <>
                      <Box mb={1} style={{ color: '#555' }}>
                        {current.desc}
                      </Box>
                      <Box fontSize="18px" mb={0.5}>
                        {fmtPrice(price)} ₡{' '}
                        <Box
                          inline
                          fontSize="13px"
                          style={{ color: upDown(trending) }}
                        >
                          {trending >= 0 ? '▲' : '▼'}{' '}
                          {Math.abs(trending).toFixed(2)}%
                        </Box>
                      </Box>
                      <Box mb={1}>
                        <Chart.Line
                          height="90px"
                          data={chartData}
                          rangeX={[0, Math.max(1, chartData.length - 1)]}
                          rangeY={[minY, maxY]}
                          strokeColor={
                            trending >= 0
                              ? 'rgba(27,122,52,1)'
                              : 'rgba(198,40,40,1)'
                          }
                          fillColor={
                            trending >= 0
                              ? 'rgba(27,122,52,0.15)'
                              : 'rgba(198,40,40,0.15)'
                          }
                        />
                      </Box>
                      <Box mb={0.5} style={{ color: '#555' }}>
                        Sector: {current.sector} · Dividend:{' '}
                        {((Number(current.dividend) || 0) * 100).toFixed(1)}%
                      </Box>
                      <Box mb={0.5} fontSize="12px" style={{ color: '#555' }}>
                        Demand premium: {premium >= 0 ? '+' : ''}
                        {premium.toFixed(1)}% over fundamentals · Market depth
                        left: {maxBuyable.toLocaleString()} shares
                      </Box>
                      <Box mb={1}>
                        Pool owns: <b>{owned}</b> shares
                      </Box>

                      <Box mb={0.5} style={{ color: '#555' }}>
                        Shares
                      </Box>
                      <Stack>
                        <Stack.Item>
                          <Box style={{ width: 100 }}>
                            <Input
                              fluid
                              value={String(amount)}
                              placeholder="1"
                              onInput={(a, b) => setAmount(readInput(a, b))}
                              onChange={(a, b) => setAmount(readInput(a, b))}
                            />
                          </Box>
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            content="Max"
                            onClick={() =>
                              setAmount(String(Math.max(1, maxAfford)))
                            }
                          />
                          <Button
                            content="All"
                            disabled={owned <= 0}
                            onClick={() => setAmount(String(owned))}
                          />
                        </Stack.Item>
                      </Stack>

                      <Box mt={0.5} fontSize="11px" style={{ color: '#555' }}>
                        Buy {buyCount}: {fmtMoney(buyCost)} · avg{' '}
                        {fmtPrice(buyAvg)} · price → {fmtPrice(buyAfter)} (pool
                        cash {fmtMoney(etfCash)})
                        {amountNum > buyCount && (
                          <Box inline style={{ color: RED }}>
                            {' '}
                            (market only has {maxBuyable} left)
                          </Box>
                        )}
                      </Box>
                      {sellCount > 0 && (
                        <Box fontSize="11px" style={{ color: '#555' }}>
                          Sell {sellCount}: {fmtMoney(sellGross)} · avg{' '}
                          {fmtPrice(sellAvg)} · price → {fmtPrice(sellAfter)}
                        </Box>
                      )}

                      <Box mt={1}>
                        <Button
                          icon="arrow-down"
                          content="Buy for Pool"
                          color="good"
                          disabled={buyCount <= 0 || buyCost > etfCash}
                          onClick={() =>
                            act('pool_buy', {
                              ticker: current.ticker,
                              amount: buyCount,
                            })
                          }
                        />
                        <Button
                          icon="arrow-up"
                          content="Sell from Pool"
                          color="average"
                          disabled={amountNum <= 0 || owned <= 0}
                          onClick={() =>
                            act('pool_sell', {
                              ticker: current.ticker,
                              amount: sellCount,
                            })
                          }
                        />
                      </Box>
                    </>
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          )}

          {tab === 1 && (
            <Stack fill vertical>
              <Stack.Item>
                <Section title="Pending Card Scans">
                  {pending.length === 0 ? (
                    <Box p={1} style={{ color: '#555' }}>
                      No cards published. Scan a credit/ID card at a network
                      card reader.
                    </Box>
                  ) : (
                    <Table>
                      <Table.Row header>
                        <Table.Cell>Account</Table.Cell>
                        <Table.Cell>Expires</Table.Cell>
                        <Table.Cell />
                      </Table.Row>
                      {pending.map((p) => (
                        <Table.Row key={p.account_id}>
                          <Table.Cell>
                            <Box fontWeight="bold">{p.holder}</Box>
                            <Box fontSize="11px" style={{ color: '#555' }}>
                              {p.account_id}
                            </Box>
                          </Table.Cell>
                          <Table.Cell fontFamily="monospace">
                            {p.expires_in}s
                          </Table.Cell>
                          <Table.Cell>
                            <Button
                              icon="user-plus"
                              content="Enroll"
                              color="good"
                              onClick={() =>
                                act('enroll', { account_id: p.account_id })
                              }
                            />
                          </Table.Cell>
                        </Table.Row>
                      ))}
                    </Table>
                  )}
                </Section>
              </Stack.Item>

              <Stack.Item grow>
                <Section title="Enrolled Members" fill scrollable>
                  {members.length === 0 ? (
                    <Box p={1} style={{ color: '#555' }}>
                      No members yet.
                    </Box>
                  ) : (
                    <Table>
                      <Table.Row header>
                        <Table.Cell>Holder</Table.Cell>
                        <Table.Cell textAlign="right">Units</Table.Cell>
                        <Table.Cell textAlign="right">Value</Table.Cell>
                      </Table.Row>
                      {members.map((m) => (
                        <Table.Row key={m.account_id}>
                          <Table.Cell>{m.holder}</Table.Cell>
                          <Table.Cell textAlign="right" fontFamily="monospace">
                            {fmtUnits(m.shares)}
                          </Table.Cell>
                          <Table.Cell textAlign="right" fontFamily="monospace">
                            {fmtMoney(m.value)}
                          </Table.Cell>
                        </Table.Row>
                      ))}
                    </Table>
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};
