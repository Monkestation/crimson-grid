// THIS IS A CRIMSON UI FILE
import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import { Box, Section, Stack, Table, Tooltip } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { SearchBar } from '../common/SearchBar';
import { count, exact, var_pair } from './format';
import {
  BytesBar,
  Mono,
  NumCell,
  PathCell,
  SortCell,
  TruncatedNotice,
  UnattributedList,
  use_sort,
} from './parts';
import type { ListGroupRow, ListsReport } from './types';

type SortKey =
  | 'pair'
  | 'lists'
  | 'direct_lists'
  | 'elements'
  | 'assoc_nodes'
  | 'bytes';

const SORT_VALUES: Record<SortKey, (row: ListGroupRow) => number | string> = {
  pair: (row) => var_pair(row),
  lists: (row) => exact(row.lists),
  direct_lists: (row) => exact(row.direct_lists),
  elements: (row) => exact(row.elements),
  assoc_nodes: (row) => exact(row.assoc_nodes),
  bytes: (row) => exact(row.bytes),
};

/** one row per type var, added up over every instance. see `ListGroupRow`. */
export function ByVarTable(props: { report: ListsReport }) {
  const { report } = props;
  const [search, set_search] = useState('');
  const { sort, sort_props } = use_sort<SortKey>('bytes');

  const rows = useMemo(() => {
    const search_fn = createSearch(
      search,
      (row: ListGroupRow) => `${row.typepath} ${row.var}`,
    );
    const sorted = sortBy(report.list_groups.filter(search_fn), [
      SORT_VALUES[sort.key],
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [report, search, sort]);

  const largest = Math.max(1, ...rows.map((row) => exact(row.bytes)));

  return (
    <Stack fill vertical>
      <Stack.Item>
        <TruncatedNotice
          truncated={report.list_groups_truncated}
          shown={report.list_groups.length}
          total={report.groups_total}
          noun="type vars"
        />
      </Stack.Item>
      <Stack.Item grow>
        {/* keep the title - see PerListTable. */}
        <Section
          fill
          scrollable
          title="Lists by type var"
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
              <SortCell collapsing {...sort_props('lists')}>
                Lists
              </SortCell>
              <SortCell collapsing {...sort_props('direct_lists')}>
                Instances
              </SortCell>
              <SortCell collapsing {...sort_props('elements')}>
                Elems
              </SortCell>
              <SortCell collapsing {...sort_props('assoc_nodes')}>
                Assoc
              </SortCell>
              <SortCell {...sort_props('bytes')}>Bytes</SortCell>
            </Table.Row>
            {rows.map((row) => (
              <Table.Row key={var_pair(row)} className="candystripe">
                <PathCell>
                  <Mono>{var_pair(row)}</Mono>
                </PathCell>
                <NumCell>
                  {/* more lists than instances means some are nested inside the
                      var's own list, which is the thing worth spotting. */}
                  <Tooltip
                    content={
                      exact(row.lists) > exact(row.direct_lists)
                        ? `${count(row.direct_lists)} held directly, the rest nested inside those`
                        : 'None of these are nested inside each other'
                    }
                  >
                    <Box inline>{count(row.lists)}</Box>
                  </Tooltip>
                </NumCell>
                <NumCell>{count(row.direct_lists)}</NumCell>
                <NumCell>{count(row.elements)}</NumCell>
                <NumCell>{count(row.assoc_nodes)}</NumCell>
                <Table.Cell>
                  <BytesBar value={row.bytes} max={largest} />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
      <Stack.Item>
        {/* rows that add up to less than the total, with nothing saying where the rest
            went, read like a complete answer. */}
        <Section title="Not blamed on anything above">
          <UnattributedList unattributed={report.unattributed} />
        </Section>
      </Stack.Item>
    </Stack>
  );
}
