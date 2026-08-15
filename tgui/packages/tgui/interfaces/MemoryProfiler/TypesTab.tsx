// THIS IS A CRIMSON UI FILE
import { sortBy } from 'es-toolkit';
import { useMemo, useState } from 'react';
import {
  Box,
  Icon,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { SearchBar } from '../common/SearchBar';
import { count, exact, meta_for } from './format';
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
import type { Data, TypeRow } from './types';

type SortKey = 'typepath' | 'count' | 'self_bytes';

const SORT_VALUES: Record<SortKey, (row: TypeRow) => number | string> = {
  typepath: (row) => row.typepath,
  count: (row) => exact(row.count),
  self_bytes: (row) => exact(row.self_bytes),
};

export function TypesTab() {
  const { act, data } = useBackend<Data>();
  const { census, busy, report_meta } = data;
  const [search, set_search] = useState('');
  const { sort, sort_props } = use_sort<SortKey>('self_bytes');

  const rows = useMemo(() => {
    if (!census) {
      return [];
    }
    const search_fn = createSearch(search, (row: TypeRow) => row.typepath);
    const sorted = sortBy(census.types.filter(search_fn), [
      SORT_VALUES[sort.key],
    ]);
    return sort.desc ? sorted.reverse() : sorted;
  }, [census, search, sort]);

  const largest = Math.max(1, ...rows.map((row) => exact(row.self_bytes)));

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <ReportHeader
            label="Scan everything"
            busy={busy}
            onCapture={() => act('capture_census')}
            meta={meta_for(report_meta, 'census')}
          />
        </Section>
      </Stack.Item>
      {!census ? (
        <Stack.Item>
          <EmptyState>
            Nothing scanned yet. It walks the entire heap and the server sits
            frozen the whole time.
          </EmptyState>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <TruncatedNotice
              truncated={census.types_truncated}
              shown={census.types.length}
              total={census.types_total}
              noun="typepaths"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Typepaths"
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
                  <SortCell collapsing {...sort_props('count')}>
                    Instances
                  </SortCell>
                  <SortCell {...sort_props('self_bytes')}>Self bytes</SortCell>
                </Table.Row>
                {rows.map((row) => (
                  <Table.Row key={row.typepath} className="candystripe">
                    <PathCell>
                      <Box inline color={row.costed ? undefined : 'average'}>
                        {row.typepath}
                      </Box>
                      {!row.costed && (
                        <Tooltip content="Nobody has measured how big this kind is, so its bytes are not charged here. That is not the same as it being free.">
                          <Icon
                            name="triangle-exclamation"
                            ml={1}
                            color="average"
                          />
                        </Tooltip>
                      )}
                    </PathCell>
                    <NumCell>{count(row.count)}</NumCell>
                    <Table.Cell>
                      <BytesBar value={row.self_bytes} max={largest} />
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
