import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  TextArea,
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

const COLORS = {
  subject: '#0f0c5d',
  name: '#117743',
  green: '#789922',
  muted: '#555',
  opBg: '#fff',
  replyBg: '#d6daf0',
  replyBorder: '#b7c5d9',
};

const jumpTo = (id) => {
  const el = document.getElementById(`ib-post-${id}`);
  if (!el) return;
  el.scrollIntoView({ block: 'center' });
  el.style.outline = '2px solid #e0a000';
  setTimeout(() => {
    el.style.outline = '';
  }, 1500);
};

const QuoteLink = ({ id }) => (
  <span
    onClick={() => jumpTo(id)}
    style={{ color: '#d00', textDecoration: 'underline', cursor: 'pointer' }}
  >
    {'>>'}
    {id}
  </span>
);

const renderLine = (line) =>
  line.split(/(>>\d+)/g).map((part, i) => {
    const m = /^>>(\d+)$/.exec(part);
    return m ? <QuoteLink key={i} id={m[1]} /> : part;
  });

//4chan my beloathed
const PostText = ({ text }) => (
  <Box
    style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word', color: '#000' }}
  >
    {String(text || '')
      .split('\n')
      .map((line, i) => (
        <div
          key={i}
          style={
            line.startsWith('>') && !line.startsWith('>>')
              ? { color: COLORS.green }
              : undefined
          }
        >
          {line ? renderLine(line) : '\u00a0'}
        </div>
      ))}
  </Box>
);

const Post = ({ post, op, onOpen, onQuote, backlinks = [] }) => (
  <Box
    id={`ib-post-${post.id}`}
    mb={0.5}
    p={1}
    style={{
      background: op ? COLORS.opBg : COLORS.replyBg,
      border: op ? 'none' : `1px solid ${COLORS.replyBorder}`,
      marginLeft: op ? 0 : 16,
      color: '#000',
    }}
  >
    <Box mb={0.5} style={{ fontSize: '11px' }}>
      {!!post.subject && (
        <Box
          inline
          mr={1}
          bold
          style={{ color: COLORS.subject, fontSize: '13px' }}
        >
          {post.subject}
        </Box>
      )}
      <Box inline bold mr={1} style={{ color: COLORS.name }}>
        {post.name}
      </Box>
      <Box inline mr={1} style={{ color: COLORS.muted }}>
        {post.time}
      </Box>
      <Box inline style={{ color: COLORS.muted }}>
        No.
        <span
          onClick={onQuote ? () => onQuote(post.id) : undefined}
          style={
            onQuote
              ? { cursor: 'pointer', textDecoration: 'underline' }
              : undefined
          }
        >
          {post.id}
        </span>
      </Box>
      {backlinks.map((id) => (
        <Box inline ml={1} key={id} style={{ fontSize: '10px' }}>
          <QuoteLink id={id} />
        </Box>
      ))}
      {!!onOpen && (
        <Button ml={1} compact icon="comments" onClick={onOpen}>
          Reply
        </Button>
      )}
    </Box>
    <Box style={{ display: 'flex', gap: '10px', alignItems: 'flex-start' }}>
      {!!post.photo && (
        <Box
          style={{
            flex: '0 0 auto',
            textAlign: 'center',
            fontSize: '10px',
            color: COLORS.muted,
          }}
        >
          <img
            src={post.photo}
            alt=""
            style={{
              maxWidth: 192,
              maxHeight: 192,
              border: '1px solid #999',
              display: 'block',
            }}
          />
          {post.photo_name}
        </Box>
      )}
      {!!post.image && (
        <img
          src={resolveAsset(post.image)}
          alt=""
          style={{
            maxWidth: 140,
            maxHeight: 140,
            border: '1px solid #999',
            flex: '0 0 auto',
          }}
        />
      )}
      <PostText text={post.body} />
    </Box>
  </Box>
);

const PostForm = ({
  withSubject,
  images,
  photos,
  limits,
  cooldown,
  label,
  onSubmit,
  quoteReq,
  onQuoteUsed,
}) => {
  const [name, setName] = useState('');
  const [subject, setSubject] = useState('');
  const [body, setBody] = useState('');
  const [image, setImage] = useState('');
  const [photo, setPhoto] = useState('');

  // purely so we can embed replies
  useEffect(() => {
    if (!quoteReq) return;
    setBody(
      (b) => `${b}${b && !b.endsWith('\n') ? '\n' : ''}>>${quoteReq.id}\n`,
    );
    onQuoteUsed?.();
  }, [quoteReq]);

  const canPost = (body.trim() || image || photo) && cooldown <= 0;

  return (
    <Box
      p={1}
      mb={1}
      style={{ background: '#f0e0d6', border: '1px solid #d9bfb7' }}
    >
      <Stack vertical>
        <Stack.Item>
          <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
            Name (optional)
          </Box>
          <Input
            fluid
            value={name}
            maxLength={limits.name}
            placeholder="Anonymous"
            onInput={(a, b) => setName(readInput(a, b))}
            onChange={(a, b) => setName(readInput(a, b))}
          />
        </Stack.Item>
        {withSubject && (
          <Stack.Item>
            <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
              Subject
            </Box>
            <Input
              fluid
              value={subject}
              maxLength={limits.subject}
              onInput={(a, b) => setSubject(readInput(a, b))}
              onChange={(a, b) => setSubject(readInput(a, b))}
            />
          </Stack.Item>
        )}
        <Stack.Item>
          <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
            Comment
          </Box>
          <TextArea
            fluid
            height="90px"
            value={body}
            maxLength={limits.body}
            onInput={(a, b) => setBody(readInput(a, b))}
            onChange={(a, b) => setBody(readInput(a, b))}
          />
        </Stack.Item>
        {images.length > 0 && (
          <Stack.Item>
            <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
              Image
            </Box>
            <Box style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
              <Box
                onClick={() => setImage('')}
                style={{
                  width: 48,
                  height: 48,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  cursor: 'pointer',
                  color: '#000',
                  background: '#fff',
                  border: image === '' ? '2px solid #0055ea' : '1px solid #999',
                  fontSize: '10px',
                }}
              >
                None
              </Box>
              {images.map((img) => (
                <img
                  key={img}
                  src={resolveAsset(img)}
                  alt=""
                  onClick={() => {
                    setImage(img);
                    setPhoto('');
                  }}
                  style={{
                    width: 48,
                    height: 48,
                    objectFit: 'cover',
                    cursor: 'pointer',
                    border:
                      image === img ? '2px solid #0055ea' : '1px solid #999',
                  }}
                />
              ))}
            </Box>
          </Stack.Item>
        )}
        {photos.length > 0 && (
          <Stack.Item>
            <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
              Attach a photo you&apos;re carrying
            </Box>
            <Button selected={photo === ''} onClick={() => setPhoto('')}>
              None
            </Button>
            {photos.map((p) => (
              <Button
                key={p.ref}
                icon="camera"
                selected={photo === p.ref}
                onClick={() => {
                  setPhoto(p.ref);
                  setImage('');
                }}
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
              onSubmit({ name, subject, body, image, photo });
              setBody('');
              setSubject('');
              setImage('');
              setPhoto('');
            }}
          >
            {cooldown > 0 ? `Wait ${cooldown}s` : label}
          </Button>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const PcImageBoard = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const ib = data.imageboard || data;
  const view = ib.view || 'index';
  const boards = Array.isArray(ib.boards) ? ib.boards : [];
  const images = Array.isArray(ib.images) ? ib.images : [];
  const limits = ib.limits || { name: 30, subject: 60, body: 1500 };
  const photos = Array.isArray(ib.photos) ? ib.photos : [];
  const cooldown = ib.cooldown_left || 0;

  const [showForm, setShowForm] = useState(false);
  const [quoteReq, setQuoteReq] = useState(null);

  const formProps = {
    images,
    photos,
    limits,
    cooldown,
    quoteReq,
    onQuoteUsed: () => setQuoteReq(null),
  };

  const quotePost = (id) => {
    setShowForm(true);
    setQuoteReq({ id });
  };

  // Who replied to whom
  const backlinks = {};
  if (view === 'thread' && ib.thread) {
    const everyPost = [ib.thread.op, ...ib.thread.replies];
    for (const p of everyPost) {
      const re = />>(\d+)/g;
      let m = re.exec(String(p.body || ''));
      while (m) {
        const list = backlinks[m[1]] || [];
        if (!list.includes(p.id)) list.push(p.id);
        backlinks[m[1]] = list;
        m = re.exec(String(p.body || ''));
      }
    }
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Box
          p={1}
          style={{
            color: '#000',
            borderBottom: '1px solid #b8b8b8',
            background: '#eef2ff',
          }}
        >
          <Button compact icon="home" onClick={() => act('home')}>
            Boards
          </Button>
          {view !== 'index' && (
            <>
              <Box inline mx={1}>
                /
              </Box>
              <Button
                compact
                onClick={() => {
                  act('open_board', { board: ib.board });
                  setShowForm(false);
                }}
              >
                {ib.board_name}
              </Button>
            </>
          )}
          {view === 'thread' && (
            <>
              <Box inline mx={1}>
                /
              </Box>
              <Box inline bold>
                Thread {ib.thread?.id}
              </Box>
            </>
          )}
        </Box>
      </Stack.Item>

      <Stack.Item grow>
        <Section fill scrollable>
          {view === 'index' && (
            <Box style={{ color: '#000' }}>
              <Box bold mb={1} style={{ fontSize: '16px' }}>
                <Icon name="images" mr={1} />
                {data.network_name || 'Local'} Boards
              </Box>
              {boards.length === 0 && (
                <Box>No boards available. Are you on a network?</Box>
              )}
              {boards.map((b) => (
                <Box key={b.id} mb={0.5}>
                  <Button
                    fluid
                    icon="folder-open"
                    onClick={() => act('open_board', { board: b.id })}
                  >
                    /{b.id}/ — {b.name}
                  </Button>
                </Box>
              ))}
            </Box>
          )}

          {view === 'board' && (
            <Box>
              <Box bold mb={1} style={{ color: '#af0a0f', fontSize: '16px' }}>
                /{ib.board}/ — {ib.board_name}
              </Box>
              <Box mb={1}>
                <Button
                  icon={showForm ? 'minus' : 'plus'}
                  onClick={() => setShowForm(!showForm)}
                >
                  {showForm ? 'Cancel' : 'Start a New Thread'}
                </Button>
              </Box>
              {showForm && (
                <PostForm
                  {...formProps}
                  withSubject
                  label="Post Thread"
                  onSubmit={(p) => {
                    act('new_thread', p);
                    setShowForm(false);
                  }}
                />
              )}
              {(ib.threads || []).length === 0 && (
                <Box>No threads yet. Be the first.</Box>
              )}
              {(ib.threads || []).map((t) => (
                <Box
                  key={t.id}
                  mb={1}
                  pb={1}
                  style={{ borderBottom: '1px solid #bbb' }}
                >
                  <Post
                    post={t.op}
                    op
                    onOpen={() => act('open_thread', { id: t.id })}
                  />
                  {t.omitted > 0 && (
                    <Box ml={2} mb={0.5} style={{ color: COLORS.muted }}>
                      {t.omitted} earlier repl{t.omitted === 1 ? 'y' : 'ies'}{' '}
                      omitted.
                    </Box>
                  )}
                  {t.replies.map((r) => (
                    <Post key={r.id} post={r} />
                  ))}
                </Box>
              ))}
            </Box>
          )}

          {view === 'thread' && ib.thread && (
            <Box>
              <Post
                post={ib.thread.op}
                op
                backlinks={backlinks[String(ib.thread.op.id)]}
                onQuote={quotePost}
              />
              {ib.thread.replies.map((r) => (
                <Post
                  key={r.id}
                  post={r}
                  backlinks={backlinks[String(r.id)]}
                  onQuote={quotePost}
                />
              ))}
              <Box mt={1}>
                {ib.thread.full ? (
                  <Box color="bad" bold>
                    This thread has reached its reply limit.
                  </Box>
                ) : (
                  <>
                    <Button
                      icon={showForm ? 'minus' : 'reply'}
                      onClick={() => setShowForm(!showForm)}
                      mb={1}
                    >
                      {showForm ? 'Cancel' : 'Post a Reply'}
                    </Button>
                    {showForm && (
                      <PostForm
                        {...formProps}
                        label="Post Reply"
                        onSubmit={(p) => {
                          act('reply', p);
                          setShowForm(false);
                        }}
                      />
                    )}
                  </>
                )}
              </Box>
            </Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
