import { useEffect, useState } from 'react';
import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';
import { useProgram } from './useProgram';

const LEVELS = {
  Beginner: { rows: 9, cols: 9, mines: 10 },
  Intermediate: { rows: 16, cols: 16, mines: 40 },
};

const STATUSES = ['ready', 'playing', 'won', 'lost'];

const NUM_COLORS = [
  '',
  '#0000ff',
  '#008000',
  '#ff0000',
  '#000080',
  '#800000',
  '#008080',
  '#000000',
  '#808080',
];

const CELL = 24;
const FRAME = 2; // grid border width

const emptyBoard = (rows, cols) =>
  Array.from({ length: rows * cols }, () => ({
    mine: false,
    revealed: false,
    flagged: false,
    boom: false,
    wrong: false,
    adj: 0,
  }));

const neighbors = (i, rows, cols) => {
  const r = Math.floor(i / cols);
  const c = i % cols;
  const out = [];
  for (let dr = -1; dr <= 1; dr++) {
    for (let dc = -1; dc <= 1; dc++) {
      if (dr === 0 && dc === 0) continue;
      const nr = r + dr;
      const nc = c + dc;
      if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
      out.push(nr * cols + nc);
    }
  }
  return out;
};

const computeAdj = (board, rows, cols) => {
  board.forEach((c, i) => {
    c.adj = neighbors(i, rows, cols).filter((n) => board[n].mine).length;
  });
  return board;
};

const placeMines = (board, rows, cols, mines, safe) => {
  const forbidden = new Set([safe, ...neighbors(safe, rows, cols)]);
  const candidates = [];
  for (let i = 0; i < board.length; i++) {
    if (!forbidden.has(i)) candidates.push(i);
  }
  for (let i = candidates.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [candidates[i], candidates[j]] = [candidates[j], candidates[i]];
  }
  const mineSet = new Set(candidates.slice(0, mines));
  const next = board.map((c, i) => ({ ...c, mine: mineSet.has(i) }));
  return computeAdj(next, rows, cols);
};

const floodReveal = (board, rows, cols, start) => {
  const next = board.map((c) => ({ ...c }));
  const stack = [start];
  while (stack.length) {
    const i = stack.pop();
    const cell = next[i];
    if (cell.revealed || cell.flagged) continue;
    cell.revealed = true;
    if (cell.adj === 0 && !cell.mine) {
      neighbors(i, rows, cols).forEach((n) => {
        stack.push(n);
      });
    }
  }
  return next;
};

const encodeState = (level, status, time, board) =>
  JSON.stringify({
    l: level,
    s: status,
    t: time,
    b: board
      .map((c) =>
        String.fromCharCode(
          48 +
            (c.mine ? 1 : 0) +
            (c.revealed ? 2 : 0) +
            (c.flagged ? 4 : 0) +
            (c.boom ? 8 : 0) +
            (c.wrong ? 16 : 0),
        ),
      )
      .join(''),
  });

const decodeState = (raw) => {
  try {
    if (!raw) return null;
    const o = JSON.parse(raw);
    const l = LEVELS[o.l];
    if (!l || typeof o.b !== 'string' || o.b.length !== l.rows * l.cols) {
      return null;
    }
    const board = [...o.b].map((ch) => {
      const v = ch.charCodeAt(0) - 48;
      return {
        mine: !!(v & 1),
        revealed: !!(v & 2),
        flagged: !!(v & 4),
        boom: !!(v & 8),
        wrong: !!(v & 16),
        adj: 0,
      };
    });
    computeAdj(board, l.rows, l.cols);
    return {
      level: o.l,
      status: STATUSES.includes(o.s) ? o.s : 'ready',
      time: Math.min(Number(o.t) || 0, 999),
      board,
    };
  } catch (e) {
    return null;
  }
};

const lcd = (n) =>
  (n < 0 ? '-' : '') + String(Math.abs(n)).padStart(n < 0 ? 2 : 3, '0');

const Lcd = ({ value }) => (
  <Box
    inline
    bold
    px={1}
    style={{
      background: '#000',
      color: '#f00',
      fontFamily: 'monospace',
      fontSize: '20px',
      border: '2px solid #444',
    }}
  >
    {lcd(value)}
  </Box>
);

const Cell = ({ cell, onClick, onFlag }) => {
  let content = null;
  if (cell.revealed) {
    if (cell.mine) {
      content = <Icon name="bomb" color={cell.boom ? '#fff' : '#000'} />;
    } else if (cell.adj > 0) {
      content = (
        <span style={{ color: NUM_COLORS[cell.adj], fontWeight: 'bold' }}>
          {cell.adj}
        </span>
      );
    }
  } else if (cell.wrong) {
    content = <Icon name="times" color="#c00" />;
  } else if (cell.flagged) {
    content = <Icon name="flag" color="#c00" />;
  }
  const border = cell.revealed
    ? { border: '1px solid #808080' }
    : {
        borderTop: '3px solid #fff',
        borderLeft: '3px solid #fff',
        borderBottom: '3px solid #808080',
        borderRight: '3px solid #808080',
      };
  return (
    <div
      onClick={onClick}
      onContextMenu={(e) => {
        e.preventDefault();
        onFlag();
      }}
      style={{
        width: CELL,
        height: CELL,
        boxSizing: 'border-box',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        cursor: 'pointer',
        userSelect: 'none',
        background: cell.boom ? '#f00' : '#c0c0c0',
        color: '#000',
        ...border,
      }}
    >
      {content}
    </div>
  );
};

export const PcMinesweeper = (props, context) => {
  const { act, data } = useProgram(props.programId, context);

  const [level, setLevel] = useState('Beginner');
  const { rows, cols, mines } = LEVELS[level];
  const [board, setBoard] = useState(() => emptyBoard(9, 9));
  const [status, setStatus] = useState('ready');
  const [time, setTime] = useState(0);
  const [hydrated, setHydrated] = useState(false);

  useEffect(() => {
    if (hydrated || typeof data.saved_state !== 'string') return;
    const s = decodeState(data.saved_state);
    if (s) {
      setLevel(s.level);
      setBoard(s.board);
      setStatus(s.status);
      setTime(s.time);
    }
    setHydrated(true);
  }, [data.saved_state, hydrated]);

  useEffect(() => {
    if (status !== 'playing') return undefined;
    const t = setInterval(() => setTime((v) => Math.min(v + 1, 999)), 1000);
    return () => clearInterval(t);
  }, [status]);

  useEffect(() => {
    if (!hydrated) return;
    act('save', { state: encodeState(level, status, time, board) });
  }, [hydrated, level, status, board]);

  const restart = (lvl = level) => {
    const l = LEVELS[lvl];
    setLevel(lvl);
    setBoard(emptyBoard(l.rows, l.cols));
    setStatus('ready');
    setTime(0);
  };

  const over = status === 'won' || status === 'lost';
  const flags = board.filter((c) => c.flagged).length;

  const toggleFlag = (i) => {
    if (over || board[i].revealed) return;
    const next = board.map((c) => ({ ...c }));
    next[i].flagged = !next[i].flagged;
    setBoard(next);
  };

  const click = (i) => {
    if (over) return;
    let b = board;
    if (status === 'ready') {
      b = placeMines(board, rows, cols, mines, i);
      setStatus('playing');
    }
    const cell = b[i];
    if (cell.flagged || cell.revealed) {
      setBoard(b);
      return;
    }
    if (cell.mine) {
      const lost = b.map((c, idx) => ({
        ...c,
        revealed: c.revealed || (c.mine && !c.flagged),
        boom: idx === i,
        wrong: c.flagged && !c.mine,
      }));
      setBoard(lost);
      setStatus('lost');
      return;
    }
    let next = floodReveal(b, rows, cols, i);
    if (next.every((c) => c.mine || c.revealed)) {
      next = next.map((c) => (c.mine ? { ...c, flagged: true } : c));
      setStatus('won');
    }
    setBoard(next);
  };

  const face =
    status === 'won' ? 'grin-stars' : status === 'lost' ? 'dizzy' : 'smile';

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          buttons={Object.keys(LEVELS).map((l) => (
            <Button key={l} selected={level === l} onClick={() => restart(l)}>
              {l}
            </Button>
          ))}
        >
          <div style={{ width: cols * CELL + FRAME * 2, margin: '0 auto' }}>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                marginBottom: 6,
              }}
            >
              <Lcd value={mines - flags} />
              <Button icon={face} onClick={() => restart()} />
              <Lcd value={time} />
            </div>
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: `repeat(${cols}, ${CELL}px)`,
                border: `${FRAME}px solid #444`,
              }}
            >
              {board.map((cell, i) => (
                <Cell
                  key={i}
                  cell={cell}
                  onClick={() => click(i)}
                  onFlag={() => toggleFlag(i)}
                />
              ))}
            </div>
            {over && (
              <Box
                bold
                mt={1}
                textAlign="center"
                color={status === 'won' ? 'good' : 'bad'}
              >
                {status === 'won' ? `You win! (${time}s)` : 'Boom! You lose.'}
              </Box>
            )}
          </div>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
