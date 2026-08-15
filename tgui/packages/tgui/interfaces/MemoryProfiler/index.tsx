// THIS IS A CRIMSON UI FILE
import { useState } from 'react';
import { NoticeBox, Stack, Tabs } from 'tgui-core/components';
import { exhaustiveCheck } from 'tgui-core/exhaustive';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { CompatTab } from './CompatTab';
import { DiffTab } from './DiffTab';
import { ListsTab } from './ListsTab';
import { Overview } from './Overview';
import { TypesTab } from './TypesTab';
import type { Data } from './types';
import { VarsTab } from './VarsTab';

enum TAB {
  Overview = 'overview',
  Types = 'types',
  Lists = 'lists',
  Vars = 'vars',
  Diff = 'diff',
  Compat = 'compat',
}

function render_tab(tab: TAB) {
  switch (tab) {
    case TAB.Overview:
      return <Overview />;
    case TAB.Types:
      return <TypesTab />;
    case TAB.Lists:
      return <ListsTab />;
    case TAB.Vars:
      return <VarsTab />;
    case TAB.Diff:
      return <DiffTab />;
    case TAB.Compat:
      return <CompatTab />;
    default:
      return exhaustiveCheck(tab);
  }
}

/** anything that would make the numbers below a lie, said before you go read them. */
function StatusBanner() {
  const { data } = useBackend<Data>();
  const { last_error, coverage } = data;

  return (
    <>
      {!!last_error && <NoticeBox danger>{last_error}</NoticeBox>}
      {!!coverage && !coverage.complete && (
        <NoticeBox danger>
          This build could not get at {coverage.unavailable.join(', ')}, so
          every total in every report is short by whatever was living in them.
          Compat tab has the details.
        </NoticeBox>
      )}
    </>
  );
}

export function MemoryProfiler() {
  const { data } = useBackend<Data>();
  const { enabled, error } = data;
  const [tab, set_tab] = useState(TAB.Overview);

  return (
    <Window title="Memory Profiler" width={1100} height={760}>
      <Window.Content>
        {!enabled ? (
          <NoticeBox danger>
            byond_memprofile did not load: {error || 'and it did not say why'}
          </NoticeBox>
        ) : (
          <Stack fill vertical>
            <Stack.Item>
              <StatusBanner />
            </Stack.Item>
            <Stack.Item>
              <Tabs fluid>
                <Tabs.Tab
                  icon="gauge"
                  selected={tab === TAB.Overview}
                  onClick={() => set_tab(TAB.Overview)}
                >
                  Overview
                </Tabs.Tab>
                <Tabs.Tab
                  icon="sitemap"
                  selected={tab === TAB.Types}
                  onClick={() => set_tab(TAB.Types)}
                >
                  Types
                </Tabs.Tab>
                <Tabs.Tab
                  icon="list"
                  selected={tab === TAB.Lists}
                  onClick={() => set_tab(TAB.Lists)}
                >
                  Lists
                </Tabs.Tab>
                <Tabs.Tab
                  icon="tag"
                  selected={tab === TAB.Vars}
                  onClick={() => set_tab(TAB.Vars)}
                >
                  Vars
                </Tabs.Tab>
                <Tabs.Tab
                  icon="scale-balanced"
                  selected={tab === TAB.Diff}
                  onClick={() => set_tab(TAB.Diff)}
                >
                  Diff
                </Tabs.Tab>
                <Tabs.Tab
                  icon="microscope"
                  selected={tab === TAB.Compat}
                  onClick={() => set_tab(TAB.Compat)}
                >
                  Compat
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            <Stack.Item grow>{render_tab(tab)}</Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
}
