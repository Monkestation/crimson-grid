// THIS IS A CRIMSON UI FILE
import type { Data, Exact, ReportMeta } from './types';

/** turn one of the extension's text-numbers back into a number. */
export function exact(value: Exact | number | undefined | null): number {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
}

const UNITS = ['B', 'KB', 'MB', 'GB', 'TB'];

/**
 * divides by 1024, same as the extension's own `human()`, byte for byte. not
 * `formatSiUnit` from tgui-core - that divides by 1000, and then every number on this
 * panel quietly disagrees with the text reports it's supposed to be showing you.
 */
export function bytes(value: Exact | number | undefined | null): string {
  const raw = exact(value);
  let scaled = raw;
  let unit = 0;
  while (scaled >= 1024 && unit < UNITS.length - 1) {
    scaled /= 1024;
    unit += 1;
  }
  if (unit === 0) {
    return `${raw} B`;
  }
  return `${scaled.toFixed(2)} ${UNITS[unit]}`;
}

/**
 * `/datum/reagents::reagent_list` - a row's two name fields stuck together. done here
 * instead of over the wire: saves a third string per row on every one of the thousands
 * of type vars a world has, and the two tables showing it can't end up spelling it
 * differently.
 */
export function var_pair(row: { typepath: string; var: string }): string {
  return `${row.typepath}::${row.var}`;
}

/** commas every three digits, by hand, so the BYOND webview's locale can't mess with it. */
export function count(value: Exact | number | undefined | null): string {
  return exact(value)
    .toString()
    .replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

export function signed_count(value: Exact | undefined): string {
  const parsed = exact(value);
  return parsed > 0 ? `+${count(parsed)}` : count(parsed);
}

export function signed_bytes(value: Exact | undefined): string {
  const parsed = exact(value);
  if (parsed === 0) {
    return bytes(0);
  }
  return `${parsed > 0 ? '+' : '-'}${bytes(Math.abs(parsed))}`;
}

/** 'good' for shrinking, 'bad' for growing. memory going up is the bad way round. */
export function delta_color(value: Exact | undefined): string | undefined {
  const parsed = exact(value);
  if (parsed > 0) {
    return 'bad';
  }
  if (parsed < 0) {
    return 'good';
  }
  return undefined;
}

/** deciseconds of frozen server, shown as seconds. */
export function duration(deciseconds: number): string {
  return `${(deciseconds / 10).toFixed(1)}s`;
}

/**
 * DM json_encodes an empty assoc list as `[]` instead of `{}`, because of course it
 * does, so `report_meta` is an array until something writes the first key into it.
 * that's what the isArray check is for.
 */
export function meta_for(
  meta: Data['report_meta'],
  kind: string,
): ReportMeta | undefined {
  if (!meta || Array.isArray(meta)) {
    return undefined;
  }
  return meta[kind];
}
