// THIS IS A CRIMSON UI FILE
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { bytes, count } from './format';
import { Mono, NumCell, PathCell } from './parts';
import type { Data } from './types';

export function Dumps() {
  const { act, data } = useBackend<Data>();
  const { dumps, busy, dump_row_options, census, lists_report } = data;

  const known_lists = lists_report?.lists_total ?? census?.lists_total;

  return (
    <Section title="File dumps">
      <Stack vertical>
        <Stack.Item>
          <NoticeBox info>
            Reports only carry the top 40 rows per section, so if you want the
            whole thing it has to go to a file. Server&apos;s frozen for the
            walk AND the write, and a full scan on a live world is hundreds of
            MB. Yes, really.
          </NoticeBox>
        </Stack.Item>
        <Stack.Item>
          {/* two buttons that look the same and aren't. open an "all" dump expecting
              biggest-first and the first screenful reads like the answer. */}
          <NoticeBox info>
            An <b>all</b> dump comes out in list-number order, not biggest
            first. Ranking it would mean holding a row per list in memory, which
            is the exact thing a file dump exists to dodge. Sort it on the bytes
            column afterwards. Numbered dumps are still biggest first.
          </NoticeBox>
        </Stack.Item>
        <Stack.Item>
          <Stack align="center" wrap>
            <Stack.Item>
              <Button.Confirm
                icon="file-arrow-down"
                disabled={!!busy}
                onClick={() => act('dump', { kind: 'census' })}
              >
                Dump the whole scan
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item color="label">Dump lists:</Stack.Item>
            {dump_row_options.map((option) =>
              option === 'all' ? (
                <Stack.Item key={option}>
                  <Button.Confirm
                    icon="triangle-exclamation"
                    color="bad"
                    disabled={!!busy}
                    confirmContent={
                      known_lists
                        ? `All ${count(known_lists)} lists?`
                        : 'Every list?'
                    }
                    onClick={() => act('dump', { kind: 'lists', rows: option })}
                  >
                    all
                  </Button.Confirm>
                </Stack.Item>
              ) : (
                <Stack.Item key={option}>
                  <Button
                    disabled={!!busy}
                    onClick={() => act('dump', { kind: 'lists', rows: option })}
                  >
                    {count(option)}
                  </Button>
                </Stack.Item>
              ),
            )}
          </Stack>
        </Stack.Item>
        <Stack.Item>
          {dumps.length === 0 ? (
            <Box color="label">Nothing dumped this round.</Box>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell collapsing>When</Table.Cell>
                <Table.Cell>File</Table.Cell>
                <Table.Cell collapsing>Rows</Table.Cell>
                <Table.Cell collapsing>Size</Table.Cell>
                <Table.Cell collapsing />
              </Table.Row>
              {dumps.map((entry, index) => (
                <Table.Row key={entry.path} className="candystripe">
                  <Table.Cell collapsing className="text-nowrap">
                    {entry.at}
                  </Table.Cell>
                  <PathCell>
                    <Mono>{entry.name}</Mono>
                  </PathCell>
                  <NumCell color={entry.truncated ? 'average' : undefined}>
                    {count(entry.rows)} of {count(entry.total)}
                  </NumCell>
                  {/* BYOND measured this, so past 16 MB it's a guess. a "do you
                      really want this" hint, not a real number. */}
                  <NumCell>~{bytes(entry.size)}</NumCell>
                  <Table.Cell collapsing>
                    <Button
                      icon="download"
                      onClick={() => act('download', { index: index + 1 })}
                    >
                      Download
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
}
