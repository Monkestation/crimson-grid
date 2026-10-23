import { useLayoutEffect, useRef, useState } from 'react';
import { Box, ByondUi } from 'tgui-core/components';

const rectsOverlap = (a, b) =>
  a.x < b.x + b.w && a.x + a.w > b.x && a.y < b.y + b.h && a.y + a.h > b.y;

// Same map-pane positioning as PcSecurityCamera, extracted so it can be reused.
export const NightcrawlerFeed = ({ mapRef, desktopRef, coverRects = [] }) => {
  const [covered, setCovered] = useState(false);
  const feedRef = useRef(null);
  const lastSent = useRef('');

  useLayoutEffect(() => {
    const el = feedRef.current;
    if (!el) {
      return;
    }
    const r = el.getBoundingClientRect();
    const d = desktopRef?.current?.getBoundingClientRect() || {
      left: 0,
      top: 0,
      width: window.innerWidth,
      height: window.innerHeight,
    };
    const feed = {
      x: r.left - d.left,
      y: r.top - d.top,
      w: r.width,
      h: r.height,
    };
    const outside =
      feed.x < 0 ||
      feed.y < 0 ||
      feed.x + feed.w > d.width ||
      feed.y + feed.h > d.height;
    const nowCovered = outside || coverRects.some((c) => rectsOverlap(feed, c));
    if (nowCovered !== covered) {
      setCovered(nowCovered);
      return;
    }
    if (nowCovered || !mapRef) {
      lastSent.current = '';
      return;
    }
    const ratio = window.devicePixelRatio || 1;
    const pos = `${Math.round(r.left * ratio)},${Math.round(r.top * ratio)}`;
    const size = `${Math.round(r.width * ratio)}x${Math.round(
      r.height * ratio,
    )}`;
    const key = `${mapRef}|${pos}|${size}`;
    if (key === lastSent.current) {
      return;
    }
    lastSent.current = key;
    window.Byond?.winset?.(mapRef, { pos, size });
  });

  return (
    <div
      style={{
        position: 'relative',
        background: '#000',
        height: 300,
        overflow: 'hidden',
      }}
    >
      <div
        ref={feedRef}
        style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: 0 }}
      >
        {mapRef && !covered ? (
          <ByondUi
            height="100%"
            width="100%"
            params={{ id: mapRef, type: 'map' }}
          />
        ) : (
          <Box p={2} color="label">
            {covered
              ? 'Feed paused (window obscured)'
              : 'Loading camera feed...'}
          </Box>
        )}
      </div>
    </div>
  );
};
