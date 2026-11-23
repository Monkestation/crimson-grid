// THIS IS A DARKPACK UI FILE
import { useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

const STATE_IDLE = 0;
const STATE_COOKING = 1;
const STATE_DONE = 2;

type Data = {
  recipes: { id: string; name: string; desc: string }[];
  stage_names: string[];
  state: number;
  stage: number;
  stage_scores: number[];
  quality: number;
  instability: number;
  recipe_id: string;
  difficulty: number;
  slots: { label: string; have: number; need: number }[];
};

type GameProps = {
  difficulty: number;
  onDone: (score: number) => void;
};

const clamp = (n: number, lo = 0, hi = 100) => Math.max(lo, Math.min(hi, n));

const verdictFor = (score: number) =>
  score >= 90
    ? 'Perfect!'
    : score >= 70
      ? 'Great!'
      : score >= 45
        ? 'Okay.'
        : score > 0
          ? 'Sloppy...'
          : 'Failed.';

const verdictColor = (score: number) =>
  score >= 70 ? 'good' : score >= 45 ? 'average' : 'bad';

// ---------------------------------------------------------------------------------------------
// 1. POUR: hold to fill, release inside the band
// ---------------------------------------------------------------------------------------------
const PourGame = (props: GameProps) => {
  const { difficulty, onDone } = props;
  const [center] = useState(() => 55 + Math.random() * 30);
  const half = Math.max(4, 9 - difficulty * 1.5);
  const [fill, setFill] = useState(0);
  const fillRef = useRef(0);
  const holding = useRef(false);
  const finished = useRef(false);
  const doneCb = useRef(onDone);
  doneCb.current = onDone;

  const finish = () => {
    if (finished.current) return;
    finished.current = true;
    holding.current = false;
    const err = Math.abs(fillRef.current - center);
    doneCb.current(clamp(Math.round(100 - (err / (half * 5)) * 100)));
  };

  useEffect(() => {
    let raf = 0;
    let last = performance.now();
    const loop = (now: number) => {
      const dt = (now - last) / 1000;
      last = now;
      if (holding.current && !finished.current) {
        fillRef.current = Math.min(100, fillRef.current + 38 * dt);
        setFill(fillRef.current);
        if (fillRef.current >= 100) finish();
      }
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(raf);
  }, []);

  const release = () => {
    if (holding.current && fillRef.current > 0) finish();
    holding.current = false;
  };

  return (
    <Stack vertical>
      <Stack.Item color="label">
        Hold the button to pour. Let go when the level sits in the green band.
      </Stack.Item>
      <Stack.Item>
        <Box
          style={{
            position: 'relative',
            height: '3rem',
            background: '#1c1c1c',
            border: '1px solid #555',
            borderRadius: '6px',
            overflow: 'hidden',
          }}
        >
          <Box
            style={{
              position: 'absolute',
              left: `${center - half}%`,
              width: `${half * 2}%`,
              top: 0,
              bottom: 0,
              background: 'rgba(76, 175, 80, 0.45)',
            }}
          />
          <Box
            style={{
              position: 'absolute',
              left: 0,
              width: `${fill}%`,
              top: 0,
              bottom: 0,
              background: 'rgba(66, 165, 245, 0.8)',
            }}
          />
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box
          textAlign="center"
          bold
          p={2}
          style={{
            background: '#2a6fb0',
            borderRadius: '8px',
            cursor: 'pointer',
            userSelect: 'none',
          }}
          onMouseDown={() => {
            holding.current = true;
          }}
          onMouseUp={release}
          onMouseLeave={release}
        >
          <Icon name="droplet" mr={1} />
          HOLD TO POUR
        </Box>
      </Stack.Item>
    </Stack>
  );
};

// ---------------------------------------------------------------------------------------------
// 2. HEAT: stop the swinging marker on the centre, three times
// ---------------------------------------------------------------------------------------------
const HeatGame = (props: GameProps) => {
  const { difficulty, onDone } = props;
  const [pos, setPos] = useState(0);
  const posRef = useRef(0);
  const [results, setResults] = useState<number[]>([]);
  const resultsRef = useRef<number[]>([]);
  const doneCb = useRef(onDone);
  doneCb.current = onDone;
  const speed = 1.1 + difficulty * 0.35;

  useEffect(() => {
    let raf = 0;
    const start = performance.now();
    const loop = (now: number) => {
      const t = (now - start) / 1000;
      posRef.current = 50 + 50 * Math.sin(t * speed * 2);
      setPos(posRef.current);
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(raf);
  }, []);

  const stop = () => {
    if (resultsRef.current.length >= 3) return;
    const score = clamp(Math.round(100 - Math.abs(posRef.current - 50) * 2.2));
    resultsRef.current = [...resultsRef.current, score];
    setResults(resultsRef.current);
    if (resultsRef.current.length >= 3) {
      const avg = resultsRef.current.reduce((a, b) => a + b, 0) / 3;
      setTimeout(() => doneCb.current(Math.round(avg)), 700);
    }
  };

  return (
    <Stack vertical>
      <Stack.Item color="label">
        Hit STOP when the marker crosses the middle. Three tries.
      </Stack.Item>
      <Stack.Item>
        <Box
          style={{
            position: 'relative',
            height: '3rem',
            background: '#1c1c1c',
            border: '1px solid #555',
            borderRadius: '6px',
            overflow: 'hidden',
          }}
        >
          <Box
            style={{
              position: 'absolute',
              left: '42%',
              width: '16%',
              top: 0,
              bottom: 0,
              background: 'rgba(76, 175, 80, 0.45)',
            }}
          />
          <Box
            style={{
              position: 'absolute',
              left: `calc(${pos}% - 3px)`,
              width: '6px',
              top: 0,
              bottom: 0,
              background: '#ff9800',
            }}
          />
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          icon="hand"
          color="orange"
          textAlign="center"
          disabled={results.length >= 3}
          onClick={stop}
        >
          STOP ({results.length}/3)
        </Button>
      </Stack.Item>
      <Stack.Item>
        {results.map((score, i) => (
          <Box inline key={i} mr={2} color={verdictColor(score)}>
            #{i + 1}: {score}
          </Box>
        ))}
      </Stack.Item>
    </Stack>
  );
};

// ---------------------------------------------------------------------------------------------
// 3. STIR: mash the button for five seconds
// ---------------------------------------------------------------------------------------------
const StirGame = (props: GameProps) => {
  const { difficulty, onDone } = props;
  const target = 28 + difficulty * 6;
  const [clicks, setClicks] = useState(0);
  const clicksRef = useRef(0);
  const [timeLeft, setTimeLeft] = useState(5);
  const startedAt = useRef(0);
  const finished = useRef(false);
  const doneCb = useRef(onDone);
  doneCb.current = onDone;

  useEffect(() => {
    const timer = setInterval(() => {
      if (!startedAt.current || finished.current) return;
      const left = 5 - (performance.now() - startedAt.current) / 1000;
      setTimeLeft(Math.max(left, 0));
      if (left <= 0) {
        finished.current = true;
        doneCb.current(clamp(Math.round((clicksRef.current / target) * 100)));
      }
    }, 100);
    return () => clearInterval(timer);
  }, []);

  const stir = () => {
    if (finished.current) return;
    if (!startedAt.current) startedAt.current = performance.now();
    clicksRef.current += 1;
    setClicks(clicksRef.current);
  };

  return (
    <Stack vertical>
      <Stack.Item color="label">
        Mash STIR as fast as you can. The timer starts on your first click.
      </Stack.Item>
      <Stack.Item>
        <ProgressBar
          value={clicks / target}
          ranges={{
            bad: [0, 0.4],
            average: [0.4, 0.8],
            good: [0.8, Infinity],
          }}
        >
          {clicks} / {target}
        </ProgressBar>
      </Stack.Item>
      <Stack.Item textAlign="center" color="label">
        {startedAt.current ? `${timeLeft.toFixed(1)}s left` : 'Waiting...'}
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          color="green"
          textAlign="center"
          fontSize="1.6em"
          py={2}
          onClick={stir}
        >
          <Icon
            name="rotate"
            mr={1}
            style={{ transform: `rotate(${clicks * 40}deg)` }}
          />
          STIR!
        </Button>
      </Stack.Item>
    </Stack>
  );
};

// ---------------------------------------------------------------------------------------------
// 4. FILTER: follow the arrow prompts in order
// ---------------------------------------------------------------------------------------------
const DIRS = ['up', 'down', 'left', 'right'] as const;
type Dir = (typeof DIRS)[number];
const SEQ_LENGTH = 7;

const FilterGame = (props: GameProps) => {
  const { difficulty, onDone } = props;
  const [seq] = useState<Dir[]>(() =>
    Array.from(
      { length: SEQ_LENGTH },
      () => DIRS[Math.floor(Math.random() * DIRS.length)],
    ),
  );
  const [index, setIndex] = useState(0);
  const indexRef = useRef(0);
  const mistakes = useRef(0);
  const [mistakeCount, setMistakeCount] = useState(0);
  const [timeLeft, setTimeLeft] = useState(12 - difficulty);
  const finished = useRef(false);
  const doneCb = useRef(onDone);
  doneCb.current = onDone;
  const startedAt = useRef(performance.now());
  const limit = 12 - difficulty;

  const finish = () => {
    if (finished.current) return;
    finished.current = true;
    const score = clamp(
      Math.round((indexRef.current / SEQ_LENGTH) * 100 - mistakes.current * 8),
    );
    doneCb.current(score);
  };

  const press = (dir: Dir) => {
    if (finished.current) return;
    if (dir === seq[indexRef.current]) {
      indexRef.current += 1;
      setIndex(indexRef.current);
      if (indexRef.current >= SEQ_LENGTH) finish();
    } else {
      mistakes.current += 1;
      setMistakeCount(mistakes.current);
    }
  };

  useEffect(() => {
    const timer = setInterval(() => {
      const left = limit - (performance.now() - startedAt.current) / 1000;
      setTimeLeft(Math.max(left, 0));
      if (left <= 0) finish();
    }, 100);
    const onKey = (e: KeyboardEvent) => {
      const map: Record<string, Dir> = {
        ArrowUp: 'up',
        ArrowDown: 'down',
        ArrowLeft: 'left',
        ArrowRight: 'right',
      };
      if (map[e.key]) {
        e.preventDefault();
        press(map[e.key]);
      }
    };
    window.addEventListener('keydown', onKey);
    return () => {
      clearInterval(timer);
      window.removeEventListener('keydown', onKey);
    };
  }, []);

  return (
    <Stack vertical>
      <Stack.Item color="label">
        Match each arrow in order, with the buttons or your arrow keys.
      </Stack.Item>
      <Stack.Item textAlign="center">
        {seq.map((dir, i) => (
          <Icon
            key={i}
            name={`arrow-${dir}`}
            size={2}
            mx={0.5}
            color={i < index ? 'good' : i === index ? 'white' : 'grey'}
            style={{ opacity: i === index ? 1 : 0.7 }}
          />
        ))}
      </Stack.Item>
      <Stack.Item textAlign="center" color="label">
        {timeLeft.toFixed(1)}s left | mistakes: {mistakeCount}
      </Stack.Item>
      <Stack.Item>
        <Stack vertical align="center">
          <Stack.Item>
            <Button icon="arrow-up" onClick={() => press('up')} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="arrow-left" mr={1} onClick={() => press('left')} />
            <Button icon="arrow-down" mr={1} onClick={() => press('down')} />
            <Button icon="arrow-right" onClick={() => press('right')} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

// ---------------------------------------------------------------------------------------------
// 5. CRUSH: whack the lit cells before they fade
// ---------------------------------------------------------------------------------------------
const SPAWNS = 12;

const CrushGame = (props: GameProps) => {
  const { difficulty, onDone } = props;
  const [active, setActive] = useState<number | null>(null);
  const activeRef = useRef<number | null>(null);
  const spawned = useRef(0);
  const hits = useRef(0);
  const [hitCount, setHitCount] = useState(0);
  const finished = useRef(false);
  const doneCb = useRef(onDone);
  doneCb.current = onDone;
  const interval = Math.max(500, 850 - difficulty * 60);

  useEffect(() => {
    const timer = setInterval(() => {
      if (finished.current) return;
      if (spawned.current >= SPAWNS) {
        finished.current = true;
        doneCb.current(clamp(Math.round((hits.current / SPAWNS) * 100)));
        return;
      }
      spawned.current += 1;
      const next = Math.floor(Math.random() * 9);
      activeRef.current = next;
      setActive(next);
    }, interval);
    return () => clearInterval(timer);
  }, []);

  const whack = (cell: number) => {
    if (finished.current || activeRef.current !== cell) return;
    activeRef.current = null;
    setActive(null);
    hits.current += 1;
    setHitCount(hits.current);
  };

  return (
    <Stack vertical>
      <Stack.Item color="label">
        Crush the glowing cells before they fade. Hits: {hitCount}/{SPAWNS}
      </Stack.Item>
      <Stack.Item>
        <Box
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(3, 1fr)',
            gap: '8px',
          }}
        >
          {Array.from({ length: 9 }, (_, cell) => (
            <Box
              key={cell}
              onMouseDown={() => whack(cell)}
              style={{
                height: '4.5rem',
                borderRadius: '8px',
                cursor: 'pointer',
                userSelect: 'none',
                background: active === cell ? '#ffb300' : '#2a2a2a',
                boxShadow: active === cell ? '0 0 12px #ffb300' : 'none',
                border: '1px solid #555',
              }}
            />
          ))}
        </Box>
      </Stack.Item>
    </Stack>
  );
};

const GAMES = [PourGame, HeatGame, StirGame, FilterGame, CrushGame];

const GAME_BLURBS = [
  'Pour the base to the line.',
  'Bring it up to temperature.',
  'Keep it moving.',
  'Strain out the impurities.',
  'Break it down.',
];

// ---------------------------------------------------------------------------------------------
// Views
// ---------------------------------------------------------------------------------------------

const Ingredient = (props: {
  label: string;
  done: boolean;
  detail?: string;
}) => (
  <Stack.Item>
    <Icon
      name={props.done ? 'check-circle' : 'circle'}
      color={props.done ? 'good' : 'grey'}
      mr={1}
    />
    {props.label}
    {props.detail && (
      <Box inline ml={1} color="label">
        {props.detail}
      </Box>
    )}
  </Stack.Item>
);

const IdleView = () => {
  const { act, data } = useBackend<Data>();
  const nothingLoaded = data.slots.every((slot) => slot.have === 0);
  const selected = data.recipes.find((r) => r.id === data.recipe_id);
  return (
    <Stack vertical>
      <Stack.Item>
        <Section title="Recipe">
          <Stack wrap>
            {data.recipes.map((r) => (
              <Stack.Item grow key={r.id} mb={0.5}>
                <Button
                  fluid
                  textAlign="center"
                  selected={r.id === data.recipe_id}
                  disabled={!nothingLoaded && r.id !== data.recipe_id}
                  onClick={() => act('select_recipe', { id: r.id })}
                >
                  {r.name}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
          {selected && (
            <Box color="label" mt={1}>
              {selected.desc}
            </Box>
          )}
          {!nothingLoaded && (
            <Box color="label" fontSize="0.85em" mt={0.5}>
              The recipe is locked once ingredients are in.
            </Box>
          )}
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Load the lab">
          <Box color="label" mb={1}>
            Use each ingredient on the lab. Once everything is in, you can start
            cooking. Mind the order.
          </Box>
          <Stack vertical>
            {data.slots.map((slot) => (
              <Ingredient
                key={slot.label}
                label={slot.label}
                done={slot.have >= slot.need}
                detail={`${slot.have}/${slot.need}`}
              />
            ))}
          </Stack>
          {data.instability > 0 && (
            <NoticeBox warning mt={1}>
              Something went in out of order. The cook will be harder.
            </NoticeBox>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const StageTracker = () => {
  const { data } = useBackend<Data>();
  return (
    <Stack mb={1}>
      {data.stage_names.map((name, i) => {
        const score = data.stage_scores[i];
        const current = i + 1 === data.stage;
        return (
          <Stack.Item grow basis={0} key={name} textAlign="center">
            <Box
              p={0.5}
              style={{
                borderRadius: '6px',
                border: current ? '1px solid #fff' : '1px solid transparent',
                opacity: score === undefined && !current ? 0.5 : 1,
              }}
            >
              <Box fontSize="0.8em">{name}</Box>
              <Box
                bold
                color={score === undefined ? 'grey' : verdictColor(score)}
              >
                {score === undefined ? '-' : score}
              </Box>
            </Box>
          </Stack.Item>
        );
      })}
    </Stack>
  );
};

const CookView = () => {
  const { act, data } = useBackend<Data>();
  const [playing, setPlaying] = useState(false);

  // A new stage always starts at the "ready" screen
  useEffect(() => {
    setPlaying(false);
  }, [data.stage]);

  const Game = GAMES[data.stage - 1];
  const lastScore = data.stage_scores[data.stage_scores.length - 1];

  return (
    <Stack vertical>
      <Stack.Item>
        <StageTracker />
      </Stack.Item>
      <Stack.Item>
        <Section
          title={`Step ${data.stage}/${data.stage_names.length}: ${
            data.stage_names[data.stage - 1]
          }`}
        >
          {playing && Game ? (
            <Game
              key={data.stage}
              difficulty={data.difficulty}
              onDone={(score) => {
                act('stage_done', { score });
              }}
            />
          ) : (
            <Stack vertical>
              {lastScore !== undefined && (
                <Stack.Item
                  textAlign="center"
                  bold
                  fontSize="1.4em"
                  color={verdictColor(lastScore)}
                >
                  {verdictFor(lastScore)} ({lastScore})
                </Stack.Item>
              )}
              <Stack.Item textAlign="center" color="label">
                {GAME_BLURBS[data.stage - 1]}
              </Stack.Item>
              {data.instability > 0 && (
                <Stack.Item textAlign="center" color="orange">
                  <Icon name="triangle-exclamation" mr={1} />
                  Unstable mixture: this is going to be harder.
                </Stack.Item>
              )}
              <Stack.Item>
                <Button
                  fluid
                  icon="play"
                  color="green"
                  textAlign="center"
                  onClick={() => {
                    act('begin_stage');
                    setPlaying(true);
                  }}
                >
                  Start
                </Button>
              </Stack.Item>
            </Stack>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const DoneView = () => {
  const { act, data } = useBackend<Data>();
  const { quality } = data;
  return (
    <Stack vertical>
      <Stack.Item>
        <StageTracker />
      </Stack.Item>
      <Stack.Item>
        <Section title="Batch complete">
          <ProgressBar
            value={quality / 100}
            ranges={{
              bad: [0, 0.3],
              average: [0.3, 0.6],
              good: [0.6, 1],
            }}
          >
            {quality}% pure
          </ProgressBar>
          <Box textAlign="center" mt={1} mb={1} color="label">
            {quality >= 90
              ? 'Flawless.'
              : quality >= 60
                ? 'Decent batch.'
                : quality >= 30
                  ? 'Cloudy. Buyers will notice.'
                  : 'Garbage.'}
          </Box>
          <Button
            fluid
            icon="hand-holding"
            color="green"
            textAlign="center"
            onClick={() => act('collect')}
          >
            Collect
          </Button>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const MethLab = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={420} height={520} title="Chemical Laboratory">
      <Window.Content scrollable>
        {data.state === STATE_IDLE && <IdleView />}
        {data.state === STATE_COOKING && <CookView />}
        {data.state === STATE_DONE && <DoneView />}
      </Window.Content>
    </Window>
  );
};
