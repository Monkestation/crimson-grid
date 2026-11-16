import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Dropdown, Flex, Stack } from 'tgui-core/components'; // DARKPACK EDIT CHANGE
import { exhaustiveCheck } from 'tgui-core/exhaustive';

import { PageButton } from '../components/PageButton';
import type { PreferencesMenuData } from '../types';
import { AntagsPage } from './AntagsPage';
import { JobsPage } from './JobsPage';
import { LoadoutPage } from './loadout';
import { MainPage } from './MainPage';
import { QuirkPersonalityPage } from './QuirksPage';
import { SplatsPage } from './SplatsPage'; // DARKPACK EDIT CHANGE - SPLATS
import { StatsPage } from './Stats'; // DARKPACK EDIT ADD
import { DisciplinesPage } from './DisciplinesPage'; // DARKPACK EDIT ADD

enum Page {
  Antags,
  Main,
  Jobs,
  Splats, // DARKPACK EDIT CHANGE - SPLATS
  Quirks,
  Loadout,
  Stats, // DARKPACK EDIT ADD
  Disciplines, // DARKPACK EDIT ADD
}

type ProfileProps = {
  activeSlot: number;
  onClick: (index: number) => void;
  profiles: (string | null)[];
};

function CharacterProfiles(props: ProfileProps) {
  const { activeSlot, onClick, profiles } = props;

  // DARKPACK EDIT CHANGE START
  if (profiles.length <= 5)
    // TG Version
    return (
      <Stack justify="center" wrap>
        {profiles.map((profile, slot) => (
          <Stack.Item key={slot} mb={1}>
            <Button
              selected={slot === activeSlot}
              onClick={() => {
                onClick(slot);
              }}
              fluid
            >
              {profile ?? 'New Character'}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    );
  else
    // Expanded version if we have way 2 many slots.
    return (
      <Flex align="center" justify="center">
        <Flex.Item width="25%">
          <Dropdown
            width="100%"
            selected={activeSlot as unknown as string}
            displayText={profiles[activeSlot]}
            options={profiles.map((profile, slot) => ({
              value: slot,
              displayText: profile ?? 'New Character',
            }))}
            onSelected={(slot) => {
              onClick(slot);
            }}
          />
        </Flex.Item>
      </Flex>
    );
  // DARKPACK EDIT CHANGE END
}

export function CharacterPreferenceWindow(props) {
  const { act, data } = useBackend<PreferencesMenuData>();

  const [currentPage, setCurrentPage] = useState(Page.Main);

  let pageContents;

  switch (currentPage) {
    case Page.Antags:
      pageContents = <AntagsPage />;
      break;
    case Page.Jobs:
      pageContents = <JobsPage />;
      break;
    case Page.Main:
      pageContents = (
        <MainPage openSplats={() => setCurrentPage(Page.Splats)} /> // DARKPACK EDIT CHANGE - SPLATS
      );

      break;
    case Page.Splats: // DARKPACK EDIT CHANGE - SPLATS
      pageContents = (
        <SplatsPage closeSplats={() => setCurrentPage(Page.Main)} /> // DARKPACK EDIT CHANGE - SPLATS
      );

      break;
    case Page.Quirks:
      pageContents = <QuirkPersonalityPage />;
      break;

    case Page.Loadout:
      pageContents = <LoadoutPage />;
      break;

    // DARKPACK EDIT ADD START - Stats / Disciplines
    case Page.Stats:
      pageContents = <StatsPage />;
      break;

    case Page.Disciplines:
      pageContents = <DisciplinesPage />;
      break;
    // DARKPACK EDIT ADD END

    default:
      exhaustiveCheck(currentPage);
  }

  return (
    <Stack vertical fill>
      <Stack.Item>
        <CharacterProfiles
          activeSlot={data.active_slot - 1}
          onClick={(slot) => {
            act('change_slot', {
              slot: slot + 1,
            });
          }}
          profiles={data.character_profiles}
        />
      </Stack.Item>
      {!data.content_unlocked && (
        <Stack.Item align="center">
          Buy BYOND premium for more slots!
        </Stack.Item>
      )}
      <Stack.Divider />
      <Stack.Item>
        <Stack fill>
          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Main}
              setPage={setCurrentPage}
              otherActivePages={[Page.Splats]} // DARKPACK EDIT CHANGE - SPLATS
            >
              Character
            </PageButton>
          </Stack.Item>

          {
            // DARKPACK EDIT ADD START - stats / disciplines
          }
          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Stats}
              setPage={setCurrentPage}
            >
              Stats
            </PageButton>
          </Stack.Item>
          {['splat_kindred', 'splat_ghoul'].includes(
            data.character_preferences.misc.splats,
          ) && (
            <Stack.Item grow>
              <PageButton
                currentPage={currentPage}
                page={Page.Disciplines}
                setPage={setCurrentPage}
              >
                Disciplines
              </PageButton>
            </Stack.Item>
          )}
          {
            // DARKPACK EDIT END
          }

          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Loadout}
              setPage={setCurrentPage}
            >
              Loadout
            </PageButton>
          </Stack.Item>

          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Jobs}
              setPage={setCurrentPage}
            >
              {/*
                    Fun fact: This isn't "Jobs" so that it intentionally
                    catches your eyes, because it's really important!
                  */}
              Occupations
            </PageButton>
          </Stack.Item>

          {/* DARKPACK EDIT REMOVAL - (We dont have antags and this is useless atm)
          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Antags}
              setPage={setCurrentPage}
            >
              Antagonists
            </PageButton>
          </Stack.Item>
            */}

          {
            // DARKPACK EDIT ADD START - Merits
          }
          <Stack.Item grow>
            <PageButton
              currentPage={currentPage}
              page={Page.Quirks}
              setPage={setCurrentPage}
            >
              Merits / Flaws
            </PageButton>
          </Stack.Item>
          {
            // DARKPACK EDIT ADD END
          }
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow position="relative" overflowX="hidden" overflowY="auto">
        {pageContents}
      </Stack.Item>
    </Stack>
  );
}
