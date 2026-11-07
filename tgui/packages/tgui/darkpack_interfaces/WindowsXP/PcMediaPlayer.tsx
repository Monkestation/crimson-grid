import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Slider,
  Table,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

type Track = {
  ref: string;
  title: string;
  artist: string;
  genre: string;
  duration: number;
};

const readNumber = (a: any, b: any): number | null => {
  for (const v of [b, a]) {
    if (typeof v === 'number') return v;
    if (typeof v === 'string' && v !== '' && !Number.isNaN(Number(v))) {
      return Number(v);
    }
  }
  if (a && typeof a === 'object' && a.target != null) {
    return Number(a.target.value);
  }
  return null;
};

const formatTime = (seconds: number) => {
  const s = Math.max(0, Math.floor(seconds));
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`;
};

export const PcMediaPlayer = (props, context) => {
  const { act, data: raw } = useProgram(props.programId, context);
  const data = raw.media_player || raw;

  const tracks: Track[] = data.tracks || [];

  const nowPlaying: Track | undefined =
    data.now_playing && typeof data.now_playing === 'object'
      ? data.now_playing
      : tracks.find((t) => t.ref === data.now_playing);

  const [elapsed, setElapsed] = useState<number>(data.elapsed || 0);
  useEffect(() => {
    setElapsed(data.elapsed || 0);
  }, [data.elapsed, data.now_playing, data.playing]);
  useEffect(() => {
    if (!data.playing) return;
    const timer = setInterval(() => setElapsed((e) => e + 1), 1000);
    return () => clearInterval(timer);
  }, [data.playing, data.now_playing]);

  const duration = nowPlaying?.duration || 0;
  const progress = duration > 0 ? Math.min(elapsed / duration, 1) : 0;

  return (
    <Box
      style={{
        display: 'flex',
        flexDirection: 'column',
        height: '100%',
      }}
    >
      <Section title="Now Playing">
        {nowPlaying ? (
          <Box>
            <Box bold fontSize="1.2em">
              {nowPlaying.title}
            </Box>
            <Box mb={1}>
              {nowPlaying.artist} &middot; {nowPlaying.genre}
            </Box>
            <ProgressBar value={progress}>
              {formatTime(elapsed)} / {formatTime(duration)}
            </ProgressBar>
          </Box>
        ) : (
          <Box>Nothing playing.</Box>
        )}
      </Section>

      <Section
        title="Controls"
        buttons={
          <>
            <Button
              icon="play"
              content="Play"
              color="good"
              disabled={!data.has_disc || tracks.length === 0}
              onClick={() => act('play')}
            />
            <Button
              icon="stop"
              content="Stop"
              color="bad"
              disabled={!data.playing}
              onClick={() => act('stop')}
            />
          </>
        }
      >
        <LabeledList>
          <LabeledList.Item labelColor="black" label="Volume">
            <Slider
              value={data.volume}
              minValue={0}
              maxValue={100}
              step={1}
              stepPixelSize={2}
              unit="%"
              onChange={(a, b) => {
                const v = readNumber(a, b);
                if (v !== null) act('set_volume', { volume: v });
              }}
            />
          </LabeledList.Item>
          <LabeledList.Item labelColor="black" label="Range">
            <Slider
              value={data.max_distance}
              minValue={2}
              maxValue={20}
              step={1}
              stepPixelSize={10}
              unit="tiles"
              onChange={(a, b) => {
                const v = readNumber(a, b);
                if (v !== null) act('set_range', { range: v });
              }}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>

      <Box style={{ flexGrow: 1, minHeight: 0 }}>
        <Section
          fill
          scrollable
          title="Disc"
          buttons={
            <Button
              icon="eject"
              content="Eject"
              disabled={!data.has_disc}
              onClick={() => act('eject_cd')}
            />
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
                <Table.Cell>Length</Table.Cell>
                <Table.Cell />
              </Table.Row>
              {tracks.map((track, i) => {
                const isCurrent =
                  nowPlaying && nowPlaying.ref === track.ref && data.playing;
                return (
                  <Table.Row
                    key={track.ref}
                    className={isCurrent ? 'color-good' : undefined}
                  >
                    <Table.Cell>{i + 1}</Table.Cell>
                    <Table.Cell>
                      <Box bold={isCurrent}>{track.title}</Box>
                    </Table.Cell>
                    <Table.Cell>{track.artist}</Table.Cell>
                    <Table.Cell>{formatTime(track.duration)}</Table.Cell>
                    <Table.Cell>
                      <Button
                        icon="play"
                        compact
                        disabled={isCurrent}
                        onClick={() => act('play', { track: track.ref })}
                      />
                    </Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          )}
        </Section>
      </Box>
    </Box>
  );
};
