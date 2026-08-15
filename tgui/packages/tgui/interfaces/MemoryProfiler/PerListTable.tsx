// THIS IS A CRIMSON UI FILE
import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import { Box, Icon, Section, Table, Tooltip } from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';
import { createSearch } from 'tgui-core/string';

import { SearchBar } from '../common/SearchBar';
import { count, exact } from './format';
import {
  BytesBar,
  Mono,
  NumCell,
  PathCell,
  SortCell,
  TruncatedNotice,
  use_sort,
} from './parts';
import {
  LIST_STATUS_NOTE,
  type ListRow,
  type ListsReport,
  type ListWalkStatus,
  type OwnerSite,
} from './types';

type SortKey =
  | 'owner'
  | 'length'
  | 'allocated'
  | 'ref_count'
  | 'assoc_nodes'
  | 'bytes';

const SORT_VALUES: Record<SortKey, (row: ListRow) => number | string> = {
  owner: (row) => row.owner,
  length: (row) => exact(row.length),
  allocated: (row) => exact(row.allocated),
  ref_count: (row) => row.ref_count,
  assoc_nodes: (row) => row.assoc_nodes,
  bytes: (row) => exact(row.bytes),
};

const SITE_COLORS: Record<OwnerSite, string> = {
  var: 'good',
  global: 'teal',
  list_index: 'purple',
  list_assoc: 'violet',
  client_slot: 'blue',
  alist_value: 'olive',
  proc_slot: 'orange',
  vis_vector: 'pink',
  orphan: 'bad',
};

/** only for the ones where the key alone doesn't say enough. */
const SITE_NOTES: Partial<Record<OwnerSite, string>> = {
  proc_slot:
    'An argument or local of a paused proc. Last resort - paused procs get checked after everything else, so this only turns up when no datum var, global or list holds the list either.',
  vis_vector:
    'The vis_contents or vis_locs of an atom or image. BYOND does not make those lists, they are some flat array doohickey, so nothing else on this panel would ever find it.',
};

function SiteTag(props: { site: OwnerSite }) {
  const { site } = props;
  const note = SITE_NOTES[site];
  const tag = (
    <Box inline color={SITE_COLORS[site]}>
      {site}
    </Box>
  );

  return note ? <Tooltip content={note}>{tag}</Tooltip> : tag;
}

/**
 * a warning icon, but only where something is actually wrong. `empty` gets nothing on
 * purpose - most of a real world is empty lists, and an icon on nine rows out of ten
 * is just noise.
 */
function StatusIcon(props: { status: ListWalkStatus }) {
  const { status } = props;

  switch (status) {
    case 'walked':
    case 'empty':
      return null;
    case 'no_vector':
    case 'over_capacity':
    case 'length_absurd':
      return (
        <Tooltip content={LIST_STATUS_NOTE[status]}>
          <Icon name="triangle-exclamation" ml={1} color="bad" />
        </Tooltip>
      );
    default:
      return exhaustiveCheck(status);
  }
}

/** one row per list, named after whoever holds it. */
export function PerListTable(props: { report: ListsReport }) {
  const { report } = props;
  const [search, set_search] = useState('');
  const { sort, sort_props } = use_sort<SortKey>('bytes');

  const rows = useMemo(() => {
    // `walk_status` is in the haystack, so typing `empty` narrows it down to the ones
    // holding nothing. only the big ones land here (this table is capped and sorted by
    // size - the Empty view counts them properly), but being able to pick them out of
    // the page you're already on is worth one word in the search.
    const search_fn = createSearch(
      search,
      (row: ListRow) => `${row.owner} ${row.owner_site} ${row.walk_status}`,
    );
    const sorted = sortBy(report.lists.filter(search_fn), [
      SORT_VALUES[sort.key],
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [report, search, sort]);

  const largest = Math.max(1, ...rows.map((row) => exact(row.bytes)));

  return (
    <>
      <TruncatedNotice
        truncated={report.lists_truncated}
        shown={report.lists.length}
        total={report.lists_total}
        noun="lists"
      />
      {/* keep the title. Section only gives its header a real height when it has one,
          and `buttons` gets positioned absolutely inside that header, so dropping the
          title dumps the search bar right on top of the first row. */}
      <Section
        fill
        scrollable
        title="Lists"
        buttons={
          <SearchBar
            expensive
            query={search}
            onSearch={set_search}
            placeholder="Filter owners, or type a site or status like orphan, empty..."
            style={{ width: '24rem' }}
          />
        }
      >
        <Table>
          <Table.Row header>
            <SortCell {...sort_props('owner')}>Owner</SortCell>
            <Table.Cell collapsing>Site</Table.Cell>
            <SortCell collapsing {...sort_props('length')}>
              Len
            </SortCell>
            <SortCell collapsing {...sort_props('allocated')}>
              Alloc
            </SortCell>
            <SortCell collapsing {...sort_props('ref_count')}>
              Refs
            </SortCell>
            <SortCell collapsing {...sort_props('assoc_nodes')}>
              Assoc
            </SortCell>
            <SortCell {...sort_props('bytes')}>Bytes</SortCell>
          </Table.Row>
          {rows.map((row) => (
            <Table.Row key={row.list_id} className="candystripe">
              <PathCell>
                {/* never parse this. past 2^24 BYOND rounds it off and hands you
                    a completely different fucking list. */}
                <Tooltip content={`list#${row.list_id}`}>
                  <Mono>{row.owner}</Mono>
                </Tooltip>
                {!row.capacity_sane && (
                  <Tooltip content="This one's capacity failed the sanity check, so its Alloc is not worth trusting.">
                    <Icon name="ruler" ml={1} color="average" />
                  </Tooltip>
                )}
                <StatusIcon status={row.walk_status} />
              </PathCell>
              <Table.Cell collapsing>
                <SiteTag site={row.owner_site} />
              </Table.Cell>
              <NumCell>{count(row.length)}</NumCell>
              <NumCell>{count(row.allocated)}</NumCell>
              <NumCell>{row.ref_count}</NumCell>
              <NumCell>{row.assoc_nodes}</NumCell>
              <Table.Cell>
                <BytesBar value={row.bytes} max={largest} />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </>
  );
}
