import { useEffect, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { useProgram } from './useProgram';

const SUITS = ['♠', '♥', '♦', '♣'];
const RED = [false, true, true, false];
const RANKS = [
  '',
  'A',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  'J',
  'Q',
  'K',
];

const CARD_W = 46;
const CARD_H = 64;
const GAP = 8;
const UP_OFFSET = 22;
const DOWN_OFFSET = 10;

const newGame = () => {
  const deck = [];
  for (let s = 0; s < 4; s++) {
    for (let r = 1; r <= 13; r++) deck.push({ suit: s, rank: r, up: false });
  }
  for (let i = deck.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [deck[i], deck[j]] = [deck[j], deck[i]];
  }
  let k = 0;
  const tab = [];
  for (let c = 0; c < 7; c++) {
    const pile = [];
    for (let j = 0; j <= c; j++) pile.push({ ...deck[k++], up: j === c });
    tab.push(pile);
  }
  return {
    stock: deck.slice(k),
    waste: [],
    found: [[], [], [], []], // indexed by suit
    tab,
    moves: 0,
  };
};

const encCard = (c) => c.suit * 13 + (c.rank - 1) + (c.up ? 64 : 0);
const decCard = (v) => ({
  suit: Math.floor((v & 63) / 13),
  rank: ((v & 63) % 13) + 1,
  up: !!(v & 64),
});

const encodeGame = (g) =>
  JSON.stringify({
    s: g.stock.map(encCard),
    w: g.waste.map(encCard),
    f: g.found.map((p) => p.map(encCard)),
    t: g.tab.map((p) => p.map(encCard)),
    m: g.moves,
  });

const decodeGame = (raw) => {
  try {
    if (!raw) return null;
    const o = JSON.parse(raw);
    const game = {
      stock: o.s.map(decCard),
      waste: o.w.map(decCard),
      found: o.f.map((p) => p.map(decCard)),
      tab: o.t.map((p) => p.map(decCard)),
      moves: Number(o.m) || 0,
    };
    if (game.found.length !== 4 || game.tab.length !== 7) return null;
    const all = [
      ...game.stock,
      ...game.waste,
      ...game.found.flat(),
      ...game.tab.flat(),
    ];
    if (all.length !== 52) return null;
    if (all.some((c) => !(c.suit >= 0 && c.suit < 4))) return null;
    if (new Set(all.map((c) => c.suit * 13 + c.rank)).size !== 52) return null;
    return game;
  } catch (e) {
    return null;
  }
};

const cloneGame = (g) => ({
  ...g,
  stock: [...g.stock],
  waste: [...g.waste],
  found: g.found.map((p) => [...p]),
  tab: g.tab.map((p) => [...p]),
});

const canStack = (card, pile) => {
  if (pile.length === 0) return card.rank === 13;
  const top = pile[pile.length - 1];
  return (
    top.up && RED[top.suit] !== RED[card.suit] && top.rank === card.rank + 1
  );
};

const isRun = (cards) => {
  for (let i = 0; i < cards.length; i++) {
    if (!cards[i].up) return false;
    if (i > 0) {
      const prev = cards[i - 1];
      if (
        RED[prev.suit] === RED[cards[i].suit] ||
        prev.rank !== cards[i].rank + 1
      ) {
        return false;
      }
    }
  }
  return true;
};

const getCards = (g, sel) => {
  if (sel.from === 'waste') return g.waste.slice(-1);
  if (sel.from === 'found') return g.found[sel.col].slice(-1);
  return g.tab[sel.col].slice(sel.idx);
};

const takeCards = (g, sel) => {
  if (sel.from === 'waste') return g.waste.splice(g.waste.length - 1, 1);
  if (sel.from === 'found') {
    return g.found[sel.col].splice(g.found[sel.col].length - 1, 1);
  }
  const pile = g.tab[sel.col];
  const taken = pile.splice(sel.idx);
  const top = pile[pile.length - 1];
  if (top && !top.up) pile[pile.length - 1] = { ...top, up: true };
  return taken;
};

const tryMove = (g, sel, dest) => {
  const cards = getCards(g, sel);
  if (!cards.length) return null;
  const first = cards[0];
  if (dest.to === 'found') {
    if (cards.length !== 1 || sel.from === 'found') return null;
    if (g.found[first.suit].length + 1 !== first.rank) return null;
    const ng = cloneGame(g);
    const [taken] = takeCards(ng, sel);
    ng.found[first.suit].push(taken);
    ng.moves++;
    return ng;
  }
  if (sel.from === 'tab' && sel.col === dest.col) return null;
  if (!canStack(first, g.tab[dest.col])) return null;
  const ng = cloneGame(g);
  const taken = takeCards(ng, sel);
  ng.tab[dest.col].push(...taken);
  ng.moves++;
  return ng;
};

const cardStyle = (extra) => ({
  position: 'absolute',
  width: CARD_W,
  height: CARD_H,
  boxSizing: 'border-box',
  borderRadius: 4,
  userSelect: 'none',
  cursor: 'pointer',
  ...extra,
});

const CardView = ({
  card,
  selected,
  left = 0,
  top = 0,
  onClick,
  onDoubleClick,
}) => {
  const color = RED[card.suit] ? '#c00' : '#000';
  return (
    <div
      onClick={onClick}
      onDoubleClick={onDoubleClick}
      style={cardStyle({
        left,
        top,
        border: '1px solid #222',
        background: card.up
          ? '#fff'
          : 'repeating-linear-gradient(45deg, #1d4f9c, #1d4f9c 4px, #2b66c4 4px, #2b66c4 8px)',
        boxShadow: selected ? '0 0 0 2px #ffd700' : 'none',
        color,
      })}
    >
      {!!card.up && (
        <>
          <div style={{ fontSize: 12, fontWeight: 'bold', padding: '1px 3px' }}>
            {RANKS[card.rank]}
            {SUITS[card.suit]}
          </div>
          <div
            style={{
              position: 'absolute',
              bottom: 2,
              right: 5,
              fontSize: 22,
              lineHeight: 1,
            }}
          >
            {SUITS[card.suit]}
          </div>
        </>
      )}
    </div>
  );
};

const Slot = ({ label, onClick, left = 0 }) => (
  <div
    onClick={onClick}
    style={cardStyle({
      left,
      top: 0,
      border: '2px dashed rgba(255, 255, 255, 0.35)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: 'rgba(255, 255, 255, 0.45)',
      fontSize: 22,
    })}
  >
    {label}
  </div>
);

const slotLeft = (i) => i * (CARD_W + GAP);

export const PcSolitaire = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const [game, setGame] = useState(newGame);
  const [sel, setSel] = useState(null);
  const [hydrated, setHydrated] = useState(false);

  useEffect(() => {
    if (hydrated || typeof data.saved_state !== 'string') return;
    const g = decodeGame(data.saved_state);
    if (g) setGame(g);
    setHydrated(true);
  }, [data.saved_state, hydrated]);

  useEffect(() => {
    if (!hydrated) return;
    act('save', { state: encodeGame(game) });
  }, [hydrated, game]);

  const won = game.found.every((p) => p.length === 13);

  const apply = (ng) => {
    setGame(ng);
    setSel(null);
  };

  const restart = () => {
    setGame(newGame());
    setSel(null);
  };

  const onStock = () => {
    if (won) return;
    const ng = cloneGame(game);
    if (ng.stock.length) {
      const c = ng.stock.pop();
      ng.waste.push({ ...c, up: true });
    } else if (ng.waste.length) {
      ng.stock = ng.waste.reverse().map((c) => ({ ...c, up: false }));
      ng.waste = [];
    } else {
      return;
    }
    apply(ng);
  };

  const onWaste = () => {
    if (!game.waste.length) return;
    setSel(sel?.from === 'waste' ? null : { from: 'waste' });
  };

  const onFound = (col) => {
    if (sel) {
      const ng = tryMove(game, sel, { to: 'found' });
      if (ng) {
        apply(ng);
        return;
      }
      setSel(null);
    } else if (game.found[col].length) {
      setSel({ from: 'found', col });
    }
  };

  const onTab = (col, idx) => {
    const pile = game.tab[col];
    if (sel) {
      if (sel.from === 'tab' && sel.col === col && sel.idx === idx) {
        setSel(null);
        return;
      }
      const ng = tryMove(game, sel, { to: 'tab', col });
      if (ng) {
        apply(ng);
        return;
      }
    }
    if (idx >= 0 && pile[idx].up && isRun(pile.slice(idx))) {
      setSel({ from: 'tab', col, idx });
    } else {
      setSel(null);
    }
  };

  const autoFound = (s) => {
    const ng = tryMove(game, s, { to: 'found' });
    if (ng) apply(ng);
  };

  const isSel = (from, col, idx) =>
    !!sel &&
    sel.from === from &&
    (from === 'waste' ||
      (sel.col === col && (from === 'found' || idx >= sel.idx)));

  const boardWidth = 7 * CARD_W + 6 * GAP;
  const wasteTop = game.waste[game.waste.length - 1];

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          buttons={
            <>
              <Box inline mr={1}>
                Moves: {game.moves}
              </Box>
              <Button icon="redo" onClick={restart}>
                New game
              </Button>
            </>
          }
        >
          <Stack vertical align="center">
            <Stack.Item>
              <div
                style={{
                  position: 'relative',
                  width: boardWidth,
                  height: CARD_H,
                  marginBottom: 14,
                }}
              >
                {game.stock.length ? (
                  <CardView
                    card={game.stock[game.stock.length - 1]}
                    left={slotLeft(0)}
                    onClick={onStock}
                  />
                ) : (
                  <Slot left={slotLeft(0)} label="↺" onClick={onStock} />
                )}
                {wasteTop ? (
                  <CardView
                    card={wasteTop}
                    left={slotLeft(1)}
                    selected={isSel('waste')}
                    onClick={onWaste}
                    onDoubleClick={() => autoFound({ from: 'waste' })}
                  />
                ) : (
                  <Slot left={slotLeft(1)} label="" />
                )}
                {game.found.map((pile, s) => {
                  const top = pile[pile.length - 1];
                  const left = slotLeft(3 + s);
                  return top ? (
                    <CardView
                      key={s}
                      card={top}
                      left={left}
                      selected={isSel('found', s)}
                      onClick={() => onFound(s)}
                    />
                  ) : (
                    <Slot
                      key={s}
                      left={left}
                      label={SUITS[s]}
                      onClick={() => onFound(s)}
                    />
                  );
                })}
              </div>
            </Stack.Item>

            <Stack.Item>
              <div
                style={{ position: 'relative', width: boardWidth, height: 360 }}
              >
                {game.tab.map((pile, col) => {
                  let y = 0;
                  const left = slotLeft(col);
                  return (
                    <div key={col}>
                      <Slot
                        left={left}
                        label=""
                        onClick={() => onTab(col, -1)}
                      />
                      {pile.map((card, idx) => {
                        const top = y;
                        y += card.up ? UP_OFFSET : DOWN_OFFSET;
                        return (
                          <CardView
                            key={`${card.suit}-${card.rank}`}
                            card={card}
                            left={left}
                            top={top}
                            selected={isSel('tab', col, idx)}
                            onClick={() => onTab(col, idx)}
                            onDoubleClick={() =>
                              idx === pile.length - 1 &&
                              autoFound({ from: 'tab', col, idx })
                            }
                          />
                        );
                      })}
                    </div>
                  );
                })}
              </div>
            </Stack.Item>

            {won && (
              <Stack.Item>
                <Box bold color="good">
                  You win! ({game.moves} moves)
                </Box>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
