import { useState } from 'react';
import { useBackend } from 'tgui/backend';
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
  clan_name: string | null;
  generation: number | null;
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
        {isOwned && (
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
                {isClanDiscipline && (
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
    clan_name,
    splat_name,
    generation,
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
                        </Stack.Item>
                        <Stack.Item ml={2}>
                          <Box color="label" inline>Clan:</Box>
                          <Box inline bold ml={0.5} color="gold">{clan_name}</Box>
                        </Stack.Item>
                        <Stack.Item ml={2}>
                          <Box color="label" inline>Splat:</Box>
                          <Box inline bold ml={0.5}>{splat_name}</Box>
                        </Stack.Item>
                                              {generation !== null && (
                        <Stack.Item ml={2}>
                          <Box color="label" inline>
                            Generation:
                          </Box>
                          <NumberInput
                            ml={0.5}
                            inline
                            step={1}
                            minValue={1}
                            maxValue={16}
                            value={generation}
                            onChange={(value: number) =>
                              act('set_generation', { generation: value })
                            }
                          />
                        </Stack.Item>
                      )}
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
