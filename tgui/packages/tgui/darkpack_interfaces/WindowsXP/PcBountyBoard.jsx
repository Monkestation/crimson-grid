import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const THEMES = {
  public: {
    title: 'Bounty Board',
    icon: 'clipboard-list',
    accent: '#2d6a4f',
    card: '#eef5ee',
    border: '#b7d3b7',
    text: '#000',
    muted: '#555',
  },
  blackmarket: {
    title: 'Black Market',
    accent: '#c0111f',
    card: '#1c1114',
    border: '#5a1a22',
    text: '#e8dcdc',
    muted: '#a08a8a',
  },
};

const STATUS_LABEL = {
  open: 'OPEN',
  claimed: 'CLAIMED',
  fulfilled: 'FULFILLED',
};

const STATUS_COLOR = {
  open: '#2e9e4f',
  claimed: '#d98e04',
  fulfilled: '#777',
};

const StatusTag = ({ status }) => (
  <Box
    inline
    ml={1}
    px={0.5}
    bold
    style={{
      fontSize: '10px',
      color: '#fff',
      background: STATUS_COLOR[status] || '#777',
    }}
  >
    {STATUS_LABEL[status] || status}
  </Box>
);

const BountyPhoto = ({ b, size }) =>
  b.photo ? (
    <Box
      style={{
        flex: '0 0 auto',
        textAlign: 'center',
        fontSize: '10px',
      }}
    >
      <img
        src={b.photo}
        alt=""
        style={{
          maxWidth: size,
          maxHeight: size,
          border: '1px solid #999',
          display: 'block',
        }}
      />
      {b.photo_name}
    </Box>
  ) : null;

const BountyCard = ({ b, theme, blackmarket, onOpen }) => (
  <Box
    mb={1}
    p={1}
    style={{
      background: theme.card,
      border: `1px solid ${theme.border}`,
      borderLeft: `4px solid ${theme.accent}`,
      color: theme.text,
    }}
  >
    <Box style={{ display: 'flex', gap: '10px', alignItems: 'flex-start' }}>
      <BountyPhoto b={b} size={72} />
      <Box style={{ flex: '1 1 auto' }}>
        <Box>
          <Box inline bold style={{ fontSize: '14px' }}>
            {b.title}
          </Box>
          <StatusTag status={b.status} />
        </Box>
        <Box style={{ fontSize: '11px', color: theme.muted }}>
          {b.category} · posted by {b.poster}
          {blackmarket && ' (alias)'} · {b.time}
        </Box>
        <Box mt={0.5}>
          <Icon name="coins" mr={1} />
          <b>{b.reward}</b>
        </Box>
      </Box>
      <Button icon="eye" onClick={onOpen}>
        View
      </Button>
    </Box>
  </Box>
);

const PostForm = ({
  theme,
  blackmarket,
  categories,
  photos,
  limits,
  cooldown,
  onSubmit,
}) => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [reward, setReward] = useState('');
  const [alias, setAlias] = useState('');
  const [category, setCategory] = useState(categories[0] || '');
  const [photo, setPhoto] = useState('');

  const canPost = title.trim() && cooldown <= 0;
  const labelStyle = { fontWeight: 'bold', color: theme.text };

  return (
    <Box
      p={1}
      mb={1}
      style={{ background: theme.card, border: `1px solid ${theme.border}` }}
    >
      <Stack vertical>
        {blackmarket && (
          <Stack.Item>
            <Box style={labelStyle} mb={0.5}>
              Alias (your name is never shown)
            </Box>
            <Input
              fluid
              value={alias}
              maxLength={limits.alias}
              placeholder="Unknown"
              onInput={(a, b) => setAlias(readInput(a, b))}
              onChange={(a, b) => setAlias(readInput(a, b))}
            />
          </Stack.Item>
        )}
        <Stack.Item>
          <Box style={labelStyle} mb={0.5}>
            Title
          </Box>
          <Input
            fluid
            value={title}
            maxLength={limits.title}
            onInput={(a, b) => setTitle(readInput(a, b))}
            onChange={(a, b) => setTitle(readInput(a, b))}
          />
        </Stack.Item>
        <Stack.Item>
          <Box style={labelStyle} mb={0.5}>
            Category
          </Box>
          {categories.map((c) => (
            <Button
              key={c}
              selected={category === c}
              onClick={() => setCategory(c)}
            >
              {c}
            </Button>
          ))}
        </Stack.Item>
        <Stack.Item>
          <Box style={labelStyle} mb={0.5}>
            Details
          </Box>
          <TextArea
            fluid
            height="90px"
            value={description}
            maxLength={limits.description}
            onInput={(a, b) => setDescription(readInput(a, b))}
            onChange={(a, b) => setDescription(readInput(a, b))}
          />
        </Stack.Item>
        <Stack.Item>
          <Box style={labelStyle} mb={0.5}>
            Reward
          </Box>
          <Input
            fluid
            value={reward}
            maxLength={limits.reward}
            placeholder="Negotiable"
            onInput={(a, b) => setReward(readInput(a, b))}
            onChange={(a, b) => setReward(readInput(a, b))}
          />
        </Stack.Item>
        {photos.length > 0 && (
          <Stack.Item>
            <Box style={labelStyle} mb={0.5}>
              {blackmarket
                ? 'Attach a photo of the target / item'
                : 'Attach a photo you\u2019re carrying'}
            </Box>
            <Button selected={photo === ''} onClick={() => setPhoto('')}>
              None
            </Button>
            {photos.map((p) => (
              <Button
                key={p.ref}
                icon="camera"
                selected={photo === p.ref}
                onClick={() => setPhoto(p.ref)}
              >
                {p.name}
              </Button>
            ))}
          </Stack.Item>
        )}
        <Stack.Item>
          <Button
            icon="paper-plane"
            color="good"
            disabled={!canPost}
            onClick={() => {
              onSubmit({ title, description, reward, alias, category, photo });
              setTitle('');
              setDescription('');
              setReward('');
              setPhoto('');
            }}
          >
            {cooldown > 0 ? `Wait ${cooldown}s` : 'Post Bounty'}
          </Button>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const PcBountyBoard = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const blackmarket = !!data.blackmarket;
  const theme = blackmarket ? THEMES.blackmarket : THEMES.public;
  const view = data.view || 'list';
  const bounties = Array.isArray(data.bounties) ? data.bounties : [];
  const categories = Array.isArray(data.categories) ? data.categories : [];
  const photos = Array.isArray(data.photos) ? data.photos : [];
  const limits = data.limits || {
    title: 60,
    description: 800,
    reward: 60,
    alias: 30,
  };
  const cooldown = data.cooldown_left || 0;
  const b = data.selected;

  const [showForm, setShowForm] = useState(false);
  const [claimAlias, setClaimAlias] = useState('');

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Box
          p={1}
          style={{
            color: theme.text,
            background: theme.card,
            borderBottom: `2px solid ${theme.accent}`,
          }}
        >
          <Icon name={theme.icon} mr={1} />
          <Box inline bold style={{ fontSize: '15px' }}>
            {data.network_name ? `${data.network_name}  ` : ''}
            {theme.title}
          </Box>
          {view === 'detail' && (
            <Button
              ml={2}
              compact
              icon="arrow-left"
              onClick={() => act('back')}
            >
              All bounties
            </Button>
          )}
        </Box>
      </Stack.Item>

      <Stack.Item grow>
        <Section fill scrollable>
          {view === 'list' && (
            <Box>
              <Box mb={1}>
                <Button
                  icon={showForm ? 'minus' : 'plus'}
                  onClick={() => setShowForm(!showForm)}
                >
                  {showForm ? 'Cancel' : 'Post a Bounty'}
                </Button>
              </Box>
              {showForm && (
                <PostForm
                  theme={theme}
                  blackmarket={blackmarket}
                  categories={categories}
                  photos={photos}
                  limits={limits}
                  cooldown={cooldown}
                  onSubmit={(p) => {
                    act('post', p);
                    setShowForm(false);
                  }}
                />
              )}
              {bounties.length === 0 && (
                <Box>
                  {data.network_name
                    ? 'No bounties posted yet.'
                    : 'No network connection.'}
                </Box>
              )}
              {bounties.map((x) => (
                <BountyCard
                  key={x.id}
                  b={x}
                  theme={theme}
                  blackmarket={blackmarket}
                  onOpen={() => act('open', { id: x.id })}
                />
              ))}
            </Box>
          )}

          {view === 'detail' && b && (
            <Box
              p={1}
              style={{
                background: theme.card,
                border: `1px solid ${theme.border}`,
                borderLeft: `4px solid ${theme.accent}`,
                color: theme.text,
              }}
            >
              <Box mb={1}>
                <Box inline bold style={{ fontSize: '16px' }}>
                  {b.title}
                </Box>
                <StatusTag status={b.status} />
              </Box>
              <Box style={{ fontSize: '11px', color: theme.muted }} mb={1}>
                {b.category} · posted by {b.poster}
                {blackmarket && ' (alias)'} · {b.time}
                {b.claimant && ` · claimed by ${b.claimant}`}
              </Box>
              <Box
                style={{
                  display: 'flex',
                  gap: '12px',
                  alignItems: 'flex-start',
                }}
              >
                <BountyPhoto b={b} size={192} />
                <Box
                  style={{
                    whiteSpace: 'pre-wrap',
                    wordBreak: 'break-word',
                    flex: '1 1 auto',
                  }}
                >
                  {b.description || 'No further details.'}
                </Box>
              </Box>
              <Box mt={1}>
                <Icon name="coins" mr={1} />
                Reward: <b>{b.reward}</b>
              </Box>

              <Box mt={2}>
                {b.status === 'open' && !b.mine && (
                  <>
                    {blackmarket && (
                      <Box mb={1}>
                        <Input
                          fluid
                          value={claimAlias}
                          maxLength={limits.alias}
                          placeholder="Your alias (optional)"
                          onInput={(x, y) => setClaimAlias(readInput(x, y))}
                          onChange={(x, y) => setClaimAlias(readInput(x, y))}
                        />
                      </Box>
                    )}
                    <Button
                      icon="hand-paper"
                      color="good"
                      onClick={() => act('claim', { alias: claimAlias })}
                    >
                      Claim
                    </Button>
                  </>
                )}
                {b.status === 'claimed' && (b.claimed_by_me || b.mine) && (
                  <Button
                    icon="undo"
                    color="average"
                    onClick={() => act('release')}
                  >
                    {b.mine ? 'Reopen' : 'Back out'}
                  </Button>
                )}
                {b.status === 'claimed' && b.mine && (
                  <Button
                    icon="check"
                    color="good"
                    onClick={() => act('fulfill')}
                  >
                    Mark Fulfilled
                  </Button>
                )}
                {b.mine && (
                  <Button
                    icon="trash"
                    color="bad"
                    onClick={() => act('cancel')}
                  >
                    Delete
                  </Button>
                )}
              </Box>
            </Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
