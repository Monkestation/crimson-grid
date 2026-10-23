import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { resolveAsset } from '../../assets';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const paintingSrc = (p) => resolveAsset(`${p.md5}.png`);

const Painting = ({
  painting,
  canPrint,
  canAfford,
  onPrint,
  selected,
  onSelect,
}) => (
  <Box
    onClick={onSelect}
    p={1}
    style={{
      width: 170,
      textAlign: 'center',
      cursor: 'pointer',
      border: selected ? '2px solid #0055ea' : '1px solid #555',
      background: 'rgba(0, 0, 0, 0.25)',
    }}
  >
    <Box
      style={{
        height: 130,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <img
        src={paintingSrc(painting)}
        alt=""
        style={{
          maxWidth: '100%',
          maxHeight: 130,
          imageRendering: 'pixelated',
        }}
      />
    </Box>
    <Box bold mt={0.5} style={{ wordBreak: 'break-word' }}>
      {painting.title}
    </Box>
    <Box style={{ fontSize: '11px', wordBreak: 'break-word' }}>
      by {painting.creator}
    </Box>
    {!!canPrint && selected && (
      <Button
        mt={0.5}
        fluid
        icon="print"
        disabled={!canAfford}
        onClick={(e) => {
          e.stopPropagation?.();
          onPrint();
        }}
      >
        Print canvas
      </Button>
    )}
  </Box>
);

export const PcPortraitPrinter = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const art = data.portraits || data;

  const paintings = Array.isArray(art.paintings) ? art.paintings : [];
  // canPrint = a working printer exists on this computer's network
  const canPrint = !!art.can_print;
  const paper = art.paper || 0;
  const cost = art.paper_cost || 0;
  const cooldown = art.cooldown_left || 0;
  const hasPaper = paper >= cost;
  const canAfford = hasPaper && cooldown <= 0;

  const [search, setSearch] = useState(art.search_string || '');
  const [selected, setSelected] = useState(null);

  const doSearch = (value) => act('search', { to_search: value });

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title="Marlowe Treeby's Art Galaxy"
          buttons={
            canPrint ? (
              <Box inline color={hasPaper ? 'good' : 'bad'}>
                <Icon name="file" mr={0.5} />
                Printer paper: {paper} (canvas costs {cost})
              </Box>
            ) : undefined
          }
        >
          <Stack>
            <Stack.Item>
              <Button
                icon="exchange-alt"
                tooltip="Switch between searching titles and authors"
                onClick={() => act('change_search_mode')}
              >
                {art.search_mode || 'Title'}
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={search}
                placeholder={`Search by ${(art.search_mode || 'Title').toLowerCase()}...`}
                onInput={(a, b) => setSearch(readInput(a, b))}
                onChange={(a, b) => {
                  const value = readInput(a, b);
                  setSearch(value);
                  doSearch(value);
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <Button icon="search" onClick={() => doSearch(search)}>
                Search
              </Button>
              {!!art.search_string && (
                <Button
                  icon="times"
                  onClick={() => {
                    setSearch('');
                    doSearch('');
                  }}
                >
                  Clear
                </Button>
              )}
            </Stack.Item>
          </Stack>
          {!canPrint && (
            <NoticeBox info mt={1}>
              No printer found on this network. Connect to a network with a
              printer to print canvases.
            </NoticeBox>
          )}
          {canPrint && !hasPaper && (
            <NoticeBox danger mt={1}>
              The network printer is out of paper.
            </NoticeBox>
          )}
          {canPrint && hasPaper && cooldown > 0 && (
            <NoticeBox mt={1}>Printer warming up ({cooldown}s)</NoticeBox>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section fill scrollable>
          {paintings.length === 0 ? (
            <Box>No paintings found.</Box>
          ) : (
            <Box style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
              {paintings.map((p) => (
                <Painting
                  key={p.ref}
                  painting={p}
                  canPrint={canPrint}
                  canAfford={canAfford}
                  selected={selected === p.ref}
                  onSelect={() =>
                    setSelected(selected === p.ref ? null : p.ref)
                  }
                  onPrint={() => act('print', { selected: p.ref })}
                />
              ))}
            </Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
