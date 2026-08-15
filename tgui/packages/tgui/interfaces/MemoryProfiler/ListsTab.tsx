// THIS IS A CRIMSON UI FILE
import { useState } from 'react';
import {
  Button,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';

import { useBackend } from '../../backend';
import { ByVarTable } from './ByVarTable';
import { EmptyListsTable } from './EmptyListsTable';
import { bytes, count, exact, meta_for } from './format';
import { PerListTable } from './PerListTable';
import { EmptyState, ReportHeader, SkipBreakdown } from './parts';
import type { Data, ListsReport } from './types';

enum VIEW {
  /** one row per list, named after whoever holds it. */
  PerList = 'per_list',
  /** one row per type var, added up over every instance of that type. */
  ByVar = 'by_var',
  /**
   * the same type vars, empty lists only, ordered by how many. neither view above can
   * show these - both go biggest-first and chop the tail, and an empty list is the
   * smallest row a world has.
   */
  Empty = 'empty',
}

function render_view(view: VIEW, report: ListsReport) {
  switch (view) {
    case VIEW.PerList:
      return <PerListTable report={report} />;
    case VIEW.ByVar:
      return <ByVarTable report={report} />;
    case VIEW.Empty:
      return <EmptyListsTable report={report} />;
    default:
      return exhaustiveCheck(view);
  }
}

export function ListsTab() {
  const { act, data } = useBackend<Data>();
  const { lists_report, busy, report_meta, panel_row_options } = data;
  // up here so switching views doesn't throw away the other one's sort and filter.
  const [view, set_view] = useState(VIEW.PerList);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <ReportHeader
            label="Scan the lists"
            busy={busy}
            onCapture={() =>
              act('capture_lists', { rows: panel_row_options[1] })
            }
            meta={meta_for(report_meta, 'lists')}
          >
            <Stack align="center">
              <Stack.Item color="label">Top</Stack.Item>
              {panel_row_options.map((option) => (
                <Stack.Item key={option}>
                  <Button
                    disabled={!!busy}
                    onClick={() => act('capture_lists', { rows: option })}
                  >
                    {count(option)}
                  </Button>
                </Stack.Item>
              ))}
            </Stack>
          </ReportHeader>
        </Section>
      </Stack.Item>
      {!lists_report ? (
        <Stack.Item>
          <EmptyState>
            Usually the one you want. Every list gets named after the datum var,
            global or containing list holding it, so a bloated one points
            straight at the code to go yell at.
          </EmptyState>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item label="Live lists">
                  {count(lists_report.lists_total)} holding{' '}
                  {bytes(lists_report.list_bytes)}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Orphans"
                  color={
                    exact(lists_report.orphan_lists) > 0 ? 'average' : undefined
                  }
                >
                  {count(lists_report.orphan_lists)} that nothing named reaches.
                  Either a real leak or something this walk does not look at.
                </LabeledList.Item>
                <SkipBreakdown header={lists_report} />
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            {/* the row buttons up top only cap the per-list table. the grouped views
                are one row per type var either way, so they don't get paged. */}
            <Tabs fluid>
              <Tabs.Tab
                icon="list"
                selected={view === VIEW.PerList}
                onClick={() => set_view(VIEW.PerList)}
              >
                Per list
              </Tabs.Tab>
              <Tabs.Tab
                icon="layer-group"
                selected={view === VIEW.ByVar}
                onClick={() => set_view(VIEW.ByVar)}
              >
                By type var ({count(lists_report.groups_total)})
              </Tabs.Tab>
              <Tabs.Tab
                icon="ghost"
                selected={view === VIEW.Empty}
                onClick={() => set_view(VIEW.Empty)}
              >
                Empty ({count(lists_report.skipped.empty)})
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{render_view(view, lists_report)}</Stack.Item>
        </>
      )}
    </Stack>
  );
}
