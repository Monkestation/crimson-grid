// THIS IS A CRIMSON UI FILE
import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { SearchBar } from '../common/SearchBar';
import {
  bytes,
  count,
  delta_color,
  duration,
  exact,
  meta_for,
  signed_bytes,
  signed_count,
} from './format';
import {
  EmptyState,
  NumCell,
  PathCell,
  SortCell,
  TruncatedNotice,
  use_sort,
} from './parts';
import type { Data, DiffRow } from './types';

type SortKey = 'typepath' | 'count_change' | 'bytes_change' | 'count_after';

const SORT_VALUES: Record<SortKey, (row: DiffRow) => number | string> = {
  typepath: (row) => row.typepath,
  count_change: (row) => exact(row.count_change),
  bytes_change: (row) => exact(row.bytes_change),
  count_after: (row) => exact(row.count_after),
};

export function DiffTab() {
  const { act, data } = useBackend<Data>();
  const { diff_report, busy, report_meta, baseline_at, baseline_by } = data;
  const [search, set_search] = useState('');
  const { sort, sort_props } = use_sort<SortKey>('bytes_change');

  const rows = useMemo(() => {
    if (!diff_report) {
      return [];
    }
    const search_fn = createSearch(search, (row: DiffRow) => row.typepath);
    const sorted = sortBy(diff_report.types.filter(search_fn), [
      SORT_VALUES[sort.key],
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [diff_report, search, sort]);

  const meta = meta_for(report_meta, 'diff');

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Baseline">
          <Stack vertical>
            <Stack.Item>
              <Stack align="center">
                <Stack.Item>
                  <Button
                    icon="flag"
                    disabled={!!busy}
                    onClick={() => act('set_baseline')}
                  >
                    Set baseline
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="scale-balanced"
                    disabled={!!busy || !baseline_at}
                    onClick={() => act('capture_diff')}
                  >
                    Compare against it
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    icon="trash"
                    color="bad"
                    disabled={!!busy}
                    onClick={() => act('clear')}
                  >
                    Clear
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item grow>
                  <Box color="label" textAlign="right">
                    {baseline_at
                      ? `${baseline_by} set the baseline at ${baseline_at}`
                      : 'no baseline yet'}
                    {meta
                      ? `, last one froze the server for ${duration(meta.duration_ds)}`
                      : ''}
                  </Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <NoticeBox info>
                Round start against round end is what actually finds a leak.
                Absolute numbers rarely do. There is only ever one baseline and
                every comparison replaces it, so back-to-back ones each measure
                from the last. The Memory Census (Text) verb shares it with this
                panel.
              </NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      {!diff_report ? (
        <Stack.Item>
          <EmptyState>
            Set a baseline, let the round run, then compare. Types that did not
            move get dropped and the rest come back sorted by how much they
            grew.
          </EmptyState>
        </Stack.Item>
      ) : diff_report.no_baseline ? (
        <Stack.Item>
          <NoticeBox color="yellow">
            That one only set a baseline, so there was nothing to compare it
            against yet. Go again to see what moved.
          </NoticeBox>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item
                  label="Lists"
                  color={delta_color(diff_report.list_count_change)}
                >
                  {signed_count(diff_report.list_count_change)} lists,{' '}
                  {signed_bytes(diff_report.list_bytes_change)}
                </LabeledList.Item>
                <LabeledList.Item label="Types moved">
                  {count(diff_report.types_total)}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <TruncatedNotice
              truncated={diff_report.types_truncated}
              shown={diff_report.types.length}
              total={diff_report.types_total}
              noun="changed typepaths"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Changed typepaths"
              buttons={
                <SearchBar
                  expensive
                  query={search}
                  onSearch={set_search}
                  placeholder="Filter typepaths..."
                  style={{ width: '20rem' }}
                />
              }
            >
              <Table>
                <Table.Row header>
                  <SortCell {...sort_props('typepath')}>Typepath</SortCell>
                  <SortCell collapsing {...sort_props('count_after')}>
                    Instances
                  </SortCell>
                  <SortCell collapsing {...sort_props('count_change')}>
                    Change
                  </SortCell>
                  <Table.Cell collapsing>Bytes</Table.Cell>
                  <SortCell collapsing {...sort_props('bytes_change')}>
                    Change
                  </SortCell>
                </Table.Row>
                {rows.map((row) => (
                  <Table.Row key={row.typepath} className="candystripe">
                    <PathCell>{row.typepath}</PathCell>
                    <NumCell>
                      {count(row.count_before)} to {count(row.count_after)}
                    </NumCell>
                    <NumCell color={delta_color(row.count_change)}>
                      {signed_count(row.count_change)}
                    </NumCell>
                    <NumCell>
                      {bytes(row.bytes_before)} to {bytes(row.bytes_after)}
                    </NumCell>
                    <NumCell color={delta_color(row.bytes_change)}>
                      {signed_bytes(row.bytes_change)}
                    </NumCell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
}
