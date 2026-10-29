import { Box, Button, NoticeBox } from 'tgui-core/components';
import { NightcrawlerFeed } from './NightcrawlerFeed';
import { PcRichText } from './PcRichText';
import { useProgram } from './useProgram';

const C = {
  bg: '#0b0608',
  panel: '#150b0e',
  border: '#3a1218',
  blood: '#a3121f',
  text: '#d8cfc4',
  muted: '#8a7f78',
};

const serif = { fontFamily: 'Georgia, "Times New Roman", serif' };

const Story = ({ s }) => (
  <Box
    mb={1.5}
    p={1}
    style={{
      background: C.panel,
      border: `1px solid ${C.border}`,
      color: C.text,
      ...serif,
    }}
  >
    {!!s.headline && (
      <Box bold mb={0.5} style={{ fontSize: '16px', color: '#fff' }}>
        {s.headline}
      </Box>
    )}
    <Box mb={0.5} style={{ fontSize: '11px', color: C.muted }}>
      By {s.author} · {s.time}
    </Box>
    <Box style={{ display: 'flex', gap: 10, alignItems: 'flex-start' }}>
      {!!s.photo && (
        <Box style={{ flex: '0 0 auto', fontSize: '10px', color: C.muted }}>
          <img
            src={s.photo}
            alt=""
            style={{
              maxWidth: 192,
              maxHeight: 192,
              display: 'block',
              border: `1px solid ${C.border}`,
            }}
          />
          {s.caption}
        </Box>
      )}
      <Box style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
        <PcRichText text={s.body} />
      </Box>
    </Box>
  </Box>
);

const SectionTitle = ({ children, live }) => (
  <Box
    bold
    mb={1}
    style={{
      color: live ? '#e04050' : C.blood,
      fontSize: '13px',
      letterSpacing: '2px',
      textTransform: 'uppercase',
      ...serif,
    }}
  >
    {children}
  </Box>
);

export const PcNightcrawler = (props, context) => {
  const { desktopRef, coverRects = [] } = props;
  const { act, data } = useProgram(props.programId, context);
  const channels = Array.isArray(data.channels) ? data.channels : [];
  const stories = Array.isArray(data.stories) ? data.stories : [];
  const liveCams = Array.isArray(data.live_cameras) ? data.live_cameras : [];

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        height: '100%',
        width: '100%',
        background: C.bg,
      }}
    >
      <div
        style={{
          flex: '0 0 auto',
          padding: '8px',
          borderBottom: `2px solid ${C.blood}`,
          fontSize: '20px',
          fontWeight: 'bold',
          letterSpacing: '3px',
          color: C.blood,
          textTransform: 'uppercase',
          ...serif,
        }}
      >
        Nightcrawler
      </div>

      <div style={{ flex: '1 1 auto', display: 'flex', minHeight: 0 }}>
        <div style={{ flex: '0 0 45%', overflowY: 'auto', minWidth: 0 }}>
          <Box p={1}>
            <SectionTitle live={liveCams.length > 0}>
              {liveCams.length > 0 ? '● Live' : 'Live'}
            </SectionTitle>
            {liveCams.length === 0 ? (
              <NoticeBox danger>Nobody is broadcasting right now.</NoticeBox>
            ) : (
              <>
                {liveCams.length > 1 && (
                  <Box mb={1}>
                    {liveCams.map((cam) => (
                      <Button
                        key={cam.ref}
                        icon="video"
                        selected={data.activeCamera?.ref === cam.ref}
                        onClick={() =>
                          act('switch_camera', { camera: cam.ref })
                        }
                      >
                        {cam.name}
                      </Button>
                    ))}
                  </Box>
                )}
                <NightcrawlerFeed
                  mapRef={data.mapRef}
                  desktopRef={desktopRef}
                  coverRects={coverRects}
                />
              </>
            )}
          </Box>
        </div>

        <div
          style={{
            flex: '1 1 auto',
            overflowY: 'auto',
            minWidth: 0,
            borderLeft: `1px solid ${C.border}`,
          }}
        >
          <Box p={1}>
            {!data.channel ? (
              <>
                <SectionTitle>Sections</SectionTitle>
                {channels.length === 0 && (
                  <Box color="label">Nothing has been printed yet.</Box>
                )}
                {channels.map((ch) => (
                  <Box key={ch.id} mb={0.5}>
                    <Button
                      fluid
                      icon="folder-open"
                      onClick={() => act('open_channel', { id: ch.id })}
                    >
                      {ch.name} ({ch.count})
                    </Button>
                    {!!ch.desc && (
                      <Box ml={1} style={{ fontSize: '11px', color: C.muted }}>
                        {ch.desc}
                      </Box>
                    )}
                  </Box>
                ))}
              </>
            ) : (
              <>
                <Box mb={1}>
                  <Button icon="arrow-left" onClick={() => act('home')}>
                    Sections
                  </Button>
                  <Box
                    inline
                    ml={1}
                    bold
                    style={{ color: C.blood, fontSize: '15px', ...serif }}
                  >
                    {data.channel.name}
                  </Box>
                </Box>
                {stories.length === 0 && (
                  <Box color="label">No stories in this section.</Box>
                )}
                {stories.map((s) => (
                  <Story key={s.id} s={s} />
                ))}
              </>
            )}
          </Box>
        </div>
      </div>
    </div>
  );
};
