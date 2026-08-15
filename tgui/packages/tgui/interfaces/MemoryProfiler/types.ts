// THIS IS A CRIMSON UI FILE
import type { BooleanLike } from 'tgui-core/react';

/**
 * numbers that come over as text, because BYOND floats go to shit past 2^24 and a
 * rounded list id points at some completely different list. parse them with format.ts
 * where you use them - a JS number stays exact up to 2^53.
 */
export type Exact = string;

/** where a list was found hanging. */
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
   * nobody's measured how big this kind is, so we don't charge it any bytes. that is
   * not the same as it being free. everything gets measured these days, so a false
   * here means some new kind turned up without anyone measuring it.
   */
  costed: BooleanLike;
};

/**
 * what the walk did with a list, and why it skipped one.
 *
 * `empty` is not a failure. most lists on a real station are empty, and throwing them
 * in with the three below makes a perfectly healthy station look like it's full of a
 * shitload of broken lists.
 */
export type ListWalkStatus =
  | 'walked'
  | 'empty'
  | 'no_vector'
  | 'length_absurd'
  | 'over_capacity';

/** the three that mean something is actually wrong. */
export type ListFailure = Exclude<ListWalkStatus, 'walked' | 'empty'>;

export const LIST_FAILURES: ListFailure[] = [
  'no_vector',
  'over_capacity',
  'length_absurd',
];

/** why a skipped list got skipped. goes straight into tooltips, so write it like a person. */
export const LIST_STATUS_NOTE: Record<ListWalkStatus, string> = {
  walked: 'Read it, and blamed its bytes on whatever holds it.',
  empty: 'Holds nothing. Counted it, nothing inside to blame on anyone.',
  no_vector:
    'Says it has a length but points at nothing, so whatever it holds went uncounted.',
  over_capacity:
    'Says it holds more than it has room for. Either caught mid-resize or just broken. Did not read it.',
  length_absurd:
    'Claims a length over 8 million, which is nonsense. Skipped it instead of reading off the end and eating shit.',
};

export type ListRow = {
  list_id: Exact;
  /** who's holding it, up to 8 hops before it gives up and sticks a "..." on the front. */
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
 * every list one type var holds, added up over every instance of that type.
 *
 * the per-list rows just can't show you this. they stop at a couple thousand sorted by
 * size, so a var with 8,000 instances holding 2 KiB each is 16 MiB smeared so thin that
 * no single row is ever big enough to make the page. these come off the whole world
 * instead of off the page.
 */
export type ListGroupRow = {
  /** no pre-joined `owner` on purpose - `var_pair` in format.ts sticks these together. */
  typepath: string;
  var: string;
  /** counts lists nested inside this one too. */
  lists: Exact;
  /**
   * instances holding one directly. can be more than `bytes` covers, since a list held
   * twice has a holder but nobody you can pin the bytes on.
   */
  direct_lists: Exact;
  elements: Exact;
  assoc_nodes: Exact;
  bytes: Exact;
  /**
   * the empty-list half of the row above. three things worth keeping apart.
   *
   * `empty_lists` counts nested empties too. `empty_direct` counts instances holding one
   * directly and doesn't care about refcounts. neither one alone sees every row - a var
   * holding a single list stuffed with 8,000 empties has an `empty_direct` of 0, and a
   * var holding a shared empty has an `empty_lists` of 0 - so `empty_rank` is whichever
   * is bigger. the extension works that out itself, so clicking that column gets its
   * order back rather than a second opinion.
   *
   * if two things hold the same empty list, its bytes go on the shared pile instead of
   * on this var, so `empty_bytes` can read `'0'` next to a non-zero `empty_direct`, same
   * as `bytes` next to `direct_lists`. `empty_capacity` is room those empties still hang
   * onto - non-zero means a leftover vector, usually 4 slots each from getting emptied
   * one element at a time instead of with one Cut().
   */
  empty_rank: Exact;
  empty_lists: Exact;
  empty_direct: Exact;
  empty_bytes: Exact;
  empty_capacity: Exact;
};

/** bytes it couldn't pin on any row. */
export type Unattributed = {
  /** held in more than one place, so who owns it is anyone's guess. */
  shared_bytes: Exact;
  global_bytes: Exact;
  alist_bytes: Exact;
  orphan_bytes: Exact;
  /** chains that ran deeper than the walk follows. */
  deep_bytes: Exact;
  unattributed_bytes: Exact;
};

/** every list, split up by what the walk did with it. */
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
 * list bytes we managed to pin on something. the five gave-up piles add up to
 * `unattributed_bytes`, and they come over flat instead of nested under their own key.
 */
export type Retained = Unattributed & {
  by_type: RetainedRow[];
  by_type_truncated: BooleanLike;
};

/**
 * one of the other things BYOND allocates that we charge bytes for.
 *
 * some of these only get looked at sometimes - not off Windows, not on a build where
 * the signatures didn't match, not if the caller skipped it. both numbers read zero
 * either way, so `walked` is the only thing telling "looked, found nothing" apart from
 * "never looked".
 */
export type StorageRow = {
  /** the extension's own name for it: `alist_records`, `string_table`. STORAGE_META makes it readable. */
  label: string;
  bytes: Exact;
  /** records, nodes or frames, whichever this row counts. zero for table pointers. */
  count: Exact;
  walked: BooleanLike;
};

/** the honest bit. every total in a report is partial and these keys say how. */
export type Footer = {
  table_pointer_bytes: Exact;
  /**
   * words, not a number: what every total in the report leaves out. follows the run and
   * not the build, so two scans on different platforms say different things.
   */
  exclusions: string;
  /** words. where a list can hide so well it looks like nobody holds it. */
  orphan_sources: string;
  /**
   * counted, but nobody's measured how big they are, so they got no bytes charged.
   * should always be zero these days - it's here to catch the next kind that turns up
   * without a measurement.
   */
  uncosted_instances: Exact;
  /** false off Windows, where every *_bytes key in the report reads "0". */
  bytes_available: BooleanLike;
  image_base_verified: BooleanLike;
  turfs_walked: BooleanLike;
  alists_walked: BooleanLike;
  /**
   * table pointer arrays plus everything that only gets looked at sometimes. optional
   * because an older extension build sends a footer with no key at all, and drawing
   * that as an empty table would claim nothing got charged.
   */
  storage?: StorageRow[];
};

/**
 * what the walk knows about the list table without working out who holds what. kept
 * separate from the owner half because a world too big to fit its ownership graph still
 * reports all of this - see `Census`.
 */
export type ListCounts = {
  lists_total: Exact;
  list_bytes: Exact;
  /** lists with something wrong with them. non-zero means we missed something. empties aren't in here. */
  unwalked_lists: Exact;
  skipped: SkipCounts;
  /**
   * what the empties cost: 24 bytes of header each, plus whatever vector they kept.
   * `skipped.empty` says how many, this says why you should care. doesn't include the
   * 4-byte list-table slot they each take - that's in `footer.table_pointer_bytes`.
   */
  empty_bytes: Exact;
  /** of `empty_bytes`, the part that's kept vector rather than header. */
  empty_capacity_bytes: Exact;
  /** empty lists that kept a vector, so they got cleared rather than born empty. */
  empty_with_capacity: Exact;
  /** elements those lists still have room for. */
  empty_capacity_slots: Exact;
};

/** the half of the totals that only exists once we know who holds what. */
export type ListAttribution = {
  /** lists nothing named reaches. a lot of these is either a leak or something we don't look at. */
  orphan_lists: Exact;
  /** how many distinct type vars hold at least one list. */
  groups_total: Exact;
  /**
   * empty lists held directly by a var we can name, added up over every pair rather
   * than over the rows that fit. `skipped.empty` minus this is how many nothing named holds.
   */
  empty_attributed: Exact;
  /**
   * pairs holding at least one empty list: what `empty_groups` has before it gets cut
   * down. `groups_total` counts every pair, so it's bigger than this.
   */
  empty_groups_total: Exact;
};

/** the list totals, which get flattened into both the lists report and the full scan. */
export type ListsHeader = ListCounts & ListAttribution;

/** everything a full scan carries whether or not it worked out who holds what. */
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
 * a full scan, in one of its two shapes.
 *
 * a world whose ownership graph wouldn't fit in memory still gets one: the typepath
 * breakdown, the var counts and the storage numbers are every bit as true, and on a
 * station big enough to hit that ceiling they're usually what you came for anyway. `ok`
 * is still TRUE, `owners_unavailable` is set, and the who-holds-what half is **gone**
 * instead of zeroed - `orphan_lists: 0` would read as "everything has an owner", said
 * by a scan that worked out zero owners.
 *
 * a union and not a pile of optional fields, so reading `census.retained` without
 * narrowing first won't compile instead of quietly drawing `0 B` everywhere.
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
   * the same rows, cut down to vars holding an empty list and ordered by how many. its
   * own array because `list_groups` goes biggest-first and chops its tail off, and the
   * tail is exactly where a var holding two hundred bare 24-byte empties lives.
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
  /** true on the first call, or the first one after a clear. every number is zero. */
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
  /** false wherever BYOND's own report symbols didn't turn up, which is always off Windows. */
  byond_available: BooleanLike;
  /** the key is missing, not null, when there's nothing to show. */
  byond_raw?: string;
};

/** which byondcore tables this build could get at. older than the ok/kind wrapper. */
export type Coverage = {
  build: number;
  /** false means we missed tables and every total in every report is short. */
  complete: BooleanLike;
  scanned: string[];
  forward_validated: string[];
  fallback: string[];
  unavailable: string[];
};

export type ReportMeta = {
  captured_at: string;
  captured_by: string;
  /** deciseconds the server spent frozen. */
  duration_ds: number;
};

export type DumpEntry = {
  path: string;
  name: string;
  kind: string;
  rows: Exact;
  total: Exact;
  truncated: BooleanLike;
  /** BYOND measured it, so past 16 MB it's a guess. a hint, not a real number. */
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
   * what a row costs, read off the extension's own numbers at startup. `/client` alone
   * moves between builds, so typing a copy out by hand would be quietly wrong on some.
   *
   * `bytes` is a real number here, unlike everything else on this panel - every value is
   * hardcoded and under two thousand, so there's nothing for a float to lose. `note` is
   * the caveat no report field carries: a base size is the floor, and `/client`'s floor
   * has buffers piled on top that nobody follows.
   */
  base_sizes: { label: string; bytes: number; note?: string }[];
};
