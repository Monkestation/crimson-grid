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
import { exhaustiveCheck } from 'tgui-core/exhaustive';
import { createSearch } from 'tgui-core/string';

import { SearchBar } from '../common/SearchBar';
import { bytes, count, exact, varPair } from './format';
import { BytesBar, SortCell, TruncatedNotice, useSort } from './parts';
import type { ListGroupRow, ListsReport } from './types';

type SortKey =
  | 'pair'
  | 'empty_rank'
  | 'empty_direct'
  | 'empty_capacity'
  | 'empty_bytes';

function sortValue(row: ListGroupRow, key: SortKey): number | string {
  switch (key) {
    case 'pair':
      return varPair(row);
    case 'empty_rank':
      return exact(row.empty_rank);
    case 'empty_direct':
      return exact(row.empty_direct);
    case 'empty_capacity':
      return exact(row.empty_capacity);
    case 'empty_bytes':
      return exact(row.empty_bytes);
    default:
      return exhaustiveCheck(key);
  }
}

/**
 * Why the headline count and the two counters behind it can disagree.
 *
 * Both directions are worth saying out loud. Nested empties are why a row can
 * lead the table with a `Direct` of zero; shared ones are why a row's Bytes can
 * read lower than its count suggests.
 */
function rankNote(row: ListGroupRow): string {
  const rank = exact(row.empty_rank);
  const direct = exact(row.empty_direct);
  const rolled = exact(row.empty_lists);

  if (direct < rank) {
    return `${count(direct)} hang off the var itself; the rest are nested inside lists it holds`;
  }
  if (rolled < rank) {
    return `Only ${count(rolled)} could be charged to this var - the rest are held more than once, so their bytes went to the shared bucket`;
  }
  return 'All held directly by this var, and all chargeable to it';
}

/**
 * Which type vars hold the empty lists.
 *
 * An empty list is not free: 24 bytes of header each, plus a 4-byte slot in the
 * list table, plus sometimes a small vector remnant. None of those is large on
 * its own, which is the whole point - the cost is in the count, and a station
 * carries several hundred thousand of them.
 *
 * Its own view rather than a filter over the other two, because both of those
 * are ordered by size and capped, and a bare empty is the smallest row a world
 * has. Sorted by *how many* by default for the same reason: the vars worth
 * fixing are the ones with thousands of tiny empties, not the one with a single
 * large-ish leftover.
 */
export function EmptyListsTable(props: { report: ListsReport }) {
  const { report } = props;
  const [search, setSearch] = useState('');
  // Defaults to the extension's own ranking, so an untouched table is in the
  // order it decided mattered rather than a second opinion on the same rows.
  const { sort, toggle } = useSort<SortKey>('empty_rank');

  const rows = useMemo(() => {
    const searchFn = createSearch(
      search,
      (row: ListGroupRow) => `${row.typepath} ${row.var}`,
    );
    const sorted = sortBy(report.empty_groups.filter(searchFn), [
      (row) => sortValue(row, sort.key),
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [report, search, sort]);

  const largest = useMemo(
    () => Math.max(1, ...rows.map((row) => exact(row.empty_bytes))),
    [rows],
  );

  // Empties nothing here can name: nested inside another list, sitting in a
  // global, or reached by no named root at all. Summed by the extension over
  // every pair, not over the rows below, so a capped page cannot inflate it.
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
              {count(report.empty_with_capacity)} still hold a vector remnant,
              room for {count(report.empty_capacity_slots)} elements they no
              longer have. That is {bytes(report.empty_capacity_bytes)} a
              freshly-made empty list would not have cost. Usually means they
              were emptied an element at a time; a single Cut() releases a large
              vector outright.
            </LabeledList.Item>
            <LabeledList.Item label="Held by no named var">
              {count(unnamed)} of them, so nothing below can name them. Nested
              inside another list, sitting in a global, or orphaned.
            </LabeledList.Item>
            <LabeledList.Item label="Not counted">
              Each list also occupies a 4-byte slot in the list table, which is
              in the Overview&apos;s storage block rather than the figure above.
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
        {/* Title is load-bearing - see the note in PerListTable. */}
        <Section
          fill
          scrollable
          title="Empty lists by type var"
          buttons={
            <SearchBar
              expensive
              query={search}
              onSearch={setSearch}
              placeholder="Filter by typepath or var name..."
              style={{ width: '24rem' }}
            />
          }
        >
          <Table>
            <Table.Row header>
              <SortCell
                active={sort.key === 'pair'}
                desc={sort.desc}
                onClick={() => toggle('pair')}
              >
                Type var
              </SortCell>
              <SortCell
                collapsing
                active={sort.key === 'empty_rank'}
                desc={sort.desc}
                onClick={() => toggle('empty_rank')}
              >
                Empty
              </SortCell>
              <SortCell
                collapsing
                active={sort.key === 'empty_direct'}
                desc={sort.desc}
                onClick={() => toggle('empty_direct')}
              >
                Direct
              </SortCell>
              <SortCell
                collapsing
                active={sort.key === 'empty_capacity'}
                desc={sort.desc}
                onClick={() => toggle('empty_capacity')}
              >
                Room for
              </SortCell>
              <SortCell
                active={sort.key === 'empty_bytes'}
                desc={sort.desc}
                onClick={() => toggle('empty_bytes')}
              >
                Bytes
              </SortCell>
            </Table.Row>
            {rows.map((row) => (
              <Table.Row key={varPair(row)} className="candystripe">
                <Table.Cell>
                  <Box inline style={{ fontFamily: 'monospace' }}>
                    {varPair(row)}
                  </Box>
                </Table.Cell>
                <Table.Cell collapsing className="text-right text-nowrap">
                  {/* The two counters behind this can disagree in either
                      direction, and both cases change how the row reads - a
                      nested one leads the table with a Direct of zero, a shared
                      one has Bytes lower than its count suggests. */}
                  <Tooltip content={rankNote(row)}>
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
                </Table.Cell>
                <Table.Cell collapsing className="text-right text-nowrap">
                  <Tooltip
                    content={`${count(row.direct_lists)} instances hold a list in this var, ${count(row.empty_direct)} of them empty`}
                  >
                    <Box inline>{count(row.empty_direct)}</Box>
                  </Tooltip>
                </Table.Cell>
                <Table.Cell collapsing className="text-right text-nowrap">
                  {/* Zero is the healthy case and the common one, so it reads
                      as a dash rather than a number worth scanning. */}
                  {exact(row.empty_capacity) > 0 ? (
                    <Box inline color="average">
                      {count(row.empty_capacity)}
                    </Box>
                  ) : (
                    <Box inline color="label">
                      -
                    </Box>
                  )}
                </Table.Cell>
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
