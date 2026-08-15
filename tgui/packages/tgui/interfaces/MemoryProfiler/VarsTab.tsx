// THIS IS A CRIMSON UI FILE
import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import { Box, LabeledList, Section, Stack, Table } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { SearchBar } from '../common/SearchBar';
import { bytes, count, exact, meta_for } from './format';
import {
  BytesBar,
  EmptyState,
  NumCell,
  PathCell,
  ReportHeader,
  SortCell,
  TruncatedNotice,
  use_sort,
} from './parts';
import type { Data, VarRow } from './types';

type SortKey = 'name' | 'count' | 'bytes';

const SORT_VALUES: Record<SortKey, (row: VarRow) => number | string> = {
  name: (row) => row.name,
  count: (row) => exact(row.count),
  bytes: (row) => exact(row.bytes),
};

export function VarsTab() {
  const { act, data } = useBackend<Data>();
  const { vars_report, busy, report_meta } = data;
  const [search, set_search] = useState('');
  const { sort, sort_props } = use_sort<SortKey>('bytes');

  const rows = useMemo(() => {
    if (!vars_report) {
      return [];
    }
    const search_fn = createSearch(search, (row: VarRow) => row.name);
    const sorted = sortBy(vars_report.vars.filter(search_fn), [
      SORT_VALUES[sort.key],
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [vars_report, search, sort]);

  const largest = Math.max(1, ...rows.map((row) => exact(row.bytes)));

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <ReportHeader
            label="Count the vars"
            busy={busy}
            onCapture={() => act('capture_vars')}
            meta={meta_for(report_meta, 'vars')}
          />
        </Section>
      </Stack.Item>
      {!vars_report ? (
        <Stack.Item>
          <EmptyState>
            A var row only exists where a var got set away from its type
            default, 16 bytes a pop. A var on /atom that every atom sets is a
            real thing you can go delete, and this is how you find it.
          </EmptyState>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item label="Var rows">
                  {count(vars_report.var_rows_total)} rows across{' '}
                  {count(vars_report.vars_total)} distinct names
                </LabeledList.Item>
                <LabeledList.Item label="Total cost">
                  {bytes(vars_report.var_bytes)}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <TruncatedNotice
              truncated={vars_report.vars_truncated}
              shown={vars_report.vars.length}
              total={vars_report.vars_total}
              noun="var names"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Var names"
              buttons={
                <SearchBar
                  expensive
                  query={search}
                  onSearch={set_search}
                  placeholder="Filter var names..."
                  style={{ width: '20rem' }}
                />
              }
            >
              <Table>
                <Table.Row header>
                  <SortCell {...sort_props('name')}>Var name</SortCell>
                  <SortCell collapsing {...sort_props('count')}>
                    Rows
                  </SortCell>
                  <SortCell {...sort_props('bytes')}>Bytes</SortCell>
                </Table.Row>
                {rows.map((row) => (
                  <Table.Row key={row.name} className="candystripe">
                    <PathCell>
                      <Box inline>{row.name}</Box>
                    </PathCell>
                    <NumCell>{count(row.count)}</NumCell>
                    <Table.Cell>
                      <BytesBar
                        value={row.bytes}
                        max={largest}
                        color="purple"
                      />
                    </Table.Cell>
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
