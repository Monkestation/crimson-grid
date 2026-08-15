// THIS IS A CRIMSON UI FILE
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { bytes, count, meta_for } from './format';
import { EmptyState, NumCell, ReportHeader } from './parts';
import type { Data } from './types';

// `pre-wrap` is what keeps BYOND's raw output on more than one line, which is why this
// isn't the `Mono` from parts.tsx.
const MONOSPACE = { fontFamily: 'monospace', whiteSpace: 'pre-wrap' } as const;

function names_or_none(labels: string[] | undefined) {
  return labels?.length ? labels.join(', ') : 'none';
}

export function CompatTab() {
  const { act, data } = useBackend<Data>();
  const { compat_report, coverage, debug_text, busy, report_meta } = data;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Check our numbers against BYOND's">
          <ReportHeader
            label="Compare them"
            busy={busy}
            onCapture={() => act('capture_compat')}
            meta={meta_for(report_meta, 'compat')}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            <Stack.Item>
              <NoticeBox info>
                These rows have to match BYOND's own GetServerMemUsage. A table
                this tool never found looks exactly like a clean scan otherwise,
                which is the whole reason to bother comparing. Five rows always,
                plus a sixth for alists if the world has any - BYOND drops that
                row at zero and so do we, so both sides missing it means we
                agree, not that something is broken.
              </NoticeBox>
            </Stack.Item>
            {!compat_report ? (
              <Stack.Item>
                <EmptyState>Nothing compared yet.</EmptyState>
              </Stack.Item>
            ) : (
              <>
                <Stack.Item>
                  <Section title="byond_memprofile">
                    <Table>
                      <Table.Row header>
                        <Table.Cell>Kind</Table.Cell>
                        <Table.Cell collapsing>Count</Table.Cell>
                        <Table.Cell collapsing>Bytes</Table.Cell>
                      </Table.Row>
                      {compat_report.memprofile.map((row) => (
                        <Table.Row key={row.label} className="candystripe">
                          <Table.Cell>{row.label}</Table.Cell>
                          <NumCell>{count(row.count)}</NumCell>
                          <NumCell>{bytes(row.bytes)}</NumCell>
                        </Table.Row>
                      ))}
                    </Table>
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  <Section title="BYOND GetServerMemUsage">
                    {compat_report.byond_available &&
                    compat_report.byond_raw ? (
                      <Box style={MONOSPACE}>{compat_report.byond_raw}</Box>
                    ) : (
                      <NoticeBox color="yellow">
                        BYOND's own report symbols didn't turn up, which is
                        always the case off Windows. Nothing to compare against,
                        so a missing table would go completely unnoticed.
                      </NoticeBox>
                    )}
                  </Section>
                </Stack.Item>
              </>
            )}
            <Stack.Item>
              <Section title="What we could get at">
                {!coverage ? (
                  <EmptyState>
                    This gets read once at startup. If it is empty, the
                    extension never started up.
                  </EmptyState>
                ) : (
                  <>
                    {!coverage.complete && (
                      <NoticeBox danger>
                        This build could not get at every table, so every total
                        in every report is short by whatever was living in the
                        ones it missed.
                      </NoticeBox>
                    )}
                    <LabeledList>
                      <LabeledList.Item label="Build">
                        {coverage.build}
                      </LabeledList.Item>
                      <LabeledList.Item label="Scanned" color="good">
                        {names_or_none(coverage.scanned)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Double-checked" color="teal">
                        {names_or_none(coverage.forward_validated)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Guessed at" color="average">
                        {names_or_none(coverage.fallback)}
                      </LabeledList.Item>
                      <LabeledList.Item label="Could not reach" color="bad">
                        {names_or_none(coverage.unavailable)}
                      </LabeledList.Item>
                    </LabeledList>
                  </>
                )}
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section
                title="Extension debug log"
                buttons={
                  <Button
                    icon="download"
                    disabled={!!busy}
                    onClick={() => act('drain_debug')}
                  >
                    Grab it
                  </Button>
                }
              >
                {debug_text ? (
                  <Box style={MONOSPACE}>{debug_text}</Box>
                ) : (
                  <Box color="label">
                    Empty. Grabbing it wipes it on the extension side, so nobody
                    else gets to read it after you.
                  </Box>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
}
