import { useState } from 'react';
import {
  Box,
  Button,
  Chart,
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

// Darker green reads better on the light terminal background than tgui's "good".
const GREEN = '#1b7a34';
const RED = '#c62828';
const upDown = (n) => (n >= 0 ? GREEN : RED);

const fmtMoney = (n) => `${Math.round(Number(n) || 0).toLocaleString()} ₡`;
const fmtPrice = (n) => (Number(n) || 0).toFixed(2);
const pctChange = (now, before) =>
  before > 0 ? ((now - before) / before) * 100 : 0;
const fmtTime = (s) => {
  const secs = Math.max(0, Math.round(s));
  const m = Math.floor(secs / 60);
  const r = secs % 60;
  return `${m}m ${String(r).padStart(2, '0')}s`;
};

// oldest lots sell first, only short-term lots are taxed.
const previewSale = (lots, price, sellShares, feeRate, taxRate, longTerm) => {
  let remaining = sellShares;
  let shortGain = 0;
  for (const lot of lots) {
    if (remaining <= 0) break;
    const [shares, cost, age] = lot.map((v) => Number(v) || 0);
    if (shares <= 0) continue;
    const take = Math.min(shares, remaining);
    const takeCost = Math.round(cost * (take / shares));
    if (age < longTerm) {
      shortGain += Math.round(price * take) - takeCost;
    }
    remaining -= take;
  }
  const gross = Math.round(price * sellShares);
  const fee = Math.max(1, Math.round(gross * feeRate));
  const tax = Math.round(Math.max(0, shortGain) * taxRate);
  return { gross, fee, tax, net: Math.max(0, gross - fee - tax) };
};

export const PcStockMarket = (props, context) => {
  const { act, data = {} } = useProgram(props.programId, context);

  const holder = data.holder;
  const balance = Number(data.balance) || 0;
  const debt = Number(data.debt) || 0;
  const portfolioValue = Number(data.portfolio_value) || 0;
  const fee = Number(data.fee) || 0;
  const taxRate = Number(data.tax_rate) || 0;
  const longTerm = Number(data.long_term_seconds) || 0;
  const garnish = Number(data.garnish) || 0;
  const stocks = Array.isArray(data.stocks) ? data.stocks : [];
  const error = data.error;

  const [selected, setSelected] = useState(null);
  const [amount, setAmount] = useState('1');

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
        No account data. Log in with a credit card and open Night Exchange
        again.
      </Box>
    );
  }

  const current =
    stocks.find((s) => s.ticker === selected) || stocks[0] || null;

  const price = Number(current?.price) || 0;
  const owned = Number(current?.owned) || 0;
  const costBasis = Number(current?.cost_basis) || 0;
  const lots = Array.isArray(current?.lots) ? current.lots : [];
  const history = Array.isArray(current?.history) ? current.history : [];
  const chartData = history.map((y, i) => [i, Number(y) || 0]);
  const minY = history.length ? Math.min(...history) * 0.98 : 0;
  const maxY = history.length ? Math.max(...history) * 1.02 : 1;

  const buyCost = Math.round(price * amountNum);
  const buyFee = Math.max(1, Math.round(buyCost * fee));
  const maxAffordable =
    price > 0 ? Math.max(0, Math.floor(balance / (price * (1 + fee)) - 1)) : 0;

  const sellCount = Math.min(amountNum, owned);
  const sale =
    sellCount > 0
      ? previewSale(lots, price, sellCount, fee, taxRate, longTerm)
      : null;

  const shortLots = lots.filter((l) => (Number(l[2]) || 0) < longTerm);
  const shortShares = shortLots.reduce((n, l) => n + (Number(l[0]) || 0), 0);
  const nextLongTerm = shortLots.length
    ? longTerm - Math.min(...shortLots.map((l) => Number(l[2]) || 0))
    : 0;
  const oldestShort = shortLots.length
    ? longTerm - Math.max(...shortLots.map((l) => Number(l[2]) || 0))
    : 0;

  const profit = owned > 0 ? Math.round(price * owned - costBasis) : 0;
  const trending = pctChange(price, Number(current?.last_price) || price);

  const outlookColor = (o) =>
    o === 'bullish' ? GREEN : o === 'bearish' ? RED : '#555';

  return (
    <Box
      p={1}
      style={{ color: '#000', height: '100%', boxSizing: 'border-box' }}
    >
      <Stack fill vertical>
        <Stack.Item>
          <Section title={`Night Exchange — ${holder || 'Unknown'}`}>
            <Stack>
              <Stack.Item grow>
                Cash:{' '}
                <Box inline fontWeight="bold" style={{ color: GREEN }}>
                  {fmtMoney(balance)}
                </Box>
                {debt > 0 && (
                  <Box color="average" fontSize="12px">
                    Debt: {fmtMoney(debt)} ({(garnish * 100).toFixed(0)}% of
                    sale proceeds are seized)
                  </Box>
                )}
              </Stack.Item>
              <Stack.Item grow>
                Portfolio:{' '}
                <Box inline fontWeight="bold">
                  {fmtMoney(portfolioValue)}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box
                  fontSize="11px"
                  textAlign="right"
                  style={{ color: '#555' }}
                >
                  Broker fee {(fee * 100).toFixed(1)}%
                  <br />
                  <Box inline style={{ color: RED }}>
                    Short-term tax {(taxRate * 100).toFixed(0)}%
                  </Box>
                </Box>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>

        <Stack.Item grow>
          <Stack fill>
            <Stack.Item basis="48%">
              <Section title="Listed Companies" fill scrollable>
                <Table>
                  <Table.Row header>
                    <Table.Cell>Ticker</Table.Cell>
                    <Table.Cell textAlign="right">Price</Table.Cell>
                    <Table.Cell textAlign="right">Change</Table.Cell>
                    <Table.Cell textAlign="right">Held</Table.Cell>
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
                    <Box
                      mb={current.secret ? 0.5 : 1}
                      style={{ color: '#555' }}
                    >
                      {current.desc}
                    </Box>
                    {current.secret && (
                      <Box mb={1} italic fontSize="12px" color="average">
                        Whisper: {current.secret}
                      </Box>
                    )}
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
                            ? 'rgba(27, 122, 52, 1)'
                            : 'rgba(198, 40, 40, 1)'
                        }
                        fillColor={
                          trending >= 0
                            ? 'rgba(27, 122, 52, 0.15)'
                            : 'rgba(198, 40, 40, 0.15)'
                        }
                      />
                    </Box>
                    <Box mb={0.5} style={{ color: '#555' }}>
                      Sector: {current.sector} · Dividend:{' '}
                      {((Number(current.dividend) || 0) * 100).toFixed(1)}%
                      {current.outlook && (
                        <>
                          {' '}
                          · Analyst outlook:{' '}
                          <Box
                            inline
                            bold
                            style={{ color: outlookColor(current.outlook) }}
                          >
                            {current.outlook}
                          </Box>
                        </>
                      )}
                    </Box>
                    <Box mb={0.5}>
                      You own: <b>{owned}</b> shares
                      {owned > 0 && (
                        <Box inline ml={1} style={{ color: upDown(profit) }}>
                          ({profit >= 0 ? '+' : ''}
                          {profit.toLocaleString()} ₡)
                        </Box>
                      )}
                    </Box>
                    {shortShares > 0 && (
                      <Box mb={1} fontSize="12px" style={{ color: RED }}>
                        {shortShares} share{shortShares === 1 ? '' : 's'} in the
                        short-term window: gains are taxed{' '}
                        {(taxRate * 100).toFixed(0)}%. Oldest clears in{' '}
                        {fmtTime(oldestShort)}
                        {shortLots.length > 1
                          ? `, newest in ${fmtTime(nextLongTerm)}`
                          : ''}
                        .
                      </Box>
                    )}

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
                            setAmount(String(Math.max(1, maxAffordable)))
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
                      Buy: {fmtMoney(buyCost)} + {fmtMoney(buyFee)} fee
                    </Box>
                    {sale && (
                      <Box fontSize="11px" style={{ color: '#555' }}>
                        Sell {sellCount}: {fmtMoney(sale.gross)} − fee{' '}
                        {fmtMoney(sale.fee)}
                        {sale.tax > 0 && (
                          <>
                            {' '}
                            −{' '}
                            <Box inline style={{ color: RED }}>
                              tax {fmtMoney(sale.tax)}
                            </Box>
                          </>
                        )}{' '}
                        = <b>{fmtMoney(sale.net)}</b>
                      </Box>
                    )}

                    <Box mt={1}>
                      <Button
                        icon="arrow-down"
                        content="Buy"
                        color="good"
                        disabled={amountNum <= 0 || buyCost + buyFee > balance}
                        onClick={() =>
                          act('buy', {
                            ticker: current.ticker,
                            amount: amountNum,
                          })
                        }
                      />
                      <Button
                        icon="arrow-up"
                        content="Sell"
                        color="average"
                        disabled={amountNum <= 0 || owned <= 0}
                        onClick={() =>
                          act('sell', {
                            ticker: current.ticker,
                            amount: sellCount,
                          })
                        }
                      />
                      <Button
                        icon="dollar-sign"
                        content="Sell All"
                        color="bad"
                        disabled={owned <= 0}
                        onClick={() =>
                          act('sell_all', {
                            ticker: current.ticker,
                          })
                        }
                      />
                    </Box>
                  </>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};
