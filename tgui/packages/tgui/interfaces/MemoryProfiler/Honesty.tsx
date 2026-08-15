// THIS IS A CRIMSON UI FILE
import {
  Box,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Table,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { bytes, count, exact } from './format';
import { NumCell } from './parts';
import type { Footer, StorageRow } from './types';

function Flag(props: { set: BooleanLike; children: string }) {
  const { set, children } = props;

  return (
    <Box inline mr={2} color={set ? 'good' : 'average'}>
      <Icon name={set ? 'check' : 'xmark'} mr={0.5} />
      {children}
    </Box>
  );
}

type StorageMeta = {
  label: string;
  /** what the extension prints instead of a number: "not walked" if it never looked,
   * "not resolved" if the globals it needed never turned up. */
  missing: string;
  /** nothing live to count here, just bytes. */
  countless?: boolean;
  note?: string;
};

/**
 * readable names, keyed off the extension's own. anything we don't recognize falls
 * through to the raw key, because a section whose whole job is owning up to what it
 * missed can't go disappearing rows.
 */
const STORAGE_META: Record<string, StorageMeta> = {
  table_pointer_arrays: {
    label: 'Table pointer arrays',
    missing: 'not walked',
    countless: true,
    note: 'Four bytes per slot of every table this walk gets at, live or not. Counted once here instead of being smeared over the rows below.',
  },
  alist_records: { label: 'Alist records', missing: 'not walked' },
  alist_trees: { label: 'Alist trees', missing: 'not walked' },
  turf_var_nodes: { label: 'Turf var nodes', missing: 'not walked' },
  string_table: {
    label: 'String table',
    missing: 'not resolved',
    note: "Live entries only. A dead slot is a null pointer with nothing behind it, so it costs nothing here. BYOND's own report charges 32 B for one anyway, because it makes up a fake entry instead of just reading the table.",
  },
  suspended_proc_frames: {
    label: 'Paused procs',
    missing: 'not walked',
    note: 'Just the frame itself. Its parent chain, the proc queue and the destructor table all go unwalked, and so does anything actually running right now.',
  },
};

/**
 * what actually got charged this run. a zero here means two completely different
 * things, which is why the right-hand column exists.
 */
function StorageTable(props: { rows?: StorageRow[] }) {
  const { rows } = props;

  if (!rows?.length) {
    return (
      <Box color="label">
        This scan came back without a storage breakdown, so whatever got charged
        beyond instances and lists is anyone&apos;s guess.
      </Box>
    );
  }

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Thing</Table.Cell>
        <Table.Cell collapsing>Live</Table.Cell>
        <Table.Cell collapsing>Bytes</Table.Cell>
      </Table.Row>
      {rows.map((row) => {
        const meta = STORAGE_META[row.label];

        return (
          <Table.Row key={row.label} className="candystripe">
            <Table.Cell>
              {meta ? meta.label : row.label}
              {!!meta?.note && (
                <Tooltip content={meta.note}>
                  <Icon name="circle-info" ml={1} color="label" />
                </Tooltip>
              )}
            </Table.Cell>
            <NumCell>
              {row.walked && !meta?.countless ? count(row.count) : ''}
            </NumCell>
            <NumCell>
              {row.walked ? (
                bytes(row.bytes)
              ) : (
                <Box inline color="average">
                  {meta ? meta.missing : 'not walked'}
                </Box>
              )}
            </NumCell>
          </Table.Row>
        );
      })}
    </Table>
  );
}

/** what the numbers above leave out. every total in every report is partial. */
export function Honesty(props: { footer: Footer }) {
  const { footer } = props;

  return (
    <Section title="What these numbers leave out">
      {!footer.bytes_available && (
        <NoticeBox danger>
          No byte reporting on this platform, so every byte count in every
          report reads zero. Instance and element counts are still real.
        </NoticeBox>
      )}
      <LabeledList>
        <LabeledList.Item label="Not counted">
          {footer.exclusions}
        </LabeledList.Item>
        <LabeledList.Item label="Where orphans hide">
          {footer.orphan_sources}
        </LabeledList.Item>
        <LabeledList.Item
          label="Unmeasured"
          color={exact(footer.uncosted_instances) > 0 ? 'average' : undefined}
        >
          {count(footer.uncosted_instances)} instances counted, but nobody has
          measured how big their kind is, so they got charged nothing. Every
          kind this walk reaches has been measured, so anything but zero is
          something new that slipped in.
        </LabeledList.Item>
        <LabeledList.Item label="This run">
          <Flag set={footer.bytes_available}>bytes</Flag>
          <Flag set={footer.image_base_verified}>image base</Flag>
          <Flag set={footer.turfs_walked}>turfs walked</Flag>
          <Flag set={footer.alists_walked}>alists walked</Flag>
        </LabeledList.Item>
      </LabeledList>
      <Section title="What else got charged this run">
        <StorageTable rows={footer.storage} />
      </Section>
    </Section>
  );
}
