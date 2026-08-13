// THIS IS A CRIMSON UI FILE
import { useMemo } from 'react';
import {
  Box,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Dumps } from './Dumps';
import { bytes, count, exact, metaFor } from './format';
import { Honesty } from './Honesty';
import { BytesBar, EmptyState, ReportHeader, SkipBreakdown } from './parts';
import type { Census, Data, Retained } from './types';

/**
 * Retained bytes, when there are any.
 *
 * A world whose ownership graph did not fit gets the notice instead. Not an
 * empty table and not a column of `0 B`: this section is entirely attribution,
 * and zeroes here would say "nothing is retained by anything", which is a claim
 * about the whole heap made by a census that resolved no owners at all.
 */
function RetainedSection(props: { census: Census }) {
  const { census } = props;

  // `!== undefined`, not truthiness: `owners_unavailable` is a `string`, and an
  // empty one is falsy while still belonging to the degraded shape. Only the
  // presence check narrows the union.
  if (census.owners_unavailable !== undefined) {
    return (
      <Section title="Retained list bytes, attributed">
        <NoticeBox>
          Not reported: {census.owners_unavailable}. Everything above is
          unaffected - the instance counts, the var rows and the storage block
          all come off counters that need no ownership graph. What is missing is
          which list belongs to whom, so the Lists tab has nothing to show
          either.
        </NoticeBox>
      </Section>
    );
  }

  return <RetainedTable retained={census.retained} />;
}

/** The section proper, once there is something to attribute. */
function RetainedTable(props: { retained: Retained }) {
  const { retained } = props;

  const largest = useMemo(
    () => Math.max(1, ...retained.by_type.map((row) => exact(row.bytes))),
    [retained],
  );

  return (
    <Section title="Retained list bytes, attributed">
      <LabeledList>
        <LabeledList.Item label="Shared">
          {bytes(retained.shared_bytes)} held more than once, so ownership is
          genuinely ambiguous
        </LabeledList.Item>
        <LabeledList.Item label="Globals">
          {bytes(retained.global_bytes)}
        </LabeledList.Item>
        <LabeledList.Item label="Alists">
          {bytes(retained.alist_bytes)}
        </LabeledList.Item>
        <LabeledList.Item label="Orphans">
          {bytes(retained.orphan_bytes)}
        </LabeledList.Item>
        <LabeledList.Item label="Too deep">
          {bytes(retained.deep_bytes)} on chains that ran past the hop cap
        </LabeledList.Item>
        <LabeledList.Item label="Unattributed">
          {bytes(retained.unattributed_bytes)}, the five above summed. This is
          what the refcount approximation gives up on; it is not a dominator
          tree.
        </LabeledList.Item>
      </LabeledList>
      <Table mt={1}>
        <Table.Row header>
          <Table.Cell>Attributed to typepath</Table.Cell>
          <Table.Cell>Bytes</Table.Cell>
        </Table.Row>
        {retained.by_type.map((row) => (
          <Table.Row key={row.typepath} className="candystripe">
            <Table.Cell>{row.typepath}</Table.Cell>
            <Table.Cell>
              <BytesBar value={row.bytes} max={largest} color="olive" />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
}

export function Overview() {
  const { act, data } = useBackend<Data>();
  const { census, busy, report_meta, base_sizes } = data;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <ReportHeader
            label="Capture census"
            busy={busy}
            onCapture={() => act('capture_census')}
            meta={metaFor(report_meta, 'census')}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            {!census ? (
              <Stack.Item>
                <EmptyState>
                  Nothing captured yet. A census walks the entire heap, which
                  takes seconds and freezes the server for all of them. It is a
                  diagnostic you run deliberately, not something to leave on a
                  timer.
                </EmptyState>
              </Stack.Item>
            ) : (
              <>
                <Stack.Item>
                  <Section title="Totals">
                    <LabeledList>
                      <LabeledList.Item label="Instances">
                        {count(census.total_instances)} across{' '}
                        {count(census.types_total)} typepaths, holding{' '}
                        {bytes(census.total_self_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Lists">
                        {count(census.lists_total)} holding{' '}
                        {bytes(census.list_bytes)}
                      </LabeledList.Item>
                      {/* An orphan count is an owner claim, so a census that
                          resolved no owners has none to make. Saying so beats a
                          `0` that reads as "every list is accounted for". */}
                      {census.owners_unavailable !== undefined ? (
                        <LabeledList.Item label="Orphans" color="average">
                          not known - {census.owners_unavailable}
                        </LabeledList.Item>
                      ) : (
                        <LabeledList.Item
                          label="Orphans"
                          color={
                            exact(census.orphan_lists) > 0
                              ? 'average'
                              : undefined
                          }
                        >
                          {count(census.orphan_lists)} lists no named root
                          reaches
                        </LabeledList.Item>
                      )}
                      <SkipBreakdown header={census} />
                      <LabeledList.Item label="Var rows">
                        {count(census.var_rows_total)} rows across{' '}
                        {count(census.vars_total)} names, costing{' '}
                        {bytes(census.var_bytes)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Build">
                        {census.build}
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <RetainedSection census={census} />
                </Stack.Item>
                <Stack.Item>
                  <Honesty footer={census.footer} />
                </Stack.Item>
              </>
            )}
            <Stack.Item>
              <Dumps />
            </Stack.Item>
            <Stack.Item>
              <Section title="What a row costs">
                <Box color="label" mb={1}>
                  Base sizes, each traced to an allocation site in byondcore. An
                  instance is charged this plus its var block, and a list this
                  plus its assoc tree, so these are the floor of a row rather
                  than the whole of it.
                </Box>
                <LabeledList>
                  {base_sizes.map((entry) => (
                    <LabeledList.Item key={entry.label} label={entry.label}>
                      {entry.bytes} B
                      {!!entry.note && (
                        <Box inline color="average" ml={1}>
                          - {entry.note}
                        </Box>
                      )}
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
}
