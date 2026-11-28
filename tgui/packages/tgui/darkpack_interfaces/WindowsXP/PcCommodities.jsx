import { useState } from 'react';
import {
  Box,
  Button,
  Chart,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const GREEN = '#1b7a34';
const RED = '#c62828';
const GREY = '#555';
const upDown = (n) => (n >= 0 ? GREEN : RED);
const fmtPrice = (n) => (Number(n) || 0).toFixed(2);
const pctChange = (now, before) =>
  before > 0 ? ((now - before) / before) * 100 : 0;

export const PcCommodities = (props, context) => {
  const { data = {} } = useProgram(props.programId, context);
  const items = Array.isArray(data.commodities) ? data.commodities : [];
  const [selected, setSelected] = useState(null);

  const current = items.find((s) => s.ticker === selected) || items[0] || null;
  const price = Number(current?.price) || 0;
  const coupon = Number(current?.coupon) || 0;
  const history = Array.isArray(current?.history) ? current.history : [];
  const chartData = history.map((y, i) => [i, Number(y) || 0]);
  const minY = history.length ? Math.min(...history) * 0.98 : 0;
  const maxY = history.length ? Math.max(...history) * 1.02 : 1;
  const trending = pctChange(price, Number(current?.last_price) || price);
  const first = history.length ? Number(history[0]) || 0 : 0;
  const overall = pctChange(price, first);

  return (
    <Box
      p={1}
      style={{ color: '#000', height: '100%', boxSizing: 'border-box' }}
    >
      <Stack fill>
        <Stack.Item basis="48%">
          <Section title="Commodity Desk" fill scrollable>
            <Table>
              <Table.Row header>
                <Table.Cell>Ticker</Table.Cell>
                <Table.Cell textAlign="right">Price</Table.Cell>
                <Table.Cell textAlign="right">Change</Table.Cell>
              </Table.Row>
              {items.map((s) => {
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
                        tooltip={`${s.name} (${s.kind})`}
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
                  </Table.Row>
                );
              })}
            </Table>
          </Section>
        </Stack.Item>

        <Stack.Item grow>
          <Section
            title={current ? `${current.ticker} — ${current.name}` : 'Select'}
            fill
            scrollable
          >
            {current && (
              <>
                <Box mb={1} style={{ color: GREY }}>
                  {current.desc}
                </Box>
                <Box fontSize="18px" mb={0.5}>
                  {fmtPrice(price)} ₡{' '}
                  <Box
                    inline
                    fontSize="13px"
                    style={{ color: upDown(trending) }}
                  >
                    {trending >= 0 ? '▲' : '▼'} {Math.abs(trending).toFixed(2)}%
                  </Box>
                </Box>
                <Box mb={1}>
                  <Chart.Line
                    height="90px"
                    data={chartData}
                    rangeX={[0, Math.max(1, chartData.length - 1)]}
                    rangeY={[minY, maxY]}
                    strokeColor={
                      overall >= 0
                        ? 'rgba(27, 122, 52, 1)'
                        : 'rgba(198, 40, 40, 1)'
                    }
                    fillColor={
                      overall >= 0
                        ? 'rgba(27, 122, 52, 0.15)'
                        : 'rgba(198, 40, 40, 0.15)'
                    }
                  />
                </Box>
                <Box style={{ color: GREY }}>
                  Type: {current.kind}
                  {coupon > 0 && <> · Yield: {(coupon * 100).toFixed(2)}%</>}
                </Box>
                <Box style={{ color: GREY }}>
                  Range: {fmtPrice(Math.min(...history))} –{' '}
                  {fmtPrice(Math.max(...history))} ·{' '}
                  <Box inline style={{ color: upDown(overall) }}>
                    {overall >= 0 ? '+' : ''}
                    {overall.toFixed(2)}% over the window
                  </Box>
                </Box>
              </>
            )}
          </Section>
        </Stack.Item>
      </Stack>
    </Box>
  );
};
