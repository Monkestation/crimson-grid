// THIS IS A CRIMSON UI FILE
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
import { bytes, count, exact, meta_for } from './format';
import { Honesty } from './Honesty';
import {
  BytesBar,
  EmptyState,
  PathCell,
  ReportHeader,
  SkipBreakdown,
} from './parts';
import type { Census, Data, Retained } from './types';

/**
 * who's holding all the list bytes, when we managed to work that out. a scan that
 * couldn't gets the notice instead: this whole section is who-holds-what, and a column
 * of `0 B` would claim nothing is holding anything, which is a hell of a thing to say
 * when you named exactly zero owners.
 */
function RetainedSection(props: { census: Census }) {
  const { census } = props;

  // has to be `!== undefined` - it's a string, and an empty one is falsy, which would
  // quietly drop us into the wrong half of the union. don't "simplify" this.
  if (census.owners_unavailable !== undefined) {
    return (
      <Section title="Who is holding the list bytes">
        <NoticeBox>
          Nope: {census.owners_unavailable}. Everything above still stands,
          since none of those counters need to know who holds what. What is
          missing is which list belongs to whom, so the Lists tab is empty too.
        </NoticeBox>
      </Section>
    );
  }

  return <RetainedTable retained={census.retained} />;
}

function RetainedTable(props: { retained: Retained }) {
  const { retained } = props;

  const largest = Math.max(
    1,
    ...retained.by_type.map((row) => exact(row.bytes)),
  );

  return (
    <Section title="Who is holding the list bytes">
      <LabeledList>
        <LabeledList.Item label="Shared">
          {bytes(retained.shared_bytes)} held in more than one place, so there
          is no one var to blame
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
          {bytes(retained.deep_bytes)} buried deeper than the walk goes
        </LabeledList.Item>
        <LabeledList.Item label="Nobody">
          {bytes(retained.unattributed_bytes)}, the five above added together.
          This is where counting refs gives up. Doing it properly needs a real
          graph walk and we do not do one.
        </LabeledList.Item>
      </LabeledList>
      <Table mt={1}>
        <Table.Row header>
          <Table.Cell>Blamed on typepath</Table.Cell>
          <Table.Cell>Bytes</Table.Cell>
        </Table.Row>
        {retained.by_type.map((row) => (
          <Table.Row key={row.typepath} className="candystripe">
            <PathCell>{row.typepath}</PathCell>
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
            label="Scan everything"
            busy={busy}
            onCapture={() => act('capture_census')}
            meta={meta_for(report_meta, 'census')}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            {!census ? (
              <Stack.Item>
                <EmptyState>
                  Nothing scanned yet. This walks the entire heap, which takes
                  seconds, and the server is frozen for every one of them. Run
                  it on purpose, not on a timer.
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
                      {/* an orphan count is a claim about owners, and a scan that
                          named no owners has no claim to make. a `0` here would
                          read as "all accounted for". */}
                      {census.owners_unavailable !== undefined ? (
                        <LabeledList.Item label="Orphans" color="average">
                          no idea - {census.owners_unavailable}
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
                          {count(census.orphan_lists)} lists that nothing named
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
                  Base sizes, each one traced back to where byondcore actually
                  allocates it. An instance gets charged this plus its var
                  block, a list this plus its assoc tree. So it is the floor,
                  not the whole thing.
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
