// THIS IS A CRIMSON UI FILE
import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import {
  Box,
  LabeledList,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { SearchBar } from '../common/SearchBar';
import { bytes, count, exact, var_pair } from './format';
import {
  BytesBar,
  Mono,
  NumCell,
  PathCell,
  SortCell,
  TruncatedNotice,
  use_sort,
} from './parts';
import type { ListGroupRow, ListsReport } from './types';

type SortKey =
  | 'pair'
  | 'empty_rank'
  | 'empty_direct'
  | 'empty_capacity'
  | 'empty_bytes';

const SORT_VALUES: Record<SortKey, (row: ListGroupRow) => number | string> = {
  pair: (row) => var_pair(row),
  empty_rank: (row) => exact(row.empty_rank),
  empty_direct: (row) => exact(row.empty_direct),
  empty_capacity: (row) => exact(row.empty_capacity),
  empty_bytes: (row) => exact(row.empty_bytes),
};

/**
 * why the big number and the two counters behind it can disagree, in both directions.
 * nested empties are why a row can top the table with a `Direct` of zero, shared ones
 * are why its Bytes read lower than the count makes you expect.
 */
function rank_note(row: ListGroupRow): string {
  const rank = exact(row.empty_rank);
  const direct = exact(row.empty_direct);
  const rolled = exact(row.empty_lists);

  if (direct < rank) {
    return `${count(direct)} hang off the var itself, the rest are nested inside lists it holds`;
  }
  if (rolled < rank) {
    return `Only ${count(rolled)} could be pinned on this var - the rest are held in more than one place, so their bytes went on the shared pile`;
  }
  return 'All held directly by this var, and all of them chargeable to it';
}

/**
 * which type vars are sitting on all the empty lists.
 *
 * an empty list is not free: 24 bytes of header, a 4-byte slot in the list table, and
 * sometimes a leftover vector on top. none of that is big on its own, which is the
 * whole point - the cost is in the sheer number, and stations carry a shitload.
 *
 * its own view because the other two are capped and go biggest-first, and a bare empty
 * is the smallest row a world has. sorted by *how many* for the same reason: the vars
 * worth fixing hold thousands of tiny empties, not one biggish leftover.
 */
export function EmptyListsTable(props: { report: ListsReport }) {
  const { report } = props;
  const [search, set_search] = useState('');
  // default to the extension's own ranking, so an untouched table is in its order.
  const { sort, sort_props } = use_sort<SortKey>('empty_rank');

  const rows = useMemo(() => {
    const search_fn = createSearch(
      search,
      (row: ListGroupRow) => `${row.typepath} ${row.var}`,
    );
    const sorted = sortBy(report.empty_groups.filter(search_fn), [
      SORT_VALUES[sort.key],
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [report, search, sort]);

  const largest = Math.max(1, ...rows.map((row) => exact(row.empty_bytes)));

  // empties nothing here can put a name to. the extension adds this up over every pair
  // rather than over the rows below, so a cut-down page can't inflate it.
  const unnamed = exact(report.skipped.empty) - exact(report.empty_attributed);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Empty lists">
              {count(report.skipped.empty)} holding nothing, costing{' '}
              {bytes(report.empty_bytes)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Kept capacity"
              color={
                exact(report.empty_with_capacity) > 0 ? 'average' : undefined
              }
            >
              {count(report.empty_with_capacity)} kept their vector - room for{' '}
              {count(report.empty_capacity_slots)} elements they no longer have,
              at {bytes(report.empty_capacity_bytes)} a fresh empty list would
              not have cost. Usually means they got emptied one element at a
              time. One Cut() drops the whole thing.
            </LabeledList.Item>
            <LabeledList.Item label="Held by no named var">
              {count(unnamed)} of them, so nothing below can name them. Nested
              inside another list, sitting in a global, or orphaned.
            </LabeledList.Item>
            <LabeledList.Item label="Not counted">
              Every list also eats a 4-byte slot in the list table. That is over
              in the Overview&apos;s storage numbers, not the figure above.
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <TruncatedNotice
          truncated={report.empty_groups_truncated}
          shown={report.empty_groups.length}
          total={report.empty_groups_total}
          noun="type vars"
        />
      </Stack.Item>
      <Stack.Item grow>
        {/* keep the title - see PerListTable. */}
        <Section
          fill
          scrollable
          title="Empty lists by type var"
          buttons={
            <SearchBar
              expensive
              query={search}
              onSearch={set_search}
              placeholder="Filter by typepath or var name..."
              style={{ width: '24rem' }}
            />
          }
        >
          <Table>
            <Table.Row header>
              <SortCell {...sort_props('pair')}>Type var</SortCell>
              <SortCell collapsing {...sort_props('empty_rank')}>
                Empty
              </SortCell>
              <SortCell collapsing {...sort_props('empty_direct')}>
                Direct
              </SortCell>
              <SortCell collapsing {...sort_props('empty_capacity')}>
                Room for
              </SortCell>
              <SortCell {...sort_props('empty_bytes')}>Bytes</SortCell>
            </Table.Row>
            {rows.map((row) => (
              <Table.Row key={var_pair(row)} className="candystripe">
                <PathCell>
                  <Mono>{var_pair(row)}</Mono>
                </PathCell>
                <NumCell>
                  <Tooltip content={rank_note(row)}>
                    <Box
                      inline
                      color={
                        exact(row.empty_rank) !== exact(row.empty_direct) ||
                        exact(row.empty_rank) !== exact(row.empty_lists)
                          ? 'average'
                          : undefined
                      }
                    >
                      {count(row.empty_rank)}
                    </Box>
                  </Tooltip>
                </NumCell>
                <NumCell>
                  <Tooltip
                    content={`${count(row.direct_lists)} instances hold a list in this var, ${count(row.empty_direct)} of them empty`}
                  >
                    <Box inline>{count(row.empty_direct)}</Box>
                  </Tooltip>
                </NumCell>
                <NumCell>
                  {/* zero is healthy and common, so it reads as a dash rather
                      than a number worth scanning. */}
                  {exact(row.empty_capacity) > 0 ? (
                    <Box inline color="average">
                      {count(row.empty_capacity)}
                    </Box>
                  ) : (
                    <Box inline color="label">
                      -
                    </Box>
                  )}
                </NumCell>
                <Table.Cell>
                  <BytesBar
                    value={row.empty_bytes}
                    max={largest}
                    color="orange"
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
    </Stack>
  );
}
