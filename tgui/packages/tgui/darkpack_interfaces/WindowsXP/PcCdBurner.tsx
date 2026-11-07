import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Table,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

type BurnerTrack = {
  index: number;
  title: string;
  artist: string;
  genre: string;
  duration: number;
};

const readString = (a: any, b: any): string => {
  if (typeof b === 'string') return b;
  if (typeof a === 'string') return a;
  if (a && typeof a === 'object' && a.target != null) {
    return String(a.target.value ?? '');
  }
  return '';
};

const formatTime = (seconds: number) => {
  const s = Math.max(0, Math.floor(seconds));
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`;
};

// Accepts "215" or "3:35" and returns seconds as a string for the backend.
const parseDuration = (text: string): string => {
  const trimmed = text.trim();
  if (trimmed.includes(':')) {
    const [m, s] = trimmed.split(':');
    const total = Number(m) * 60 + Number(s);
    return Number.isNaN(total) ? '' : String(total);
  }
  return trimmed;
};

export const PcCdBurner = (props, context) => {
  const { act, data: raw } = useProgram(props.programId, context);
  const data = raw.cd_burner || raw;

  const tracks: BurnerTrack[] = data.tracks || [];
  const burning = !!data.burning;
  const full = tracks.length >= (data.max_tracks || 0);

  const [url, setUrl] = useState('');
  const [title, setTitle] = useState('');
  const [artist, setArtist] = useState('');
  const [genre, setGenre] = useState('');
  const [duration, setDuration] = useState('');

  const canBurn =
    !!data.has_disc &&
    !burning &&
    !full &&
    data.permission !== 'pending' &&
    data.permission !== 'denied' &&
    url.trim() !== '' &&
    title.trim() !== '' &&
    duration.trim() !== '';

  const burn = () => {
    act('burn', {
      url,
      title,
      artist,
      genre,
      duration: parseDuration(duration),
    });
  };

  return (
    <Box
      style={{
        display: 'flex',
        flexDirection: 'column',
        height: '100%',
      }}
    >
      {!!data.message && <NoticeBox mb={0}>{data.message}</NoticeBox>}

      <Section
        title="Burn Track"
        buttons={
          <Button
            icon="fire"
            content={burning ? 'Burning...' : 'Burn'}
            color="good"
            disabled={!canBurn}
            onClick={burn}
          />
        }
      >
        {!data.has_disc ? (
          <Box>Insert a disc to begin.</Box>
        ) : (
          <>
            {data.permission === 'none' && (
              <NoticeBox info>
                Burning requires admin approval. Press Burn to send a request.
              </NoticeBox>
            )}
            {data.permission === 'pending' && (
              <NoticeBox danger>
                Your request is awaiting admin approval.
              </NoticeBox>
            )}
            {data.permission === 'denied' && (
              <NoticeBox danger>
                Your request was denied. You can ask again in a few minutes.
              </NoticeBox>
            )}
            <LabeledList>
              <LabeledList.Item labelColor="black" label="URL">
                <Input
                  fluid
                  value={url}
                  placeholder="https://example.com/track.ogg"
                  disabled={burning}
                  onChange={(a, b) => setUrl(readString(a, b))}
                />
              </LabeledList.Item>
              <LabeledList.Item labelColor="black" label="Title">
                <Input
                  fluid
                  value={title}
                  maxLength={64}
                  disabled={burning}
                  onChange={(a, b) => setTitle(readString(a, b))}
                />
              </LabeledList.Item>
              <LabeledList.Item labelColor="black" label="Artist">
                <Input
                  fluid
                  value={artist}
                  maxLength={64}
                  disabled={burning}
                  onChange={(a, b) => setArtist(readString(a, b))}
                />
              </LabeledList.Item>
              <LabeledList.Item labelColor="black" label="Genre">
                <Input
                  fluid
                  value={genre}
                  maxLength={64}
                  disabled={burning}
                  onChange={(a, b) => setGenre(readString(a, b))}
                />
              </LabeledList.Item>
              <LabeledList.Item labelColor="black" label="Length">
                <Input
                  value={duration}
                  placeholder="3:35 or 215"
                  disabled={burning}
                  onChange={(a, b) => setDuration(readString(a, b))}
                />
              </LabeledList.Item>
            </LabeledList>
            {burning && (
              <ProgressBar mt={1} value={data.burn_progress} color="good">
                Writing to disc...
              </ProgressBar>
            )}
            {full && !burning && (
              <Box mt={1} color="bad">
                Disc is full.
              </Box>
            )}
          </>
        )}
      </Section>

      <Box style={{ flexGrow: 1, minHeight: 0 }}>
        <Section
          fill
          scrollable
          title={`Disc Contents (${tracks.length}/${data.max_tracks || 0})`}
          buttons={
            <>
              <Button
                icon="trash"
                content="Erase"
                color="bad"
                disabled={!data.has_disc || burning || tracks.length === 0}
                onClick={() => act('erase')}
              />
              <Button
                icon="eject"
                content="Eject"
                disabled={!data.has_disc}
                onClick={() => act('eject_cd')}
              />
            </>
          }
        >
          {!data.has_disc && <Box>No disc inserted.</Box>}
          {!!data.has_disc && tracks.length === 0 && <Box>Blank disc.</Box>}
          {tracks.length > 0 && (
            <Table>
              <Table.Row header>
                <Table.Cell>#</Table.Cell>
                <Table.Cell>Title</Table.Cell>
                <Table.Cell>Artist</Table.Cell>
                <Table.Cell>Genre</Table.Cell>
                <Table.Cell>Length</Table.Cell>
                <Table.Cell />
              </Table.Row>
              {tracks.map((track) => (
                <Table.Row key={track.index}>
                  <Table.Cell>{track.index}</Table.Cell>
                  <Table.Cell>{track.title}</Table.Cell>
                  <Table.Cell>{track.artist}</Table.Cell>
                  <Table.Cell>{track.genre}</Table.Cell>
                  <Table.Cell>{formatTime(track.duration)}</Table.Cell>
                  <Table.Cell>
                    <Button
                      icon="times"
                      compact
                      color="bad"
                      disabled={burning}
                      onClick={() =>
                        act('remove_track', { index: track.index })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Box>
    </Box>
  );
};
