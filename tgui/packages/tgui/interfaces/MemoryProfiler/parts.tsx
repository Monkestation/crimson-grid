// THIS IS A CRIMSON UI FILE
import { type ReactNode, useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { bytes, count, duration, exact } from './format';
import {
  type Exact,
  LIST_FAILURES,
  LIST_STATUS_NOTE,
  type ListCounts,
  type ListFailure,
  type ReportMeta,
  type Unattributed,
} from './types';

/** which column a table is sorted on, and clicking the same one flips the direction. */
export function use_sort<K extends string>(
  initial_key: K,
  initial_desc = true,
) {
  const [sort, set_sort] = useState<{ key: K; desc: boolean }>({
    key: initial_key,
    desc: initial_desc,
  });

  function toggle(key: K) {
    set_sort((prev) =>
      prev.key === key ? { key, desc: !prev.desc } : { key, desc: true },
    );
  }

  /** spread this onto a `SortCell` so you only spell the key once per header. */
  function sort_props(key: K) {
    return {
      active: sort.key === key,
      desc: sort.desc,
      onClick: () => toggle(key),
    };
  }

  return { sort, sort_props };
}

type SortCellProps = {
  children: ReactNode;
  active: boolean;
  desc: boolean;
  onClick: () => void;
  collapsing?: boolean;
};

export function SortCell(props: SortCellProps) {
  const { children, active, desc, onClick, collapsing } = props;

  return (
    <Table.Cell collapsing={collapsing}>
      <Button
        compact
        fluid
        color="transparent"
        icon={active ? (desc ? 'caret-down' : 'caret-up') : undefined}
        onClick={onClick}
      >
        {children}
      </Button>
    </Table.Cell>
  );
}

/**
 * a cell holding one long identifier - a typepath, an owner chain, a filename.
 *
 * the word-break is load-bearing, do not drop it. none of these have spaces to break
 * at, so the column asks the table for the whole string on one line, the table ends up
 * wider than the panel, and `Section scrollable` is `overflow-x: hidden`. every column
 * to the right of this one then just vanishes, with no scrollbar to go find them.
 * matches what LabeledList does with the same problem.
 */
export function PathCell(props: { children: ReactNode }) {
  return (
    <Table.Cell style={{ wordBreak: 'break-all' }}>{props.children}</Table.Cell>
  );
}

/** right-aligned and doesn't wrap, which is every number cell on this panel. */
export function NumCell(props: { children: ReactNode; color?: string }) {
  const { children, color } = props;

  return (
    <Table.Cell collapsing className="text-right text-nowrap" color={color}>
      {children}
    </Table.Cell>
  );
}

/**
 * monospace, for cells holding a typepath or a filename. not the same as the one in
 * `CompatTab` - that one also sets `pre-wrap` to keep raw dumped output on more than
 * one line, which is exactly wrong inside a table cell.
 */
export function Mono(props: { children: ReactNode }) {
  return (
    <Box inline style={{ fontFamily: 'monospace' }}>
      {props.children}
    </Box>
  );
}

type ReportHeaderProps = {
  label: string;
  busy: BooleanLike;
  onCapture: () => void;
  meta?: ReportMeta;
  children?: ReactNode;
};

/** the go button, plus who ran it last and how long the server sat frozen for it. */
export function ReportHeader(props: ReportHeaderProps) {
  const { label, busy, onCapture, meta, children } = props;

  return (
    <Stack align="center">
      <Stack.Item>
        <Button icon="camera" disabled={!!busy} onClick={onCapture}>
          {label}
        </Button>
      </Stack.Item>
      {!!children && <Stack.Item>{children}</Stack.Item>}
      <Stack.Item grow>
        <Box color="label" textAlign="right">
          {meta
            ? `${meta.captured_by} ran this at ${meta.captured_at} and froze the server for ${duration(meta.duration_ds)}`
            : 'nobody has run this yet'}
        </Box>
      </Stack.Item>
    </Stack>
  );
}

export function EmptyState(props: { children: ReactNode }) {
  return <NoticeBox info>{props.children}</NoticeBox>;
}

type TruncatedProps = {
  truncated: BooleanLike;
  shown: number;
  total: Exact;
  noun: string;
};

/** a cut-off table looks exactly like a whole one. that's how you misread a profiler. */
export function TruncatedNotice(props: TruncatedProps) {
  const { truncated, shown, total, noun } = props;

  if (!truncated) {
    return null;
  }

  return (
    <NoticeBox color="yellow">
      Only showing {count(shown)} of {count(total)} {noun}. Want the rest? Dump
      it to a file from the Overview tab.
    </NoticeBox>
  );
}

/** short label per failure, for the left column. */
const FAILURE_LABEL: Record<ListFailure, string> = {
  no_vector: 'No storage',
  over_capacity: 'Over capacity',
  length_absurd: 'Bad length',
};

/**
 * how many lists got skipped, one line per reason.
 *
 * empties get their own boring line instead of being lumped in with the failures. most
 * lists on a station are empty, and counting those as broken makes a perfectly fine
 * server look like it's full of a shitload of corrupt slots. the three real failures
 * only show up when they're non-zero, so a healthy world gets one calm line instead of
 * three angry red zeroes.
 *
 * takes `ListCounts` so it still draws for a scan that couldn't work out any owners.
 * widening it to `ListsHeader` would drag the who-holds-what half in and break it on
 * exactly the worlds where you need it most.
 */
export function SkipBreakdown(props: { header: ListCounts }) {
  const { header } = props;
  const { skipped } = header;

  return (
    <>
      {/* "holds nothing" reads as "costs nothing", so the bytes go on the same line.
          the ones cleared without letting go of their vector are the fixable ones. */}
      <LabeledList.Item label="Empty">
        {count(skipped.empty)} lists hold nothing and cost{' '}
        {bytes(header.empty_bytes)}
        {exact(header.empty_with_capacity) > 0 && (
          <>
            {' - '}
            {count(header.empty_with_capacity)} of them are still sitting on
            room for {count(header.empty_capacity_slots)} elements
          </>
        )}
        . Having empties is normal. The ones hoarding room, less so.
      </LabeledList.Item>
      {LIST_FAILURES.filter((status) => exact(skipped[status]) > 0).map(
        (status) => (
          <LabeledList.Item
            key={status}
            label={FAILURE_LABEL[status]}
            color="bad"
          >
            {count(skipped[status])} lists. {LIST_STATUS_NOTE[status]}
          </LabeledList.Item>
        ),
      )}
    </>
  );
}

/** the bytes nothing above could be blamed for, one line each. */
export function UnattributedList(props: { unattributed: Unattributed }) {
  const { unattributed } = props;
  const rows: [string, Exact, string][] = [
    [
      'Shared',
      unattributed.shared_bytes,
      'held in more than one place, so there is no one var to blame',
    ],
    [
      'Globals',
      unattributed.global_bytes,
      'held by a global, a client, or a paused proc',
    ],
    [
      'Alists',
      unattributed.alist_bytes,
      'held by an alist, and those have no typepath to point at',
    ],
    ['No holder', unattributed.orphan_bytes, 'nothing named reaches it at all'],
    ['Too deep', unattributed.deep_bytes, 'buried deeper than the walk goes'],
  ];

  return (
    <LabeledList>
      {rows.map(([label, value, why]) => (
        <LabeledList.Item key={label} label={label}>
          {bytes(value)} {why}
        </LabeledList.Item>
      ))}
      <LabeledList.Item label="Total">
        {bytes(unattributed.unattributed_bytes)} that is not on any row above
      </LabeledList.Item>
    </LabeledList>
  );
}

/** a bar sized against the biggest row in the same table. */
export function BytesBar(props: { value: Exact; max: number; color?: string }) {
  const { value, max, color = 'teal' } = props;

  return (
    <ProgressBar
      value={exact(value)}
      minValue={0}
      maxValue={max || 1}
      color={color}
    >
      {bytes(value)}
    </ProgressBar>
  );
}
