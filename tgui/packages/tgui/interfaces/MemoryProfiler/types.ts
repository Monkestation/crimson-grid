// THIS IS A CRIMSON UI FILE
import type { BooleanLike } from 'tgui-core/react';

/**
 * A number the extension refuses to hand over as a number.
 *
 * BYOND floats stop being exact past 2^24, and a rounded list id names a different
 * list, so every byte count, element count and id crosses as text. Parse with the
 * helpers in format.ts at the point of use; a JS number is exact to 2^53.
 */
export type Exact = string;

/** Where a list was found hanging. */
export type OwnerSite =
  | 'var'
  | 'global'
  | 'list_index'
  | 'list_assoc'
  | 'client_slot'
  | 'alist_value'
  | 'proc_slot'
  | 'vis_vector'
  | 'orphan';

export type TypeRow = {
  typepath: string;
  count: Exact;
  self_bytes: Exact;
  /**
   * False means no verified base size to charge, not that the type is free.
   * Every kind the walk reaches has one now, so a false here is a kind that
   * shipped without a traced base size rather than a state the walk expects.
   */
  costed: BooleanLike;
};

/**
 * What the walk did with a list, and if it skipped it, why.
 *
 * `empty` is not a failure - an empty list is a normal list, and on a real world
 * it is most of them. It used to share a single `contents_walked: false` flag
 * with the three below, which made a healthy world report several hundred
 * thousand corrupt slots.
 */
export type ListWalkStatus =
  | 'walked'
  | 'empty'
  | 'no_vector'
  | 'length_absurd'
  | 'over_capacity';

/** The three statuses that mean something is actually wrong. */
export type ListFailure = Exclude<ListWalkStatus, 'walked' | 'empty'>;

export const LIST_FAILURES: ListFailure[] = [
  'no_vector',
  'over_capacity',
  'length_absurd',
];

/**
 * Why a skipped list was skipped, in words. Says what happened rather than
 * naming the guard that caught it.
 */
export const LIST_STATUS_NOTE: Record<ListWalkStatus, string> = {
  walked: 'Contents were read and attributed.',
  empty: 'Holds nothing. Counted, with no contents to attribute.',
  no_vector:
    'Claims a length but points at no storage, so nothing it holds was counted.',
  over_capacity:
    'Says it holds more than it has room for - caught mid-resize, or corrupt. Contents were not read.',
  length_absurd:
    'Reports an impossible length, over 8 million. Skipped rather than read past the end of the allocation.',
};

export type ListRow = {
  list_id: Exact;
  /** Rendered ownership chain, up to 8 hops before it truncates with a leading "...". */
  owner: string;
  owner_site: OwnerSite;
  length: Exact;
  allocated: Exact;
  ref_count: number;
  assoc_nodes: number;
  bytes: Exact;
  capacity_sane: BooleanLike;
  walk_status: ListWalkStatus;
};

/**
 * Every list one type var holds, summed across all instances of that type.
 *
 * The view the per-list rows structurally cannot give: those cap at a couple of
 * thousand sorted by size, so a var with 8,000 instances of 2 KiB each is 16 MiB
 * that shows up nowhere. Computed over the whole world, not over the page.
 */
export type ListGroupRow = {
  /**
   * There is deliberately no pre-joined `owner` here. The extension used to
   * send one and dropped it - see `varPair` in `format.ts`, which is where the
   * join lives now. Per-*list* rows still have `owner`; that one is a rendered
   * ownership chain and there is nothing else to build it from.
   */
  typepath: string;
  var: string;
  /** Rolled up, including lists nested inside this one. */
  lists: Exact;
  /**
   * How many instances hold one directly. Can exceed what `bytes` accounts for:
   * a list held twice has a holder but no single owner to charge.
   */
  direct_lists: Exact;
  elements: Exact;
  assoc_nodes: Exact;
  bytes: Exact;
  /**
   * How many empty lists this pair is answerable for: the larger of
   * `empty_direct` and `empty_lists`, and the order `empty_groups` arrives in.
   *
   * Shipped rather than recomputed here, so a re-sort on this column lands in
   * the same order the extension chose. Neither counter alone sees every row:
   * a var holding one list full of 8,000 empties has `empty_direct` of 0, and
   * a var holding a shared empty has `empty_lists` of 0.
   */
  empty_rank: Exact;
  /**
   * Empty lists rolled up, nested ones included. Counterpart of `lists`. Below
   * `empty_direct` means some are held more than once, so their bytes went to
   * the shared bucket instead of to this var.
   */
  empty_lists: Exact;
  /**
   * How many instances hold an empty list directly. Refcount-independent, like
   * `direct_lists`, so this is the column that answers "which var has the most
   * empty lists" without a caveat attached.
   */
  empty_direct: Exact;
  /**
   * Bytes from the rolled-up empties. Can read `'0'` against a non-zero
   * `empty_direct`, for the same reason `bytes` can against `direct_lists`.
   */
  empty_bytes: Exact;
  /**
   * Elements those empties still have room for. Non-zero means lists left
   * holding a vector remnant, typically 4 slots each from having been emptied
   * an element at a time rather than in one Cut().
   */
  empty_capacity: Exact;
};

/** What the rollup could not charge to any row. */
export type Unattributed = {
  /** Held more than once, so ownership is genuinely ambiguous. */
  shared_bytes: Exact;
  global_bytes: Exact;
  alist_bytes: Exact;
  orphan_bytes: Exact;
  /** Chains that ran past the hop cap. */
  deep_bytes: Exact;
  unattributed_bytes: Exact;
};

/** Every list, split by what the walk did with it. */
export type SkipCounts = {
  walked: Exact;
  empty: Exact;
  no_vector: Exact;
  length_absurd: Exact;
  over_capacity: Exact;
};

export type VarRow = {
  name: string;
  count: Exact;
  bytes: Exact;
};

export type DiffRow = {
  typepath: string;
  count_before: Exact;
  count_after: Exact;
  count_change: Exact;
  bytes_before: Exact;
  bytes_after: Exact;
  bytes_change: Exact;
};

export type RetainedRow = {
  typepath: string;
  bytes: Exact;
};

/**
 * List bytes, attributed. The five give-up buckets sum to unattributed_bytes.
 *
 * Those five are flattened into this object on the wire rather than nested, so
 * they read the same here as they do on their own in a lists report.
 */
export type Retained = Unattributed & {
  by_type: RetainedRow[];
  by_type_truncated: BooleanLike;
};

/**
 * One storage class the census charges bytes for.
 *
 * Several of these passes are conditional - they do not run off Windows, on a build
 * whose signatures fail, or for a caller that skipped the census recipe list. Both
 * numbers read zero either way, so `walked` is the only thing separating "walked and
 * found nothing" from "never looked".
 */
export type StorageRow = {
  /** Stable key, not a display string: `alist_records`, `string_table`, and so on. */
  label: string;
  bytes: Exact;
  /** Records, nodes or frames, whichever this row counts. Zero for table pointers. */
  count: Exact;
  walked: BooleanLike;
};

/** The honesty section. Every total in a report is partial and these keys say how. */
export type Footer = {
  table_pointer_bytes: Exact;
  /**
   * Prose, not a number. What is excluded from every total in the report.
   *
   * Follows the run rather than the build: a class drops off this sentence once its
   * pass actually ran, so two censuses on different platforms say different things.
   */
  exclusions: string;
  /** Prose. Where a list can hide such that it reads as an orphan. */
  orphan_sources: string;
  /**
   * Counted, but with no verified base size to charge. Nothing reaches this today -
   * area and client were the last two uncosted kinds and got their sizes traced on
   * 2026-08-02 - so it is a guard against the next kind that ships without one.
   */
  uncosted_instances: Exact;
  /** False off Windows, where every *_bytes key in the report is "0". */
  bytes_available: BooleanLike;
  image_base_verified: BooleanLike;
  turfs_walked: BooleanLike;
  alists_walked: BooleanLike;
  /**
   * Table pointer arrays plus every conditionally-walked storage class.
   *
   * Optional because an extension build older than the storage breakdown sends a
   * footer without the key, and a panel that renders that as an empty table would
   * be claiming nothing was charged.
   */
  storage?: StorageRow[];
};

/**
 * What the walk knows about the list table without having resolved one owner.
 *
 * Split from the attribution half because a world too big to fit its ownership
 * graph still reports every one of these - see `Census`.
 */
export type ListCounts = {
  lists_total: Exact;
  list_bytes: Exact;
  /**
   * Lists something was wrong with. Non-zero is a coverage gap.
   *
   * Empty lists are not in here - see `skipped`, which is the full breakdown.
   */
  unwalked_lists: Exact;
  skipped: SkipCounts;
  /**
   * What every empty list costs: 24 bytes of header each, plus any vector
   * capacity they kept. `skipped.empty` says how many; this says why to care.
   *
   * Excludes the 4-byte list-table slot each of them also occupies - that is
   * in `footer.table_pointer_bytes`.
   */
  empty_bytes: Exact;
  /** Of `empty_bytes`, the part that is retained capacity rather than header. */
  empty_capacity_bytes: Exact;
  /** Empty lists that kept a vector: cleared, rather than born empty. */
  empty_with_capacity: Exact;
  /** Elements those lists still have room for. */
  empty_capacity_slots: Exact;
};

/** The half of the totals that only exists once owners have been resolved. */
export type ListAttribution = {
  /** Lists no named root reaches. High is either a leak or a missed storage class. */
  orphan_lists: Exact;
  /** Distinct type vars holding at least one list. */
  groups_total: Exact;
  /**
   * Empty lists a named type var holds directly, summed over every pair rather
   * than over the capped rows. `skipped.empty` minus this is how many are held
   * by no named var - nested in another list, in a global, or orphaned.
   */
  empty_attributed: Exact;
  /**
   * Pairs holding at least one empty list - how many rows `empty_groups` has
   * before its cap. `groups_total` counts every pair, so it overstates this.
   */
  empty_groups_total: Exact;
};

/**
 * The lists section's totals.
 *
 * The extension flattens these into both the lists report and the census, so
 * they are declared once here rather than spelled out in each - the two had
 * already had to move together twice.
 */
export type ListsHeader = ListCounts & ListAttribution;

/** Everything a census carries whether or not it could name an owner. */
type CensusCommon = ListCounts & {
  ok: BooleanLike;
  build: number;
  total_instances: Exact;
  total_self_bytes: Exact;
  types_total: Exact;
  var_rows_total: Exact;
  var_bytes: Exact;
  vars_total: Exact;
  footer: Footer;
  types: TypeRow[];
  types_truncated: BooleanLike;
  vars: VarRow[];
  vars_truncated: BooleanLike;
};

/**
 * A census, in one of its two shapes.
 *
 * A world whose ownership graph did not fit in memory still gets a census: the
 * typepath breakdown, the var histogram and the storage block are exactly as
 * true, and on a station big enough to hit that ceiling they are usually what
 * someone came for. It arrives with `ok` still TRUE and `owners_unavailable`
 * set, and the attributed half **absent** rather than zeroed - `orphan_lists: 0`
 * would read as "every list has an owner", said by a census that resolved none.
 *
 * A union rather than a pile of optional fields, so a component that reads
 * `census.retained` without narrowing first fails to compile instead of
 * rendering `0 B` across the board.
 */
export type Census =
  | (CensusCommon &
      ListAttribution & {
        owners_unavailable?: undefined;
        retained: Retained;
        lists: ListRow[];
        lists_truncated: BooleanLike;
      })
  | (CensusCommon & { owners_unavailable: string });

export type ListsReport = ListsHeader & {
  ok: BooleanLike;
  build: number;
  lists: ListRow[];
  lists_truncated: BooleanLike;
  list_groups: ListGroupRow[];
  list_groups_truncated: BooleanLike;
  /**
   * The same rows, filtered to vars holding at least one empty list and
   * ordered by how many. Its own array because `list_groups` is biggest-first
   * and cuts its tail, and a var holding two hundred bare 24-byte empties
   * lives in exactly that tail.
   */
  empty_groups: ListGroupRow[];
  empty_groups_truncated: BooleanLike;
  unattributed: Unattributed;
};

export type VarsReport = {
  ok: BooleanLike;
  build: number;
  var_rows_total: Exact;
  var_bytes: Exact;
  vars_total: Exact;
  vars: VarRow[];
  vars_truncated: BooleanLike;
};

export type DiffReport = {
  ok: BooleanLike;
  build: number;
  /** True on the first call, or the first after a clear. Every number is zero. */
  no_baseline: BooleanLike;
  list_count_change: Exact;
  list_bytes_change: Exact;
  types_total: Exact;
  types: DiffRow[];
  types_truncated: BooleanLike;
};

export type CompatRow = {
  label: string;
  bytes: Exact;
  count: Exact;
};

export type CompatReport = {
  ok: BooleanLike;
  build: number;
  memprofile: CompatRow[];
  /** False wherever BYOND's own report symbols did not resolve, always off Windows. */
  byond_available: BooleanLike;
  /** Key is absent, not null, when unavailable. */
  byond_raw?: string;
};

/** Which byondcore tables this build could reach. Predates the ok/kind envelope. */
export type Coverage = {
  build: number;
  /** False means tables were skipped and every total in every report is short. */
  complete: BooleanLike;
  scanned: string[];
  forward_validated: string[];
  fallback: string[];
  unavailable: string[];
};

export type ReportMeta = {
  captured_at: string;
  captured_by: string;
  /** Deciseconds of frozen server. */
  duration_ds: number;
};

export type DumpEntry = {
  path: string;
  name: string;
  kind: string;
  rows: Exact;
  total: Exact;
  truncated: BooleanLike;
  /** Approximate past 16 MB, since BYOND measured it. A hint, not an accounting figure. */
  size: Exact;
  at: string;
};

export type Data = {
  enabled: BooleanLike;
  error: string | null;
  last_error: string | null;
  busy: BooleanLike;
  coverage: Coverage | null;
  census: Census | null;
  lists_report: ListsReport | null;
  vars_report: VarsReport | null;
  diff_report: DiffReport | null;
  compat_report: CompatReport | null;
  debug_text: string | null;
  /** DM json_encodes an empty assoc list as [], so this is an array until first use. */
  report_meta: Record<string, ReportMeta> | [];
  baseline_at: string | null;
  baseline_by: string | null;
  dumps: DumpEntry[];
  panel_row_options: number[];
  dump_row_options: (number | string)[];
  /**
   * The legend for "what a row costs", read off the extension's own constants at init
   * rather than transcribed - `/client` alone moves between builds, so a copy would be
   * silently wrong on some of them.
   *
   * `bytes` is a real number here, unlike everywhere else on this panel: every value is
   * a compile-time constant under two thousand, so there is nothing for a float to lose.
   * `note` is a caveat no report field carries - a base size is a floor, and for
   * `/client` it is a floor with unfollowed buffers on top of it.
   */
  base_sizes: { label: string; bytes: number; note?: string }[];
};
