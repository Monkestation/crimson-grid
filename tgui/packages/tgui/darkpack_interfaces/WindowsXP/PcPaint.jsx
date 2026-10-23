import { useEffect, useRef, useState } from 'react';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const MAX_UNDO = 40;
const TRANSPARENT = '------';
const ZOOMS = [1, 2, 3, 4, 6, 8, 10, 12, 16];
const PALETTE = [
  '#000000',
  '#ffffff',
  '#7f7f7f',
  '#c3c3c3',
  '#880015',
  '#ed1c24',
  '#ff7f27',
  '#fff200',
  '#22b14c',
  '#b5e61d',
  '#00a2e8',
  '#3f48cc',
  '#a349a4',
  '#ffaec9',
  '#b97a57',
  '#99d9ea',
];
const TOOLS = [
  { id: 'pencil', icon: 'pen', label: 'Pencil' },
  { id: 'eraser', icon: 'eraser', label: 'Eraser' },
  { id: 'fill', icon: 'fill-drip', label: 'Fill bucket' },
  { id: 'picker', icon: 'eye-dropper', label: 'Color picker' },
  { id: 'line', icon: 'slash', label: 'Line' },
  { id: 'rect', icon: 'square', label: 'Rectangle' },
  { id: 'ellipse', icon: 'circle', label: 'Ellipse' },
  { id: 'move', icon: 'arrows-alt', label: 'Move layer contents' },
  { id: 'pan', icon: 'hand-paper', label: 'Pan view (or middle/right-drag)' },
];

const hex2 = (n) => ('0' + n.toString(16)).slice(-2);

const parseColor = (text) => {
  const m = /^#?([0-9a-f]{6})$/i.exec(String(text).trim());
  if (!m) return null;
  const v = parseInt(m[1], 16);
  return [(v >> 16) & 255, (v >> 8) & 255, v & 255, 255];
};

const clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));

const makeLayer = (id, name, w, h, fill) => {
  const px = new Uint8ClampedArray(w * h * 4);
  if (fill) px.fill(255);
  return { id, name, visible: true, opacity: 100, px };
};

const newDoc = (w, h) => ({
  w,
  h,
  layers: [makeLayer(1, 'Background', w, h, true)],
  active: 0,
  nextId: 2,
});

const snapshot = (doc) => ({
  w: doc.w,
  h: doc.h,
  active: doc.active,
  nextId: doc.nextId,
  layers: doc.layers.map((l) => ({ ...l, px: new Uint8ClampedArray(l.px) })),
});

const composite = (doc, target) => {
  const { w, h } = doc;
  const ctx = target.getContext('2d');
  ctx.clearRect(0, 0, w, h);
  const tmp = document.createElement('canvas');
  tmp.width = w;
  tmp.height = h;
  const tctx = tmp.getContext('2d');
  const img = tctx.createImageData(w, h);
  for (const l of doc.layers) {
    if (!l.visible) continue;
    img.data.set(l.px);
    tctx.putImageData(img, 0, 0);
    ctx.globalAlpha = l.opacity / 100;
    ctx.drawImage(tmp, 0, 0);
  }
  ctx.globalAlpha = 1;
};

const flattenToWire = (doc) => {
  const c = document.createElement('canvas');
  c.width = doc.w;
  c.height = doc.h;
  composite(doc, c);
  const px = c.getContext('2d').getImageData(0, 0, doc.w, doc.h).data;
  const out = [];
  for (let i = 0; i < px.length; i += 4) {
    out.push(
      px[i + 3] < 128
        ? TRANSPARENT
        : hex2(px[i]) + hex2(px[i + 1]) + hex2(px[i + 2]),
    );
  }
  return out.join('');
};

const wireToPixels = (wire, w, h) => {
  const px = new Uint8ClampedArray(w * h * 4);
  for (let i = 0; i < w * h; i++) {
    const c = wire.substr(i * 6, 6);
    if (c === TRANSPARENT || c.length < 6) continue;
    const v = parseInt(c, 16);
    px[i * 4] = (v >> 16) & 255;
    px[i * 4 + 1] = (v >> 8) & 255;
    px[i * 4 + 2] = v & 255;
    px[i * 4 + 3] = 255;
  }
  return px;
};

///prims
const setPx = (d, layer, x, y, c) => {
  if (x < 0 || y < 0 || x >= d.w || y >= d.h) return;
  const i = (y * d.w + x) * 4;
  layer.px[i] = c[0];
  layer.px[i + 1] = c[1];
  layer.px[i + 2] = c[2];
  layer.px[i + 3] = c[3];
};

// Square brush centered on (x, y).
const stamp = (d, layer, x, y, size, c) => {
  const off = Math.floor((size - 1) / 2);
  for (let j = 0; j < size; j++)
    for (let i = 0; i < size; i++) setPx(d, layer, x - off + i, y - off + j, c);
};

const line = (x0, y0, x1, y1, cb) => {
  if (![x0, y0, x1, y1].every(Number.isFinite)) return;
  const dx = Math.abs(x1 - x0);
  const dy = -Math.abs(y1 - y0);
  const sx = x0 < x1 ? 1 : -1;
  const sy = y0 < y1 ? 1 : -1;
  let err = dx + dy;
  for (;;) {
    cb(x0, y0);
    if (x0 === x1 && y0 === y1) break;
    const e2 = 2 * err;
    if (e2 >= dy) {
      err += dy;
      x0 += sx;
    }
    if (e2 <= dx) {
      err += dx;
      y0 += sy;
    }
  }
};

const drawRect = (d, layer, a, b, size, c, filled) => {
  const x0 = Math.min(a[0], b[0]);
  const x1 = Math.max(a[0], b[0]);
  const y0 = Math.min(a[1], b[1]);
  const y1 = Math.max(a[1], b[1]);
  if (filled) {
    for (let y = y0; y <= y1; y++)
      for (let x = x0; x <= x1; x++) setPx(d, layer, x, y, c);
    return;
  }
  const s = (x, y) => stamp(d, layer, x, y, size, c);
  line(x0, y0, x1, y0, s);
  line(x1, y0, x1, y1, s);
  line(x1, y1, x0, y1, s);
  line(x0, y1, x0, y0, s);
};

const drawEllipse = (d, layer, a, b, size, c, filled) => {
  const x0 = Math.min(a[0], b[0]);
  const x1 = Math.max(a[0], b[0]);
  const y0 = Math.min(a[1], b[1]);
  const y1 = Math.max(a[1], b[1]);
  const cx = (x0 + x1) / 2;
  const cy = (y0 + y1) / 2;
  const rx = (x1 - x0) / 2 + 0.5;
  const ry = (y1 - y0) / 2 + 0.5;
  if (filled) {
    for (let y = y0; y <= y1; y++)
      for (let x = x0; x <= x1; x++) {
        const nx = (x - cx) / rx;
        const ny = (y - cy) / ry;
        if (nx * nx + ny * ny <= 1) setPx(d, layer, x, y, c);
      }
    return;
  }
  const steps = Math.max(32, Math.ceil(Math.PI * (rx + ry) * 2));
  for (let t = 0; t < steps; t++) {
    const ang = (t / steps) * Math.PI * 2;
    stamp(
      d,
      layer,
      Math.round(cx + (rx - 0.5) * Math.cos(ang)),
      Math.round(cy + (ry - 0.5) * Math.sin(ang)),
      size,
      c,
    );
  }
};

// Scanline flood fill on one layer, exact color match.
const floodFill = (d, layer, sx, sy, c) => {
  if (sx < 0 || sy < 0 || sx >= d.w || sy >= d.h) return;
  const { w, h } = d;
  const p = layer.px;
  const idx = (x, y) => (y * w + x) * 4;
  const i0 = idx(sx, sy);
  const tr = p[i0];
  const tg = p[i0 + 1];
  const tb = p[i0 + 2];
  const ta = p[i0 + 3];
  if (tr === c[0] && tg === c[1] && tb === c[2] && ta === c[3]) return;
  const match = (i) =>
    p[i] === tr && p[i + 1] === tg && p[i + 2] === tb && p[i + 3] === ta;
  const stack = [[sx, sy]];
  while (stack.length) {
    const [x0, y] = stack.pop();
    let x = x0;
    while (x >= 0 && match(idx(x, y))) x--;
    x++;
    let up = false;
    let down = false;
    while (x < w && match(idx(x, y))) {
      setPx(d, layer, x, y, c);
      if (y > 0) {
        const m = match(idx(x, y - 1));
        if (m && !up) {
          stack.push([x, y - 1]);
          up = true;
        } else if (!m) up = false;
      }
      if (y < h - 1) {
        const m = match(idx(x, y + 1));
        if (m && !down) {
          stack.push([x, y + 1]);
          down = true;
        } else if (!m) down = false;
      }
      x++;
    }
  }
};

// Copies `src` into the layer shifted by (dx, dy); anything pushed off-canvas is lost.
const shiftInto = (d, layer, src, dx, dy) => {
  layer.px.fill(0);
  for (let y = 0; y < d.h; y++) {
    const ny = y + dy;
    if (ny < 0 || ny >= d.h) continue;
    for (let x = 0; x < d.w; x++) {
      const nx = x + dx;
      if (nx < 0 || nx >= d.w) continue;
      const s = (y * d.w + x) * 4;
      const t = (ny * d.w + nx) * 4;
      layer.px[t] = src[s];
      layer.px[t + 1] = src[s + 1];
      layer.px[t + 2] = src[s + 2];
      layer.px[t + 3] = src[s + 3];
    }
  }
};

// Alpha-blends `top` (at opacity %) over `bottom`, writing into `bottom`.
const blendDown = (top, bottom) => {
  const op = top.opacity / 100;
  const t = top.px;
  const b = bottom.px;
  for (let i = 0; i < b.length; i += 4) {
    const ta = (t[i + 3] / 255) * op;
    const ba = b[i + 3] / 255;
    const oa = ta + ba * (1 - ta);
    if (oa <= 0) {
      b[i] = b[i + 1] = b[i + 2] = b[i + 3] = 0;
      continue;
    }
    for (let k = 0; k < 3; k++)
      b[i + k] = (t[i + k] * ta + b[i + k] * ba * (1 - ta)) / oa;
    b[i + 3] = oa * 255;
  }
};

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

export const PcPaint = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const photos = Array.isArray(data.photos) ? data.photos : [];
  const limits = data.limits || { min: 8, max: 128, chunk: 2400, name: 40 };
  const cooldown = data.cooldown_left || 0;

  const docRef = useRef(null);
  if (!docRef.current) docRef.current = newDoc(48, 48);
  const hist = useRef({ undo: [], redo: [] });
  const canvasRef = useRef(null);
  const dragRef = useRef(null);
  const lastImport = useRef(null);
  const viewRef = useRef(null); // the viewport element
  const pan = useRef({ x: 16, y: 16 }); // canvas offset inside the viewport, px

  const [, setTick] = useState(0);
  const redraw = () => setTick((t) => t + 1);

  const [tool, setTool] = useState('pencil');
  const [color, setColor] = useState('#000000');
  const [size, setSize] = useState(1);
  const [filled, setFilled] = useState(false);
  const [zoom, setZoom] = useState(8);
  const [grid, setGrid] = useState(true);
  const [importMode, setImportMode] = useState('new');
  const [sizeW, setSizeW] = useState('48');
  const [sizeH, setSizeH] = useState('48');
  const [exportName, setExportName] = useState('Painting');
  const [progress, setProgress] = useState(null);
  const S = useRef({});
  S.current = {
    tool,
    size,
    filled,
    color,
    zoom,
    rgba: parseColor(color) || [0, 0, 0, 255],
  };

  const d = docRef.current;
  const layer = d.layers[d.active];

  const pushUndo = () => {
    const h = hist.current;
    h.undo.push(snapshot(docRef.current));
    if (h.undo.length > MAX_UNDO) h.undo.shift();
    h.redo = [];
  };

  const undo = () => {
    const h = hist.current;
    if (!h.undo.length) return;
    h.redo.push(snapshot(docRef.current));
    docRef.current = h.undo.pop();
    redraw();
  };

  const redo = () => {
    const h = hist.current;
    if (!h.redo.length) return;
    h.undo.push(snapshot(docRef.current));
    docRef.current = h.redo.pop();
    redraw();
  };

  useEffect(() => {
    if (canvasRef.current) composite(docRef.current, canvasRef.current);
  });

  const posFromEvent = (e) => {
    const c = canvasRef.current;
    const doc = docRef.current;
    const r = c.getBoundingClientRect();
    if (!r.width || !r.height) return [0, 0];
    const x = Math.floor(((e.clientX - r.left) * doc.w) / r.width);
    const y = Math.floor(((e.clientY - r.top) * doc.h) / r.height);
    return [clamp(x, -64, doc.w + 64), clamp(y, -64, doc.h + 64)];
  };

  const onMove = (e) => {
    const dr = dragRef.current;
    if (!dr) return;
    if (dr.tool === 'pan') {
      pan.current = {
        x: dr.px0 + (e.clientX - dr.sx),
        y: dr.py0 + (e.clientY - dr.sy),
      };
      redraw();
      return;
    }
    const doc = docRef.current;
    const lay = doc.layers[doc.active];
    if (!lay || lay !== dr.layer) return;
    const s = S.current;
    const [x, y] = posFromEvent(e);
    if (dr.tool === 'pencil' || dr.tool === 'eraser') {
      line(dr.last[0], dr.last[1], x, y, (px, py) =>
        stamp(doc, lay, px, py, s.size, dr.rgba),
      );
      dr.last = [x, y];
    } else {
      lay.px.set(dr.base);
      if (dr.tool === 'line') {
        line(dr.start[0], dr.start[1], x, y, (px, py) =>
          stamp(doc, lay, px, py, s.size, dr.rgba),
        );
      } else if (dr.tool === 'rect') {
        drawRect(doc, lay, dr.start, [x, y], s.size, dr.rgba, s.filled);
      } else if (dr.tool === 'ellipse') {
        drawEllipse(doc, lay, dr.start, [x, y], s.size, dr.rgba, s.filled);
      } else if (dr.tool === 'move') {
        shiftInto(doc, lay, dr.base, x - dr.start[0], y - dr.start[1]);
      }
    }
    redraw();
  };

  const onUp = () => {
    dragRef.current = null;
    window.removeEventListener('mousemove', stable.current.move);
    window.removeEventListener('mouseup', stable.current.up);
    redraw();
  };

  const H = useRef({});
  H.current = { move: onMove, up: onUp };
  const stable = useRef(null);
  if (!stable.current) {
    stable.current = {
      move: (e) => H.current.move(e),
      up: (e) => H.current.up(e),
    };
  }
  useEffect(
    () => () => {
      window.removeEventListener('mousemove', stable.current.move);
      window.removeEventListener('mouseup', stable.current.up);
    },
    [],
  );

  const centerView = (z = S.current.zoom) => {
    const v = viewRef.current;
    if (!v) return;
    const doc = docRef.current;
    const r = v.getBoundingClientRect();
    pan.current = {
      x: Math.round((r.width - doc.w * z) / 2),
      y: Math.round((r.height - doc.h * z) / 2),
    };
    redraw();
  };

  const zoomTo = (z, cx, cy) => {
    const v = viewRef.current;
    const old = S.current.zoom;
    if (v && z !== old) {
      const r = v.getBoundingClientRect();
      const px = cx === undefined ? r.width / 2 : cx - r.left;
      const py = cy === undefined ? r.height / 2 : cy - r.top;
      const p = pan.current;
      pan.current = {
        x: Math.round(px - ((px - p.x) / old) * z),
        y: Math.round(py - ((py - p.y) / old) * z),
      };
    }
    S.current.zoom = z;
    setZoom(z);
  };

  const stepZoom = (dir, cx, cy) => {
    const i = ZOOMS.indexOf(S.current.zoom);
    const j = clamp((i < 0 ? 0 : i) + dir, 0, ZOOMS.length - 1);
    zoomTo(ZOOMS[j], cx, cy);
  };

  const onViewDown = (e) => {
    const onCanvas = e.target === canvasRef.current;
    const wantsPan =
      e.button === 1 ||
      e.button === 2 ||
      (e.button === 0 && (S.current.tool === 'pan' || !onCanvas));
    if (!wantsPan) return;
    e.preventDefault();
    dragRef.current = {
      tool: 'pan',
      sx: e.clientX,
      sy: e.clientY,
      px0: pan.current.x,
      py0: pan.current.y,
    };
    window.addEventListener('mousemove', stable.current.move);
    window.addEventListener('mouseup', stable.current.up);
  };

  const onWheel = (e) => {
    if (!e.deltaY) return;
    stepZoom(e.deltaY < 0 ? 1 : -1, e.clientX, e.clientY);
  };

  useEffect(() => {
    centerView();
  }, []);

  const onDown = (e) => {
    if (e.button !== 0 || S.current.tool === 'pan') return; // the viewport handles panning
    e.preventDefault();
    const doc = docRef.current;
    const lay = doc.layers[doc.active];
    const s = S.current;
    const [x, y] = posFromEvent(e);

    if (s.tool === 'picker') {
      if (x < 0 || y < 0 || x >= doc.w || y >= doc.h) return;
      const p = canvasRef.current
        .getContext('2d')
        .getImageData(x, y, 1, 1).data;
      if (p[3] > 0) setColor('#' + hex2(p[0]) + hex2(p[1]) + hex2(p[2])); //you can prefer all you want linters its not gonna change
      return;
    }
    if (!lay.visible) return;

    pushUndo();
    const rgba = s.tool === 'eraser' ? [0, 0, 0, 0] : s.rgba;

    if (s.tool === 'fill') {
      floodFill(doc, lay, x, y, rgba);
      redraw();
      return;
    }

    dragRef.current = {
      tool: s.tool,
      layer: lay,
      start: [x, y],
      last: [x, y],
      rgba,
      base: new Uint8ClampedArray(lay.px),
    };
    if (s.tool === 'pencil' || s.tool === 'eraser') {
      stamp(doc, lay, x, y, s.size, rgba);
    }
    window.addEventListener('mousemove', stable.current.move);
    window.addEventListener('mouseup', stable.current.up);
    redraw();
  };

  const newCanvas = () => {
    const w = clamp(parseInt(sizeW, 10) || 48, limits.min, limits.max);
    const h = clamp(parseInt(sizeH, 10) || 48, limits.min, limits.max);
    pushUndo();
    docRef.current = newDoc(w, h);
    setSizeW(String(w));
    setSizeH(String(h));
    centerView();
  };

  const resizeCanvas = () => {
    const doc = docRef.current;
    const nw = clamp(parseInt(sizeW, 10) || doc.w, limits.min, limits.max);
    const nh = clamp(parseInt(sizeH, 10) || doc.h, limits.min, limits.max);
    pushUndo();
    const layers = doc.layers.map((l) => {
      const px = new Uint8ClampedArray(nw * nh * 4);
      const cw = Math.min(doc.w, nw);
      for (let y = 0; y < Math.min(doc.h, nh); y++) {
        px.set(l.px.subarray(y * doc.w * 4, (y * doc.w + cw) * 4), y * nw * 4);
      }
      return { ...l, px };
    });
    docRef.current = { ...doc, w: nw, h: nh, layers };
    setSizeW(String(nw));
    setSizeH(String(nh));
    redraw();
  };

  const addLayer = () => {
    pushUndo();
    const doc = docRef.current;
    const id = doc.nextId++;
    doc.layers.splice(
      doc.active + 1,
      0,
      makeLayer(id, `Layer ${id}`, doc.w, doc.h),
    );
    doc.active += 1;
    redraw();
  };

  const duplicateLayer = () => {
    pushUndo();
    const doc = docRef.current;
    const src = doc.layers[doc.active];
    const id = doc.nextId++;
    doc.layers.splice(doc.active + 1, 0, {
      ...src,
      id,
      name: `${src.name} copy`,
      px: new Uint8ClampedArray(src.px),
    });
    doc.active += 1;
    redraw();
  };

  const deleteLayer = () => {
    const doc = docRef.current;
    if (doc.layers.length <= 1) return;
    pushUndo();
    doc.layers.splice(doc.active, 1);
    doc.active = Math.min(doc.active, doc.layers.length - 1);
    redraw();
  };

  const moveLayer = (dir) => {
    const doc = docRef.current;
    const to = doc.active + dir;
    if (to < 0 || to >= doc.layers.length) return;
    pushUndo();
    const [l] = doc.layers.splice(doc.active, 1);
    doc.layers.splice(to, 0, l);
    doc.active = to;
    redraw();
  };

  const mergeDown = () => {
    const doc = docRef.current;
    if (doc.active <= 0) return;
    pushUndo();
    blendDown(doc.layers[doc.active], doc.layers[doc.active - 1]);
    doc.layers.splice(doc.active, 1);
    doc.active -= 1;
    redraw();
  };

  const clearLayer = () => {
    pushUndo();
    docRef.current.layers[docRef.current.active].px.fill(0);
    redraw();
  };

  const flipLayer = (horizontal) => {
    pushUndo();
    const doc = docRef.current;
    const lay = doc.layers[doc.active];
    const src = new Uint8ClampedArray(lay.px);
    for (let y = 0; y < doc.h; y++)
      for (let x = 0; x < doc.w; x++) {
        const nx = horizontal ? doc.w - 1 - x : x;
        const ny = horizontal ? y : doc.h - 1 - y;
        const s = (y * doc.w + x) * 4;
        const t = (ny * doc.w + nx) * 4;
        for (let k = 0; k < 4; k++) lay.px[t + k] = src[s + k];
      }
    redraw();
  };

  const imp = data.import;
  const impId = imp ? imp.id : null;
  useEffect(() => {
    if (!imp || imp.id === lastImport.current) return;
    lastImport.current = imp.id;
    const px = wireToPixels(imp.data, imp.w, imp.h);
    pushUndo();
    const doc = docRef.current;
    if (importMode === 'new') {
      docRef.current = {
        w: imp.w,
        h: imp.h,
        layers: [{ id: 1, name: imp.name, visible: true, opacity: 100, px }],
        active: 0,
        nextId: 2,
      };
      setSizeW(String(imp.w));
      setSizeH(String(imp.h));
    } else {
      const lay = makeLayer(doc.nextId++, imp.name, doc.w, doc.h);
      for (let y = 0; y < Math.min(imp.h, doc.h); y++) {
        const cw = Math.min(imp.w, doc.w);
        lay.px.set(
          px.subarray(y * imp.w * 4, (y * imp.w + cw) * 4),
          y * doc.w * 4,
        );
      }
      doc.layers.splice(doc.active + 1, 0, lay);
      doc.active += 1;
    }
    setExportName(imp.name);
    act('import_ack', { id: imp.id });
    if (importMode === 'new') centerView();
    else redraw();
  }, [impId]);

  const exportPhoto = async () => {
    if (progress !== null || cooldown > 0) return;
    const doc = docRef.current;
    const wire = flattenToWire(doc);
    const chunk = Math.max(6, Math.floor(limits.chunk / 6) * 6);
    setProgress(0);
    act('export_begin', { w: doc.w, h: doc.h, name: exportName });
    await sleep(120);
    for (let off = 0; off < wire.length; off += chunk) {
      act('export_chunk', { offset: off, data: wire.substr(off, chunk) });
      setProgress(Math.round((off / wire.length) * 100));
      await sleep(60);
    }
    act('export_finish');
    setProgress(null);
  };

  const gridOn = grid && zoom >= 6;
  const label = { fontWeight: 'bold', fontSize: '11px', opacity: 0.8 };

  return (
    <Stack fill>
      <Stack.Item basis="168px" shrink={0}>
        <Section fill scrollable title="Tools">
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '2px' }}>
            {TOOLS.map((t) => (
              <Button
                key={t.id}
                icon={t.icon}
                tooltip={t.label}
                selected={tool === t.id}
                onClick={() => setTool(t.id)}
              />
            ))}
          </Box>

          <Box mt={1} style={label}>
            Brush size: {size}px
          </Box>
          <Button icon="minus" onClick={() => setSize(Math.max(1, size - 1))} />
          <Button icon="plus" onClick={() => setSize(Math.min(16, size + 1))} />
          <Button
            ml={1}
            icon={filled ? 'square' : 'square-o'}
            selected={filled}
            tooltip="Fill rectangles and ellipses"
            onClick={() => setFilled(!filled)}
          >
            Fill
          </Button>

          <Box mt={1} style={label}>
            Color
          </Box>
          <Box style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
            <input
              type="color"
              value={color}
              onChange={(e) => setColor(e.target.value)}
              style={{ width: 32, height: 24, padding: 0, border: 'none' }}
            />
            <Input
              width="80px"
              value={color}
              onChange={(a, b) => {
                const v = readInput(a, b);
                const p = parseColor(v);
                if (p) setColor('#' + v.replace('#', '').toLowerCase());
              }}
            />
          </Box>
          <Box
            mt={0.5}
            style={{ display: 'flex', flexWrap: 'wrap', gap: '2px' }}
          >
            {PALETTE.map((c) => (
              <Box
                key={c}
                onClick={() => setColor(c)}
                style={{
                  width: 18,
                  height: 18,
                  background: c,
                  cursor: 'pointer',
                  border:
                    color.toLowerCase() === c
                      ? '2px solid #ffd400'
                      : '1px solid #666',
                }}
              />
            ))}
          </Box>

          <Box mt={1} style={label}>
            Edit
          </Box>
          <Button
            icon="undo"
            disabled={!hist.current.undo.length}
            onClick={undo}
          />
          <Button
            icon="redo"
            disabled={!hist.current.redo.length}
            onClick={redo}
          />
          <Button
            icon="arrows-alt-h"
            tooltip="Flip layer horizontally"
            onClick={() => flipLayer(true)}
          />
          <Button
            icon="arrows-alt-v"
            tooltip="Flip layer vertically"
            onClick={() => flipLayer(false)}
          />

          <Box mt={1} style={label}>
            View
          </Box>
          <Button icon="search-minus" onClick={() => stepZoom(-1)} />
          <Button icon="search-plus" onClick={() => stepZoom(1)} />
          <Button
            icon="crosshairs"
            tooltip="Center the canvas"
            onClick={() => centerView()}
          />
          <Button
            icon="border-all"
            selected={grid}
            tooltip="Pixel grid (zoom 6x and up)"
            onClick={() => setGrid(!grid)}
          />
          <Box mt={0.5}>{zoom}x</Box>
          <Box style={{ fontSize: '10px' }}>
            Wheel zooms. Pan with middle/right-drag, the Hand tool, or by
            dragging the background.
          </Box>

          <Box mt={1} style={label}>
            Canvas ({d.w}×{d.h})
          </Box>
          <Box style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
            <Input
              width="48px"
              value={sizeW}
              onChange={(a, b) => setSizeW(readInput(a, b))}
            />
            ×
            <Input
              width="48px"
              value={sizeH}
              onChange={(a, b) => setSizeH(readInput(a, b))}
            />
          </Box>
          <Box style={{ fontSize: '10px' }}>
            {limits.min}–{limits.max} px
          </Box>
          <Button mt={0.5} icon="file" onClick={newCanvas}>
            New
          </Button>
          <Button mt={0.5} icon="expand" onClick={resizeCanvas}>
            Resize
          </Button>
        </Section>
      </Stack.Item>

      <Stack.Item grow style={{ position: 'relative', minWidth: 0 }}>
        <div
          ref={viewRef}
          onMouseDown={onViewDown}
          onWheel={onWheel}
          onContextMenu={(e) => e.preventDefault()}
          style={{
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            overflow: 'hidden',
            background: '#2b2b2b',
            cursor: tool === 'pan' ? 'grab' : 'default',
          }}
        >
          <Box
            style={{
              position: 'absolute',
              left: pan.current.x,
              top: pan.current.y,
              display: 'inline-block',
              backgroundColor: '#ffffff',
              backgroundImage:
                'linear-gradient(45deg,#ccc 25%,transparent 25%,transparent 75%,#ccc 75%),' +
                'linear-gradient(45deg,#ccc 25%,transparent 25%,transparent 75%,#ccc 75%)',
              backgroundSize: '16px 16px',
              backgroundPosition: '0 0, 8px 8px',
              border: '1px solid #000',
              lineHeight: 0,
            }}
          >
            <canvas
              ref={canvasRef}
              width={d.w}
              height={d.h}
              onMouseDown={onDown}
              onDragStart={(e) => e.preventDefault()}
              style={{
                width: d.w * zoom,
                height: d.h * zoom,
                imageRendering: 'pixelated',
                cursor:
                  tool === 'pan'
                    ? 'grab'
                    : tool === 'move'
                      ? 'move'
                      : 'crosshair',
                display: 'block',
              }}
            />
            {gridOn && (
              <div
                style={{
                  position: 'absolute',
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  pointerEvents: 'none',
                  backgroundImage:
                    'linear-gradient(to right,rgba(0,0,0,0.25) 1px,transparent 1px),' +
                    'linear-gradient(to bottom,rgba(0,0,0,0.25) 1px,transparent 1px)',
                  backgroundSize: `${zoom}px ${zoom}px`,
                }}
              />
            )}
          </Box>
        </div>
      </Stack.Item>

      <Stack.Item basis="210px" shrink={0}>
        <Section fill scrollable title="Layers">
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '2px' }}>
            <Button icon="plus" tooltip="New layer" onClick={addLayer} />
            <Button icon="clone" tooltip="Duplicate" onClick={duplicateLayer} />
            <Button
              icon="trash"
              tooltip="Delete"
              disabled={d.layers.length <= 1}
              onClick={deleteLayer}
            />
            <Button
              icon="arrow-up"
              tooltip="Move up"
              onClick={() => moveLayer(1)}
            />
            <Button
              icon="arrow-down"
              tooltip="Move down"
              onClick={() => moveLayer(-1)}
            />
            <Button
              icon="level-down-alt"
              tooltip="Merge down"
              disabled={d.active <= 0}
              onClick={mergeDown}
            />
            <Button icon="eraser" tooltip="Clear layer" onClick={clearLayer} />
          </Box>

          <Box mt={1}>
            {d.layers
              .map((l, i) => ({ l, i }))
              .reverse()
              .map(({ l, i }) => (
                <Box
                  key={l.id}
                  mb={0.5}
                  p={0.5}
                  onClick={() => {
                    docRef.current.active = i;
                    redraw();
                  }}
                  style={{
                    cursor: 'pointer',
                    background:
                      i === d.active
                        ? 'rgba(80,140,255,0.35)'
                        : 'rgba(0,0,0,0.25)',
                    border:
                      i === d.active ? '1px solid #5a8cff' : '1px solid #444',
                  }}
                >
                  <Button
                    compact
                    icon={l.visible ? 'eye' : 'eye-slash'}
                    onClick={(e) => {
                      if (e && e.stopPropagation) e.stopPropagation();
                      l.visible = !l.visible;
                      redraw();
                    }}
                  />
                  <Box inline ml={0.5}>
                    {l.name}
                  </Box>
                  <Box style={{ fontSize: '10px' }}>Opacity {l.opacity}%</Box>
                </Box>
              ))}
          </Box>

          <Box mt={1} style={label}>
            Active layer
          </Box>
          <Input
            fluid
            value={layer.name}
            maxLength={24}
            onChange={(a, b) => {
              layer.name = readInput(a, b) || layer.name;
              redraw();
            }}
          />
          <Box mt={0.5}>
            <Button
              icon="minus"
              onClick={() => {
                layer.opacity = Math.max(0, layer.opacity - 10);
                redraw();
              }}
            />
            <Box inline mx={1}>
              {layer.opacity}%
            </Box>
            <Button
              icon="plus"
              onClick={() => {
                layer.opacity = Math.min(100, layer.opacity + 10);
                redraw();
              }}
            />
          </Box>

          <Box mt={2} style={label}>
            Import a photo
          </Box>
          <Box>
            <Button
              selected={importMode === 'new'}
              onClick={() => setImportMode('new')}
            >
              New canvas
            </Button>
            <Button
              selected={importMode === 'layer'}
              onClick={() => setImportMode('layer')}
            >
              As layer
            </Button>
          </Box>
          {photos.length === 0 ? (
            <Box mt={0.5}>You aren&apos;t carrying any photos.</Box>
          ) : (
            photos.map((p) => (
              <Button
                key={p.ref}
                fluid
                mt={0.5}
                icon="camera"
                onClick={() => act('import_photo', { photo: p.ref })}
              >
                {p.name}
              </Button>
            ))
          )}

          <Box mt={2} style={label}>
            Export as photo
          </Box>
          <Input
            fluid
            value={exportName}
            maxLength={limits.name}
            onChange={(a, b) => setExportName(readInput(a, b))}
          />
          <Button
            fluid
            mt={0.5}
            icon="print"
            color="good"
            disabled={progress !== null || cooldown > 0}
            onClick={exportPhoto}
          >
            {progress !== null
              ? `Sending… ${progress}%`
              : cooldown > 0
                ? `Wait ${cooldown}s`
                : 'Export'}
          </Button>
          <Box mt={0.5} style={{ fontSize: '10px' }}>
            Layers are flattened; pixels more than half transparent export as
            transparent.
          </Box>
          {!!data.message && (
            <Box mt={1} color="average" bold>
              {data.message}
            </Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
