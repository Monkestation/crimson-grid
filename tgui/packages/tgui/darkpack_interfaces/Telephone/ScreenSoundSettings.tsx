// THIS IS A DARKPACK UI FILE
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Icon, Stack } from 'tgui-core/components';
import type { Data } from '.';
import { NavigableApps } from '.';

export const ScreenSoundSettings = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();
  const { vibration, ringer } = data;
  const [volume, setVolume] = useState<number>(70);

  return (
    <Stack vertical fill backgroundColor="#ffffff" textColor="#000">
      <Stack.Item backgroundColor="#5f5f5f" textColor="#fff" p={1}>
        <Stack align="center">
          <Icon
            name="arrow-left"
            onClick={() => setApp(NavigableApps.Settings)}
            style={{ cursor: 'pointer' }}
          />
          <Stack.Item grow ml={1}>
            Sound & Vibration
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item
        grow
        overflowY="auto"
        style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
      >
        <Stack vertical mb={5}>
          <Stack.Item p={1.5} ml={2} mr={2}>
            <Stack align="center">
              <Stack.Item width={2} mr={1.5}>
                <Icon name="mobile" size={1.5} />
              </Stack.Item>
              <Stack.Item grow>
                <Stack vertical>
                  <Stack.Item fontSize={1.1} fontWeight="bold">
                    Vibration
                  </Stack.Item>
                  <Stack.Item fontSize={0.9} mt={-0.5} opacity={0.7}>
                    Enable or Disable Vibration
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item
                onClick={() => act('vibration')}
                style={{
                  cursor: 'pointer',
                  padding: '0.4em 0.8em',
                  backgroundColor: vibration ? '#4caf50' : '#ccc',
                  borderRadius: '4px',
                  color: '#fff',
                  fontSize: '0.85em',
                  userSelect: 'none',
                }}
              >
                {vibration ? 'On' : 'Off'}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item p={1.5} ml={2} mr={2}>
            <Stack align="center">
              <Stack.Item width={2} ml={0.3} mr={1.5}>
                <Icon name="moon" size={1.5} />
              </Stack.Item>
              <Stack.Item grow>
                <Stack vertical>
                  <Stack.Item fontSize={1.1} fontWeight="bold">
                    Silent Mode
                  </Stack.Item>
                  <Stack.Item fontSize={0.9} mt={-0.5} opacity={0.7}>
                    Silences ringtone
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item
                onClick={() => act('silent')}
                style={{
                  cursor: 'pointer',
                  padding: '0.4em 0.8em',
                  backgroundColor: ringer ? '#ccc' : '#4caf50',
                  borderRadius: '4px',
                  color: '#fff',
                  fontSize: '0.85em',
                  userSelect: 'none',
                }}
              >
                {ringer ? 'Off' : 'On'}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item p={1.5} ml={2} mr={2}>
            <Stack align="center">
              <Stack.Item width={2} ml={-0.5} mr={1.5}>
                <Icon name="bell-slash" size={1.5} />
              </Stack.Item>
              <Stack.Item grow>
                <Stack vertical>
                  <Stack.Item fontSize={1.1} fontWeight="bold">
                    Do Not Disturb
                  </Stack.Item>
                  <Stack.Item
                    fontSize={0.9}
                    mt={-0.5}
                    opacity={0.7}
                    style={{ minHeight: '1.2em' }}
                  >
                    Disables most phone sounds
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item
                onClick={() => {
                  const dndActive = !vibration && !ringer;
                  if (dndActive) {
                    if (!vibration) act('vibration');
                    if (!ringer) act('silent');
                  } else {
                    if (vibration) act('vibration');
                    if (ringer) act('silent');
                  }
                }}
                style={{
                  cursor: 'pointer',
                  padding: '0.4em 0.8em',
                  backgroundColor: !vibration && !ringer ? '#4caf50' : '#ccc',
                  borderRadius: '4px',
                  color: '#fff',
                  fontSize: '0.85em',
                  userSelect: 'none',
                }}
              >
                {!vibration && !ringer ? 'On' : 'Off'}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          {/* CRIMSON EDIT ADDITION START */}
          <Stack.Item
            p={1.5}
            ml={2}
            mr={2}
            className="Telephone__ContactsElement"
            onClick={() => setApp(NavigableApps.SoundSettingsNotificationSound)}
          >
            <Stack align="center">
              <Stack.Item width={2} ml={-0.5} mr={1.5}>
                <Icon name="bell" size={1.5} />
              </Stack.Item>
              <Stack.Item grow>
                <Stack vertical>
                  <Stack.Item fontSize={1.1} fontWeight="bold">
                    Notification Sound
                  </Stack.Item>
                  <Stack.Item
                    fontSize={0.9}
                    mt={-0.5}
                    opacity={0.7}
                    style={{ minHeight: '1.2em' }}
                  >
                    Set your notification sound when you get a message
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          {/* CRIMSON EDIT ADDITION END */}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
