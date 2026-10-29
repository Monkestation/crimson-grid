const decodeEntities = (s) =>
  s
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;|&apos;/g, "'")
    .replace(/&amp;/g, '&'); // keep last so it doesn't double-decode

const TAG_RE =
  /\[(\/?)(b|i|u)\]|\[br\]|<(\/?)(b|strong|i|em|u)\s*>|<br\s*\/?>|<\/?[a-z][^>]*>/gi;

export const PcRichText = ({ text }) => {
  const src = decodeEntities(text || '');
  const out = [];
  let bold = false;
  let italic = false;
  let under = false;
  let last = 0;
  let key = 0;

  const push = (str) => {
    if (!str) return;
    out.push(
      <span
        key={key++}
        style={{
          fontWeight: bold ? 'bold' : undefined,
          fontStyle: italic ? 'italic' : undefined,
          textDecoration: under ? 'underline' : undefined,
        }}
      >
        {str}
      </span>,
    );
  };

  for (const m of src.matchAll(TAG_RE)) {
    const start = m.index ?? 0;
    push(src.slice(last, start));
    last = start + m[0].length;

    const name = (m[2] || m[4] || '').toLowerCase();
    if (name) {
      const open = (m[1] ?? m[3]) !== '/';
      if (name === 'b' || name === 'strong') bold = open;
      else if (name === 'i' || name === 'em') italic = open;
      else under = open;
    } else if (/^(<br|\[br)/i.test(m[0])) {
      push('\n');
    }
    // anything else was an unsupported tag: dropped
  }
  push(src.slice(last));
  return <>{out}</>;
};
