import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { BooleanLike } from 'tgui-core/react';
import { Box, Button, Divider, DmIcon, Icon, Input, NumberInput, Section, Stack, Tooltip } from 'tgui-core/components';
import { Window } from '../layouts';

type DisciplineInfo = {
  name: string;
  desc: string;
  max_level: number;
  rarity: 'rare' | 'common';
  icon?: string;
  icon_state?: string;
};

type DisciplineValidation = {
  total: number;
  additional: number;
  additional_rare: number;
  valid: boolean;
  violations: string[];
};

type WhitelistDefinition = {
  name: string;
  description: string;
  category: 'splat' | 'access' | 'clan';
  is_default: boolean;
};

type Data = {
  target_ckey: string;
  selected_slot: number;
  not_found: boolean;
  is_trusted: boolean;
  character_slots: { slot: number; name: string }[];
  discipline_levels: Record<string, number>;
  clan_disciplines: string[];
  disciplines: Record<string, DisciplineInfo>;
  discipline_validation: DisciplineValidation | null;
  connected_ckeys: string[];
  invalid_ckeys: string[];
  trusted_ckeys: string[];
  is_editing_character: boolean;
  character_name: string | null;
  character_age: number | null;
  immortal_age: number | null;
  max_immortal_age: number | null;
  clan_name: string | null;
  generation: number | null;
  admin_generation_floor: number | null;
  player_min_generation: number | null;
  lowest_generation_limit: number;
  highest_generation_limit: number;
  // CORVAX EDIT START - generation locks
  generation_locked: BooleanLike;
  diablerist_locked: BooleanLike;
  admin_generation_lock_round: BooleanLike;
  admin_generation_lock_forever: BooleanLike;
  diablerie_locked: BooleanLike;
  diablerie_generation_locked: BooleanLike;
  // CORVAX EDIT END
  splat_name: string | null;
  flavor_text: string | null;
  headshot: string | null;
  player_whitelists: string[];
  whitelist_definitions: Record<string, WhitelistDefinition>;
};

type DisciplineCardProps = {
  path: string;
  discipline: DisciplineInfo;
  level: number;
  isOwned: boolean;
  isClanDiscipline: boolean;
  clanName: string | null;
  isAdditional: boolean;
  onDotClick: (position: number) => void;
  onRemove: (path: string) => void;
};

function DisciplineCard(props: DisciplineCardProps) {
  const { discipline, level, isOwned, isClanDiscipline, clanName, path, isAdditional, onDotClick, onRemove } = props;
  const isRare = discipline.rarity === 'rare';

  return (
    <Box
      style={{
        width: '25%',
        minWidth: '130px',
        padding: '6px',
        boxSizing: 'border-box',
      }}
    >

      <Section style={{ height: '100%', position: 'relative' }}>
        {!!isOwned && (
          <Icon
            name="times"
            color="red"
            style={{
              position: 'absolute',
              top: '4px',
              left: '4px',
              cursor: 'pointer',
              zIndex: 1,
            }}
            onClick={() => onRemove(path)}
          />
        )}

        <Stack vertical align="center">
          {discipline.icon && discipline.icon_state && (
            <Stack.Item>
              <DmIcon
                icon={discipline.icon}
                icon_state={discipline.icon_state}
                height="96px"
                width="96px"
              />
            </Stack.Item>
          )}
          <Stack.Item>
            <Tooltip
              content={
                <>
                  {isClanDiscipline && clanName && (
                    <Box color="gold" textAlign="center">
                      ({clanName} Clan Discipline)
                    </Box>
                  )}
                  <Box color={isRare ? 'red' : 'label'} textAlign="center">
                    {isRare ? 'Rare Discipline' : 'Common Discipline'}
                  </Box>
                  {discipline.desc}
                </>
              }
            >
              <Box bold textAlign="center">
                {discipline.name}
                {!!isClanDiscipline && (
                  <Box inline color="gold" ml={0.5}>
                    <Icon name="users-rectangle" />
                  </Box>
                )}
              </Box>
            </Tooltip>
          </Stack.Item>
          <Stack.Item>
            <Box textAlign="center" fontSize="0.9em">
              {!isAdditional && (
                <Box inline color="gold" mr={0.5}>
                  Clan
                </Box>
              )}
              <Box inline color={isRare ? 'red' : 'label'}>
                {isRare ? 'Rare' : 'Common'}
              </Box>
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Stack justify="center" wrap>
              {Array.from({ length: discipline.max_level }, (_, i) => {
                const position = i + 1;
                const filled = position <= level;
                return (
                  <Stack.Item key={i}>
                    <Icon
                      name="circle"
                      color={filled ? 'white' : 'rgba(255,255,255,0.18)'}
                      onClick={() => onDotClick(position)}
                      style={{ cursor: 'pointer', fontSize: '11px', margin: '0 1px' }}
                    />
                  </Stack.Item>
                );
              })}
            </Stack>
          </Stack.Item>
        </Stack>
      </Section>
    </Box>
  );
}

const WHITELIST_CATEGORY_LABELS: Record<string, string> = {
  splat: 'Splat Access',
  access: 'Access Level',
  clan: 'Clan Access',
};

function WhitelistSection(props: {
  playerWhitelists: string[];
  whitelistDefinitions: Record<string, WhitelistDefinition>;
  onToggle: (id: string, currentlyHas: boolean) => void;
}) {
  const { playerWhitelists, whitelistDefinitions, onToggle } = props;
  const whitelistSet = new Set(playerWhitelists);
  const categories = ['splat', 'access', 'clan'] as const;

  return (
    <Section title="Whitelists">
      <Stack vertical>
        {categories.map((category) => {
          const entries = Object.entries(whitelistDefinitions).filter(
            ([, wl]) => wl.category === category,
          );
          if (!entries.length) return null;
          return (
            <Stack.Item key={category}>
              <Box color="label" bold mb={0.5}>
                {WHITELIST_CATEGORY_LABELS[category]}
              </Box>
              <Stack wrap>
                {entries.map(([id, wl]) => {
                  const has = whitelistSet.has(id);
                  return (
                    <Stack.Item key={id}>
                      <Tooltip content={wl.description}>
                        <Button
                          color={has ? 'green' : 'transparent'}
                          icon={has ? 'check-square' : 'square'}
                          onClick={() => onToggle(id, has)}
                        >
                          {wl.name}
                          {!!wl.is_default && (
                            <Box inline color={has ? 'rgba(255,255,255,0.6)' : 'label'} ml={0.5} fontSize="0.8em">
                              (default)
                            </Box>
                          )}
                        </Button>
                      </Tooltip>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
}

/**
 * CORVAX EDIT ADD START
 */
function GenerationLocksSection(props: {
  generation: number;
  adminGenerationFloor: number | null;
  adminGenerationLockRound: BooleanLike;
  adminGenerationLockForever: BooleanLike;
  diablerieLocked: BooleanLike;
  diablerieGenerationLocked: BooleanLike;
  onAct: (action: string, params?: Record<string, unknown>) => void;
}) {
  const {
    generation,
    adminGenerationFloor,
    adminGenerationLockRound,
    adminGenerationLockForever,
    diablerieLocked,
    diablerieGenerationLocked,
    onAct,
  } = props;

  return (
    <Section title="Generation Locks">
      <Stack vertical>
        <Stack.Item>
          <Box color="label" inline>Floor:</Box>
          {adminGenerationFloor === null ? (
            <>
              <Box inline bold ml={0.5}>none</Box>
              <Button
                ml={1}
                icon="lock-open"
                onClick={() => onAct('set_generation_floor', { floor: generation })}
              >
                Set floor = {generation}
              </Button>
            </>
          ) : (
            <>
              <Box inline bold ml={0.5} color="green">{adminGenerationFloor}</Box>
              <Button
                ml={1}
                color="red"
                icon="times"
                onClick={() => onAct('clear_generation_floor')}
              >
                Clear floor
              </Button>
            </>
          )}
        </Stack.Item>

        {/* Round lock */}
        <Stack.Item>
          {!!adminGenerationLockRound ? (
            <>
              <Box inline color="red"><Icon name="lock" mr={0.5} />Round lock active</Box>
              <Button
                ml={1}
                icon="lock-open"
                onClick={() => onAct('unlock_generation_round')}
              >
                Unlock round
              </Button>
            </>
          ) : (
            <Button icon="lock" onClick={() => onAct('lock_generation_round')}>
              Lock round
            </Button>
          )}
        </Stack.Item>

        {/* Forever lock */}
        <Stack.Item>
          {!!adminGenerationLockForever ? (
            <>
              <Box inline color="red"><Icon name="lock" mr={0.5} />Forever lock active</Box>
              <Button
                ml={1}
                color="red"
                icon="times"
                onClick={() => onAct('unlock_generation_forever')}
              >
                Remove forever lock
              </Button>
            </>
          ) : (
            <Button color="orange" icon="lock" onClick={() => onAct('lock_generation_forever')}>
              Lock forever
            </Button>
          )}
        </Stack.Item>

        {/* Diablerie locks */}
        {!!diablerieLocked && (
          <Stack.Item>
            <Box inline color="red"><Icon name="skull" mr={0.5} />Diablerie toggle locked</Box>
            <Button
              ml={1}
              icon="lock-open"
              onClick={() => onAct('unlock_diablerie_toggle')}
            >
              Unlock toggle
            </Button>
          </Stack.Item>
        )}
        {!!diablerieGenerationLocked && (
          <Stack.Item>
            <Box inline color="red"><Icon name="skull" mr={0.5} />Diablerie generation locked</Box>
            <Button
              ml={1}
              icon="lock-open"
              onClick={() => onAct('unlock_diablerie_generation')}
            >
              Unlock generation
            </Button>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
}
// CORVAX EDIT ADD END

export function AdminPreferenceEditor() {
  const { act, data } = useBackend<Data>();
  const {
    target_ckey,
    selected_slot,
    not_found,
    is_trusted,
    character_slots,
    discipline_levels,
    clan_disciplines,
    disciplines,
    discipline_validation,
    connected_ckeys,
    invalid_ckeys,
    trusted_ckeys,
    is_editing_character,
    character_name,
    character_age,
    immortal_age,
    max_immortal_age,
    clan_name,
    splat_name,
    generation,
    admin_generation_floor,
    player_min_generation,
    lowest_generation_limit,
    highest_generation_limit,
    // CORVAX EDIT START - generation locks
    generation_locked,
    diablerist_locked,
    admin_generation_lock_round,
    admin_generation_lock_forever,
    diablerie_locked,
    diablerie_generation_locked,
    // CORVAX EDIT END
    flavor_text,
    headshot,
    player_whitelists,
    whitelist_definitions,
  } = data;

  const [ckeyInput, setCkeyInput] = useState('');
  const clanSet = new Set(clan_disciplines || []);
  const allDisciplines = disciplines || {};
  const levels = discipline_levels || {};
  const connected = connected_ckeys || [];
  const invalidSet = new Set(invalid_ckeys || []);
  const trustedSet = new Set(trusted_ckeys || []);

  const handleDotClick = (path: string, position: number, currentLevel: number) => {
    const newLevel = position <= currentLevel ? (position === 1 ? 0 : position) : position;
    act('set_discipline_level', { discipline: path, level: newLevel });
  };

  const handleRemove = (path: string) => {
    act('set_discipline_level', { discipline: path, level: 0 });
  };

  const handleWhitelistToggle = (id: string, currentlyHas: boolean) => {
    act('set_whitelist', { id, grant: currentlyHas ? 0 : 1 });
  };

  const disciplineEntries = Object.entries(allDisciplines);
  const isGenerationLocked = !!admin_generation_floor; // CORVAX EDIT ADD

  return (
    <Window title="Preference Editor" width={1100} height={850}>
      <Window.Content>
        <Stack fill>
          <Stack.Item
            style={{
              width: '180px',
              minWidth: '180px',
              borderRight: '1px solid rgba(255,255,255,0.1)',
              display: 'flex',
              flexDirection: 'column',
            }}
          >
            <Section title={`Online (${connected.length})`} fill scrollable>
              {connected.length === 0 && <Box color="label" italic>No players online.</Box>}
              {connected.map((ckey) => (
                <Box key={ckey} mb={0.5}>
                  <Button
                    fluid
                    selected={target_ckey === ckey}
                    onClick={() => act('search_ckey', { ckey })}
                    style={{ textAlign: 'left' }}
                  >
                    {trustedSet.has(ckey) && <Icon name="shield-halved" color="green" mr={0.5} />}
                    {invalidSet.has(ckey) && <Icon name="triangle-exclamation" color="red" mr={0.5} />}
                    {ckey}
                  </Button>
                </Box>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item grow style={{ overflowY: 'auto' }}>
            <Section title="Search">
              <Stack>
                <Stack.Item grow>
                  <Input
                    fluid
                    placeholder="Enter ckey..."
                    value={ckeyInput}
                    onChange={(value) => setCkeyInput(value)}
                    onEnter={() => act('search_ckey', { ckey: ckeyInput })}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="search"
                    onClick={() => act('search_ckey', { ckey: ckeyInput })}
                  >
                    Search
                  </Button>
                </Stack.Item>
              </Stack>
              {!!not_found && (
                <Box color="red" mt={1}>
                  No player found for ckey "{target_ckey}".
                </Box>
              )}
            </Section>

            {target_ckey && !not_found && (
              <WhitelistSection
                playerWhitelists={player_whitelists || []}
                whitelistDefinitions={whitelist_definitions || {}}
                onToggle={handleWhitelistToggle}
              />
            )}

            {target_ckey && !not_found && character_slots.length > 0 && (
              <Section title={`${target_ckey}'s character slots`}>
                <Stack>
                  {character_slots.map(({ slot, name }) => (
                    <Stack.Item key={slot}>
                      <Button
                        selected={selected_slot === slot}
                        disabled={is_editing_character}
                        onClick={() => act('select_slot', { slot })}
                      >
                        {name}
                      </Button>
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            )}
            {selected_slot > 0 && character_name && (
              <>
                <Section>
                  <Stack align="flex-start">
                    <Stack.Item grow>
                      <Box bold fontSize={1.2} mb={0.5}>{character_name}</Box>
                      <Stack wrap>
                        <Stack.Item>
                          <Box color="label" inline>Living Age:</Box>
                          <Box inline bold ml={0.5}>{character_age}</Box>
                        </Stack.Item>
                        <Stack.Item ml={2}>
                          <Box color="label" inline>Immortal Age:</Box>
                          <Box inline bold ml={0.5}>{immortal_age}</Box>
                        {/* CORVAX EDIT START */}
                          {max_immortal_age !== null && (
                            <Box inline color="label" ml={1} fontSize="0.85em">
                              (max by generation: {max_immortal_age})
                            </Box>
                          )}
                        {/* CORVAX EDIT END */}
                        </Stack.Item>
                        <Stack.Item ml={2}>
                          <Box color="label" inline>Clan:</Box>
                          <Box inline bold ml={0.5} color="gold">{clan_name}</Box>
                        </Stack.Item>
                        <Stack.Item ml={2}>
                          <Box color="label" inline>Splat:</Box>
                          <Box inline bold ml={0.5}>{splat_name}</Box>
                        </Stack.Item>
                        {/* CORVAX EDIT START */}
                        {generation !== null && (
                          <Stack.Item ml={2}>
                            <Box color="label" inline>
                              Generation:
                            </Box>
                            <NumberInput
                              ml={0.5}
                              inline
                              step={1}
                              minValue={lowest_generation_limit}
                              maxValue={highest_generation_limit}
                              value={generation}
                              disabled={!!generation_locked}
                              onChange={(value: number) =>
                                act('set_generation', { generation: value })
                              }
                            />
                            {!!generation_locked && (
                              <Box inline ml={1} color="red">
                                <Icon name="lock" mr={0.5} />
                                Locked
                              </Box>
                            )}
                            {!generation_locked && player_min_generation !== null && (
                              <Box inline ml={1} color="label" fontSize="0.85em">
                                (player min: {player_min_generation})
                              </Box>
                            )}
                          </Stack.Item>
                        )}
                        {/* CORVAX EDIT END */}
                      </Stack>
                      {flavor_text && (
                        <Box color="label" mt={1} italic fontSize="0.9em">
                          {flavor_text}
                        </Box>
                      )}
                    </Stack.Item>
                    <Stack.Item>
                      <Box style={{ width: '60px', height: '60px', backgroundColor: 'rgba(0,0,0,0.3)' }}>
                        {headshot && <img src={headshot} style={{ width: '60px', height: '60px', objectFit: 'cover' }} />}
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Section>

                {/* CORVAX EDIT ADD START - generation locks panel */}
                {generation !== null && (
                  <GenerationLocksSection
                    generation={generation}
                    adminGenerationFloor={admin_generation_floor}
                    adminGenerationLockRound={admin_generation_lock_round}
                    adminGenerationLockForever={admin_generation_lock_forever}
                    diablerieLocked={diablerie_locked}
                    diablerieGenerationLocked={diablerie_generation_locked}
                    onAct={(action, params) => act(action, params)}
                  />
                )}
                {/* CORVAX EDIT ADD END */}

                <Divider />
                {is_editing_character ? (
                  <Section>
                    <Stack vertical align="center" py={4}>
                      <Stack.Item>
                        <Icon name="spinner" spin size={3} color="red" />
                      </Stack.Item>
                      <Stack.Item>
                        <Box bold fontSize="1.2em" color="red">
                          CHARACTER IS BEING EDITED
                        </Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Box italic color="label">
                          <center>For safety, you cannot make changes to {target_ckey}'s sheet while they have the character setup menu open. <br />
                          You should probably ask {target_ckey} to spawn in, just to be safe.</center>
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Section>
                ) : (
                  <>
                    {discipline_validation && (
                      <Section>
                        <Stack align="center" wrap>
                          <Stack.Item>
                            <Box color="label" inline>Total disciplines:</Box>
                            <Box inline bold ml={0.5} color={discipline_validation.total > 5 ? 'red' : 'white'}>
                              {discipline_validation.total} / 5
                            </Box>
                          </Stack.Item>
                          <Stack.Item ml={2}>
                            <Box color="label" inline>Non-Clan Rares:</Box>
                            <Box inline bold ml={0.5} color={discipline_validation.additional_rare >= 2 ? 'red' : 'white'}>
                              {discipline_validation.additional_rare}
                            </Box>
                          </Stack.Item>
                          <Stack.Item ml={2}>
                            {is_trusted ? (
                              <Box inline color="green">
                                <Icon name="shield-halved" mr={0.5} />Trusted
                              </Box>
                            ) : (
                              <>
                                <Box inline color="label">
                                  <Icon name="shield" mr={0.5} />Untrusted
                                </Box>
                                <Box inline ml={1}>
                                  {discipline_validation.valid ? (
                                    <Box color="green"><Icon name="check" mr={0.5} /> In compliance</Box>
                                  ) : (
                                    <Tooltip content={discipline_validation.violations.join('\n')}>
                                      <Box color="red" style={{ cursor: 'help' }}>
                                        <Icon name="triangle-exclamation" mr={0.5} /> Invalid Configuration
                                      </Box>
                                    </Tooltip>
                                  )}
                                </Box>
                              </>
                            )}
                          </Stack.Item>
                        </Stack>
                      </Section>
                    )}
                    {splat_name === 'Human' ? (
                      <Box color="label" textAlign="center" mt={4}>
                        This character cannot be assigned disciplines or gifts.
                      </Box>
                    ) : (
                      <Box style={{ display: 'flex', flexWrap: 'wrap', padding: '4px' }}>
                        {disciplineEntries.map(([path, discipline]) => {
                          const level = levels[path] ?? 0;
                          const isOwned = path in levels;
                          return (
                            <DisciplineCard
                              key={path}
                              path={path}
                              discipline={discipline}
                              level={level}
                              isOwned={isOwned}
                              isClanDiscipline={clanSet.has(path)}
                              clanName={clan_name}
                              isAdditional={!clanSet.has(path)}
                              onDotClick={(position) => handleDotClick(path, position, level)}
                              onRemove={handleRemove}
                            />
                          );
                        })}
                      </Box>
                    )}
                  </>
                )}
              </>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
