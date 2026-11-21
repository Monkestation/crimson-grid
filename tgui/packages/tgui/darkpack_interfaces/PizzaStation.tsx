import { type MouseEvent, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Topping = {
  id: string;
  name: string;
  icon_state: string;
};

type Placed = {
  id: string;
  x: number;
  y: number;
};

type Order = {
  customer: string;
  description: string;
  seconds_left: number;
  score: number;
};

type Data = {
  toppings: Topping[];
  topping_icon: string;
  radius: number;
  max_toppings: number;
  has_pizza: boolean;
  pizza_name: string | null;
  pizza_icon: string | null;
  pizza_icon_state: string | null;
  stock: Record<string, number>;
  max_stock: number;
  placed: Placed[];
  orders: Order[];
  has_counter: boolean;
  counter_open: boolean;
};

const LOW_STOCK = 10;

const ICON_PX = 32;
const SCALE = 10;
const PIZZA_SIZE = ICON_PX * SCALE;

const SWATCH_SIZE = 40;
const SWATCH_SCALE = 5;

const scoreColor = (score: number) => {
  if (score >= 90) return 'good';
  if (score >= 60) return 'average';
  if (score >= 30) return 'bad';
  return 'grey';
};

type SpriteProps = {
  icon: string;
  icon_state: string;
  size: number;
  fallbackColor?: string;
};

const Sprite = (props: SpriteProps) => {
  const { icon, icon_state, size, fallbackColor = '#888' } = props;
  return (
    <DmIcon
      icon={icon}
      icon_state={icon_state}
      fallback={
        <Box
          style={{
            width: `${size / 4}px`,
            height: `${size / 4}px`,
            margin: 'auto',
            borderRadius: '50%',
            background: fallbackColor,
          }}
        />
      }
      style={{
        width: `${size}px`,
        height: `${size}px`,
        imageRendering: 'pixelated',
      }}
    />
  );
};

export const PizzaStation = () => {
  const { act, data } = useBackend<Data>();
  const {
    toppings = [],
    topping_icon,
    radius,
    max_toppings,
    has_pizza,
    pizza_name,
    pizza_icon,
    pizza_icon_state,
    stock = {},
    max_stock,
    placed = [],
    orders = [],
    has_counter,
    counter_open,
  } = data;

  const [selected, setSelected] = useState('');
  const [hover, setHover] = useState<{ x: number; y: number } | null>(null);

  const selectedId = selected || toppings[0]?.id;
  const selectedTopping = toppings.find((t) => t.id === selectedId);
  const toppingById = (id: string) => toppings.find((t) => t.id === id);
  const full = placed.length >= max_toppings;
  const outOfStock = !!selectedId && (stock[selectedId] ?? 0) <= 0;
  const canPlace = !full && !outOfStock;

  // The pizza box is the 32x32 sprite scaled up, so a click maps straight onto
  // the pixel offsets the game uses: (0, 0) is the center, +y is up.
  const toOffset = (e: MouseEvent<HTMLDivElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const col = Math.floor(((e.clientX - rect.left) / rect.width) * ICON_PX);
    const row = Math.floor(((e.clientY - rect.top) / rect.height) * ICON_PX);
    return {
      x: Math.max(-16, Math.min(16, col - 15)),
      y: Math.max(-16, Math.min(16, 16 - row)),
    };
  };

  // A topping overlay is a full 32x32 sprite shifted by its offset
  const overlayStyle = (x: number, y: number) => ({
    position: 'absolute' as const,
    left: `${x * SCALE}px`,
    top: `${-y * SCALE}px`,
    pointerEvents: 'none' as const,
  });

  return (
    <Window width={700} height={640} title="Pizza Station">
      <Window.Content>
        <Stack fill>
          <Stack.Item>
            <Section
              fill
              title={has_pizza ? 'Pizza' : 'No pizza'}
              buttons={
                <>
                  <Button
                    icon="undo"
                    disabled={!has_pizza || !placed.length}
                    onClick={() => act('undo')}
                  >
                    Undo
                  </Button>
                  <Button
                    icon="trash"
                    color="bad"
                    disabled={!has_pizza || !placed.length}
                    onClick={() => act('clear')}
                  >
                    Clear
                  </Button>
                  <Button
                    icon="eject"
                    disabled={!has_pizza}
                    onClick={() => act('eject')}
                  >
                    Take pizza
                  </Button>
                </>
              }
            >
              {!has_pizza || !pizza_icon || !pizza_icon_state ? (
                <Box
                  width={`${PIZZA_SIZE}px`}
                  height={`${PIZZA_SIZE}px`}
                  textAlign="center"
                  color="label"
                  style={{ lineHeight: `${PIZZA_SIZE}px` }}
                >
                  Slide a baked pizza onto the station.
                </Box>
              ) : (
                <Box
                  width={`${PIZZA_SIZE}px`}
                  height={`${PIZZA_SIZE}px`}
                  style={{
                    position: 'relative',
                    overflow: 'hidden',
                    borderRadius: '8px',
                    background: 'rgba(0, 0, 0, 0.35)',
                    cursor: canPlace ? 'crosshair' : 'not-allowed',
                  }}
                  onMouseMove={(e) => {
                    const next = toOffset(e);
                    setHover((prev) =>
                      prev && prev.x === next.x && prev.y === next.y
                        ? prev
                        : next,
                    );
                  }}
                  onMouseLeave={() => setHover(null)}
                  onClick={(e) => {
                    if (!selectedId || !canPlace) return;
                    const pos = toOffset(e);
                    act('place', { topping: selectedId, x: pos.x, y: pos.y });
                  }}
                >
                  <Box style={{ position: 'absolute', left: 0, top: 0 }}>
                    <Sprite
                      icon={pizza_icon}
                      icon_state={pizza_icon_state}
                      size={PIZZA_SIZE}
                    />
                  </Box>

                  <Box
                    style={{
                      position: 'absolute',
                      left: '50%',
                      top: 0,
                      bottom: 0,
                      borderLeft: '2px dashed rgba(255, 255, 255, 0.3)',
                      pointerEvents: 'none',
                    }}
                  />

                  {/* Placed toppings, drawn exactly like the in-game overlays */}
                  {placed.map((p, i) => {
                    const topping = toppingById(p.id);
                    if (!topping) return null;
                    return (
                      <Box key={i} style={overlayStyle(p.x, p.y)}>
                        <Sprite
                          icon={topping_icon}
                          icon_state={topping.icon_state}
                          size={PIZZA_SIZE}
                        />
                      </Box>
                    );
                  })}

                  {!!hover && !!selectedTopping && canPlace && (
                    <Box
                      style={{
                        ...overlayStyle(hover.x, hover.y),
                        opacity: 0.5,
                      }}
                    >
                      <Sprite
                        icon={topping_icon}
                        icon_state={selectedTopping.icon_state}
                        size={PIZZA_SIZE}
                      />
                    </Box>
                  )}
                </Box>
              )}
              <Box
                mt={1}
                textAlign="center"
                color={outOfStock ? 'bad' : 'label'}
              >
                {outOfStock
                  ? `Out of ${selectedTopping?.name}, refill with a box of toppings`
                  : `${placed.length}/${max_toppings} toppings`}
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Stack fill vertical>
              <Stack.Item>
                <Section title="Toppings">
                  {toppings.map((topping) => (
                    <Button
                      key={topping.id}
                      fluid
                      selected={topping.id === selectedId}
                      onClick={() => setSelected(topping.id)}
                    >
                      <Box
                        inline
                        mr={1}
                        style={{
                          position: 'relative',
                          overflow: 'hidden',
                          width: `${SWATCH_SIZE}px`,
                          height: `${SWATCH_SIZE}px`,
                          verticalAlign: 'middle',
                        }}
                      >
                        <Box
                          style={{
                            position: 'absolute',
                            left: `${-(ICON_PX * SWATCH_SCALE - SWATCH_SIZE) / 2}px`,
                            top: `${-(ICON_PX * SWATCH_SCALE - SWATCH_SIZE) / 2}px`,
                          }}
                        >
                          <Sprite
                            icon={topping_icon}
                            icon_state={topping.icon_state}
                            size={ICON_PX * SWATCH_SCALE}
                          />
                        </Box>
                      </Box>
                      {topping.name}
                      <Box
                        inline
                        color={
                          (stock[topping.id] ?? 0) <= 0
                            ? 'bad'
                            : (stock[topping.id] ?? 0) < LOW_STOCK
                              ? 'average'
                              : 'label'
                        }
                        style={{
                          float: 'right',
                          lineHeight: `${SWATCH_SIZE}px`,
                        }}
                      >
                        {(stock[topping.id] ?? 0) <= 0
                          ? 'empty'
                          : `${stock[topping.id]}/${max_stock}`}
                      </Box>
                    </Button>
                  ))}
                </Section>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Section
                  fill
                  scrollable
                  title="Orders"
                  buttons={
                    <Button
                      icon={counter_open ? 'lock-open' : 'lock'}
                      color={counter_open ? 'good' : 'bad'}
                      disabled={!has_counter}
                      tooltip={
                        counter_open
                          ? 'Open. Click to stop taking new orders.'
                          : 'Closed. Click to start taking orders again.'
                      }
                      onClick={() => act('toggle_open')}
                    >
                      {counter_open ? 'Open' : 'Closed'}
                    </Button>
                  }
                >
                  {!orders.length && (
                    <Box color="label">
                      {has_counter && !counter_open
                        ? 'Closed to new customers.'
                        : 'Nobody is waiting for a pizza.'}
                    </Box>
                  )}
                  {orders.map((order, i) => (
                    <Box key={i} mb={2}>
                      <Box bold>{order.customer}</Box>
                      <Box>Wants {order.description}.</Box>
                      <Box color="label">{order.seconds_left}s left</Box>
                      <ProgressBar
                        mt={1}
                        value={order.score}
                        minValue={0}
                        maxValue={100}
                        color={scoreColor(order.score)}
                      >
                        {order.score}% match
                      </ProgressBar>
                    </Box>
                  ))}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
