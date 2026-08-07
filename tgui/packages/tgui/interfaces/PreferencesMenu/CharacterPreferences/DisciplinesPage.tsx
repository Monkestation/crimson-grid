// THIS IS A DARKPACK UI FILE
import { useBackend } from 'tgui/backend';
import { Box, Collapsible, DmIcon, Icon, Section, Stack, Tooltip } from 'tgui-core/components';

import { LoadingScreen } from '../../common/LoadingScreen';
import type { DisciplineInfo, PreferencesMenuData } from '../types';
import type { ServerData } from '../types';
import { useServerPrefs } from '../useServerPrefs';

type DisciplineCardProps = {
  discipline: DisciplineInfo;
  isClanDiscipline: boolean;
  clanName: string | null;
  isGhoul: boolean;
  level: number;
  pointsAvailable: number;
  pointsSpent: number;
  onDotClick: (position: number) => void;
};

function DisciplineCard(props: DisciplineCardProps) {
  const { discipline, isClanDiscipline, clanName, isGhoul, level, pointsAvailable, pointsSpent, onDotClick } = props;
  const pointsRemaining = pointsAvailable - pointsSpent;
  const isRare = discipline.rarity === 'rare';
  const maxLevel = isGhoul && isClanDiscipline ? 1 : discipline.max_level; // ghouls only get to assign 1 point in each

  return (
    <Box
      style={{
        width: '25%',
        minWidth: '130px',
        padding: '6px',
        boxSizing: 'border-box',
      }}
    >
      <Section>
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
              {isClanDiscipline && (
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
            <Stack justify="center">
              {Array.from({ length: maxLevel }, (_, i) => {
                const position = i + 1;
                const filled = position <= level;
                const wouldIncrease = position > level;
                const canAfford = pointsRemaining >= position - level;
                const clickable = filled || canAfford;
                return (
                  <Stack.Item key={i}>
                    <Icon
                      name="circle"
                      color={filled ? 'white' : wouldIncrease && !canAfford ? 'rgba(255,255,255,0.07)' : 'rgba(255,255,255,0.18)'}
                      onClick={clickable ? () => onDotClick(position) : undefined}
                      style={{
                        cursor: clickable ? 'pointer' : 'not-allowed',
                        fontSize: '13px',
                        margin: '0 2px',
                      }}
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

type DisciplinesInnerProps = {
  disciplines: ServerData['disciplines'];
};

function DisciplinesInner(props: DisciplinesInnerProps) {
  const { disciplines } = props;
  const { act, data } = useBackend<PreferencesMenuData>();
  const disciplineLevels = data.discipline_levels || {};
  const clanDisciplines = new Set(data.clan_disciplines || []);
  const clanName = data.clan_name ?? null;
  const isGhoul = data.character_preferences.misc.splats === 'splat_ghoul';
  const pointsSpent = data.discipline_points_spent ?? 0;
  const tier = data.discipline_tier ?? 'Fledgling';
  const tierDetails = data.discipline_tier_details ?? '';

  const handleDotClick = (path: string, position: number, currentLevel: number) => {
    const newLevel = position <= currentLevel ? (position === 1 ? 0 : position) : position;
    act('set_discipline_level', { discipline: path, level: newLevel });
  };
  const disciplineEntries = Object.entries(disciplines).filter(
    ([path]) => clanDisciplines.has(path) || path in disciplineLevels,
  );
  const pointsAvailable = isGhoul
    ? Math.max(3, disciplineEntries.length)
    : data.discipline_points_available ?? 12;
  const pointsRemaining = pointsAvailable - pointsSpent;
  const overBudget = pointsSpent > pointsAvailable;

  return (
    <Stack vertical fill>
      {tierDetails && (
        <Stack.Item>
          <Section>
            <Collapsible title={`The ${tier}`} open={true} icon={'info'}>
              {tierDetails.split('\n\n').map((paragraph, i) => (
                <Box key={i} mb={i < tierDetails.split('\n\n').length - 1 ? 1 : 0}>
                  {paragraph}
                </Box>
              ))}
            </Collapsible>
          </Section>
        </Stack.Item>
      )}
      <Stack.Item>
        <Stack vertical align="center">
          <Stack.Item>
            <Box fontSize={1.5} bold textAlign="center">
              Disciplines
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Stack justify="center">
              {Array.from({ length: pointsAvailable }, (_, i) => {
                const filled = i < pointsRemaining;
                return (
                  <Stack.Item key={i}>
                    <Icon
                      name="circle"
                      color={filled ? (overBudget ? 'red' : 'white') : 'rgba(255,255,255,0.18)'}
                      style={{ fontSize: '10px', margin: '0 1px' }}
                    />
                  </Stack.Item>
                );
              })}
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Box color="label" textAlign="center">
          {pointsRemaining >= 0 ? pointsRemaining : 0} / {pointsAvailable} dots remaining
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box color="label" textAlign="center">
          <i>
            {isGhoul
              ? 'Ghouls only have access to a maximum of one dot in each discipline. To unlock more, the Ghoul must be embraced.'
              : "A Kindred's immortal age determines their dot balance. The higher their age, the more dots they can assign."}
          </i>
        </Box>
      </Stack.Item>
      <Stack.Item grow overflowY="auto">
        <Box
          style={{
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'center',
            padding: '8px',
          }}
        >
          {disciplineEntries.map(([path, discipline]) => {
            const level = disciplineLevels[path] ?? 0;
            return (
              <DisciplineCard
                key={path}
                discipline={discipline}
                isClanDiscipline={clanDisciplines.has(path)}
                clanName={clanName}
                isGhoul={isGhoul}
                level={level}
                pointsAvailable={pointsAvailable}
                pointsSpent={pointsSpent}
                onDotClick={(position) => handleDotClick(path, position, level)}
              />
            );
          })}
        </Box>
      </Stack.Item>
    </Stack>
  );
}

export function DisciplinesPage() {
  const serverData = useServerPrefs();

  if (!serverData) {
    return <LoadingScreen />;
  }

  return (
    <DisciplinesInner
      disciplines={serverData.disciplines || {}}
    />
  );
}
