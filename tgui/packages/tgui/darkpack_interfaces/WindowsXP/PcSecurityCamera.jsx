import { useEffect, useLayoutEffect, useRef, useState } from 'react';
import {
  Box,
  ByondUi,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const rectsOverlap = (a, b) =>
  a.x < b.x + b.w && a.x + a.w > b.x && a.y < b.y + b.h && a.y + a.h > b.y;

export const PcSecurityCamera = (props, context) => {
  const { desktopRef, coverRects = [] } = props;
  const { act, data } = useProgram(props.programId, context);
  const cameras = Array.isArray(data.cameras) ? data.cameras : [];
  const mapRef = data.mapRef;
  const activeCamera = data.activeCamera;

  const [searchText, setSearchText] = useState('');
  const [activeCamRef, setActiveCamRef] = useState(null);
  const [covered, setCovered] = useState(false);

  const feedRef = useRef(null);
  const lastSent = useRef('');

  useEffect(() => {
    if (activeCamera?.ref && !activeCamRef) {
      setActiveCamRef(activeCamera.ref);
    }
  }, [activeCamera]);

  useLayoutEffect(() => {
    const el = feedRef.current;
    if (!el) {
      return;
    }
    const r = el.getBoundingClientRect();
    const d = desktopRef?.current?.getBoundingClientRect() || {
      left: 0,
      top: 0,
      width: window.innerWidth,
      height: window.innerHeight,
    };
    const feed = {
      x: r.left - d.left,
      y: r.top - d.top,
      w: r.width,
      h: r.height,
    };

    const outside =
      feed.x < 0 ||
      feed.y < 0 ||
      feed.x + feed.w > d.width ||
      feed.y + feed.h > d.height;
    const nowCovered = outside || coverRects.some((c) => rectsOverlap(feed, c));
    if (nowCovered !== covered) {
      setCovered(nowCovered);
      return;
    }
    if (nowCovered || !mapRef) {
      lastSent.current = '';
      return;
    }

    const ratio = window.devicePixelRatio || 1;
    const pos = `${Math.round(r.left * ratio)},${Math.round(r.top * ratio)}`;
    const size = `${Math.round(r.width * ratio)}x${Math.round(
      r.height * ratio,
    )}`;
    const key = `${mapRef}|${pos}|${size}`;
    if (key === lastSent.current) {
      return;
    }
    lastSent.current = key;
    window.Byond?.winset?.(mapRef, { pos, size });
  });

  const filteredCameras = cameras.filter((cam) =>
    cam.name.toLowerCase().includes(searchText.toLowerCase()),
  );

  const selectedCamera =
    cameras.find((cam) => cam.ref === activeCamRef) ||
    activeCamera ||
    cameras[0];

  return (
    <Stack fill>
      <Stack.Item basis="35%">
        <Stack fill vertical>
          <Stack.Item>
            <Input
              fluid
              placeholder="Search cameras..."
              value={searchText}
              onInput={(e, v) => setSearchText(v ?? e?.target?.value ?? '')}
              onChange={(e, v) => setSearchText(v ?? e?.target?.value ?? '')}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              {filteredCamerasList(
                filteredCameras,
                activeCamRef || selectedCamera?.ref,
                setActiveCamRef,
                act,
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item grow>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item>
              {selectedCamera?.status ? (
                <NoticeBox info>
                  {selectedCamera.name} [Signal Active]
                </NoticeBox>
              ) : (
                <NoticeBox danger>No input signal</NoticeBox>
              )}
            </Stack.Item>

            <Stack.Item
              grow
              style={{
                background: '#000',
                position: 'relative',
                overflow: 'hidden',
                minHeight: 250,
              }}
            >
              <div
                ref={feedRef}
                style={{
                  position: 'absolute',
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                }}
              >
                {mapRef && !covered ? (
                  <ByondUi
                    height="100%"
                    width="100%"
                    params={{
                      id: mapRef,
                      type: 'map',
                    }}
                  />
                ) : (
                  <Box p={2} color="label">
                    {covered
                      ? 'Feed paused (window obscured)'
                      : 'Loading camera feed...'}
                  </Box>
                )}
              </div>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const filteredCamerasList = (cameras, activeRef, setActiveRef, act) => {
  if (cameras.length === 0) {
    return <Box p={1}>No cameras found.</Box>;
  }

  return cameras.map((cam) => (
    <Box
      key={cam.ref}
      p={1}
      mb={0.5}
      style={{
        background: activeRef === cam.ref ? '#cce0ff' : 'transparent',
        cursor: 'pointer',
        borderBottom: '1px solid #ddd',
        color: '#000',
      }}
      onClick={() => {
        setActiveRef(cam.ref);
        act('switch_camera', { camera: cam.ref });
      }}
    >
      <Box fontWeight="bold">{cam.name}</Box>
    </Box>
  ));
};
