import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
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

export const PcNightcrawlerEditor = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const channels = Array.isArray(data.channels) ? data.channels : [];
  const photos = Array.isArray(data.photos) ? data.photos : [];
  const limits = data.limits || {};

  const [channel, setChannel] = useState(null);
  const [byline, setByline] = useState('');
  const [headline, setHeadline] = useState('');
  const [body, setBody] = useState('');
  const [photo, setPhoto] = useState('');
  const [newName, setNewName] = useState('');
  const [newDesc, setNewDesc] = useState('');

  if (!data.can_edit) {
    return (
      <NoticeBox danger>
        You need an account on this network to use the editor.
      </NoticeBox>
    );
  }

  const selected = channels.find((c) => c.id === channel) || null;
  const publishCd = data.publish_cooldown || 0;
  const printCd = data.print_cooldown || 0;
  const canPublish =
    !!selected && headline.trim() && body.trim() && publishCd <= 0;
  const bylineValue = byline || data.byline || '';

  return (
    <Stack fill vertical>
      {!!data.status && (
        <Stack.Item>
          <NoticeBox info>{data.status}</NoticeBox>
        </Stack.Item>
      )}
      <Stack.Item grow>
        <Section fill scrollable title="Nightcrawler Editor">
          <Box bold mb={0.5}>
            Section
          </Box>
          <Box mb={1}>
            {channels.length === 0 && <Box color="label">No sections yet.</Box>}
            {channels.map((c) => (
              <Button
                key={c.id}
                selected={channel === c.id}
                tooltip={c.desc}
                onClick={() => setChannel(c.id)}
              >
                {c.name}
              </Button>
            ))}
          </Box>

          <Box bold mb={0.5}>
            Byline
          </Box>
          <Input
            fluid
            mb={1}
            value={bylineValue}
            maxLength={limits.byline}
            onInput={(a, b) => setByline(readInput(a, b))}
            onChange={(a, b) => setByline(readInput(a, b))}
          />

          <Box bold mb={0.5}>
            Headline
          </Box>
          <Input
            fluid
            mb={1}
            value={headline}
            maxLength={limits.headline}
            onInput={(a, b) => setHeadline(readInput(a, b))}
            onChange={(a, b) => setHeadline(readInput(a, b))}
          />

          <Box bold mb={0.5}>
            Story ({body.length}/{limits.body})
          </Box>
          <TextArea
            fluid
            height="140px"
            value={body}
            maxLength={limits.body}
            onInput={(a, b) => setBody(readInput(a, b))}
            onChange={(a, b) => setBody(readInput(a, b))}
          />

          {photos.length > 0 && (
            <Box mt={1}>
              <Box bold mb={0.5}>
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
                  onClick={() => setPhoto(p.ref)}
                >
                  {p.name}
                </Button>
              ))}
            </Box>
          )}

          <Box mt={1}>
            <Button
              icon="paper-plane"
              color="good"
              disabled={!canPublish}
              onClick={() => {
                act('publish', {
                  channel,
                  byline: bylineValue,
                  headline,
                  body,
                  photo,
                });
                setHeadline('');
                setBody('');
                setPhoto('');
              }}
            >
              {publishCd > 0
                ? `Wait ${publishCd}s`
                : selected
                  ? `Publish in ${selected.name}`
                  : 'Pick a section'}
            </Button>
          </Box>

          <Section title="New Section" mt={2}>
            <Input
              fluid
              mb={0.5}
              placeholder="Name"
              value={newName}
              maxLength={limits.channel_name}
              onInput={(a, b) => setNewName(readInput(a, b))}
              onChange={(a, b) => setNewName(readInput(a, b))}
            />
            <Input
              fluid
              mb={0.5}
              placeholder="Description"
              value={newDesc}
              maxLength={limits.channel_desc}
              onInput={(a, b) => setNewDesc(readInput(a, b))}
              onChange={(a, b) => setNewDesc(readInput(a, b))}
            />
            <Button
              icon="plus"
              disabled={!newName.trim() || !data.can_create_channel}
              onClick={() => {
                act('create_channel', {
                  name: newName,
                  desc: newDesc,
                  byline: bylineValue,
                });
                setNewName('');
                setNewDesc('');
              }}
            >
              {data.can_create_channel ? 'Create Section' : 'Section limit'}
            </Button>
          </Section>

          <Section title="Print Newspaper" mt={2}>
            <Box mb={1} color="label">
              Printer: {data.printer_status} · uses {data.print_sheets} sheets
            </Box>
            <Button
              icon="print"
              disabled={printCd > 0 || data.printer_status !== 'Ready'}
              onClick={() => act('print')}
            >
              {printCd > 0 ? `Wait ${printCd}s` : 'Print Latest Edition'}
            </Button>
          </Section>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
