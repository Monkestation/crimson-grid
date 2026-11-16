// THIS IS A CRIMSON UI FILE

import { useBackend } from 'tgui/backend';
import { Icon, Stack } from 'tgui-core/components';
import type { Data } from '.';
import { NavigableApps } from '.';

export const ScreenSoundSettingsNotificationSound = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();

  const { notification_sound, notification_sounds } = data;

  return (
    <Stack vertical fill backgroundColor="#ffffff" textColor="#000">
      <Stack.Item backgroundColor="#5f5f5f" textColor="#fff" p={1}>
        <Stack align="center">
          <Icon
            name="arrow-left"
            style={{ cursor: 'pointer' }}
            onClick={() => setApp(NavigableApps.SoundSettings)}
          />
          <Stack.Item grow ml={1}>
            Notification Sound
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item
        grow
        overflowY="auto"
        style={{
          scrollbarWidth: 'none',
          msOverflowStyle: 'none',
        }}
      >
        <Stack vertical mb="24px">
          {notification_sounds.map((sound) => {
            const selected = sound === notification_sound;

            return (
              <Stack.Item
                key={sound}
                p={1.5}
                pl={2}
                pr={2}
                onClick={() => act('set_notification_sound', { sound })}
                style={{
                  cursor: 'pointer',
                  borderBottom: '1px solid #e6e6e6',
                }}
              >
                <Stack align="center">
                  <Stack.Item width={2} mr={1.5}>
                    <Icon
                      name={selected ? 'bell' : 'music'}
                      color={selected ? '#1976d2' : '#777'}
                    />
                  </Stack.Item>

                  <Stack.Item grow>
                    <Stack vertical>
                      <Stack.Item
                        fontSize={1.05}
                        fontWeight={selected ? 'bold' : undefined}
                      >
                        {sound}
                      </Stack.Item>

                      {selected && (
                        <Stack.Item fontSize={0.85} mt={-0.4} color="#1976d2">
                          Current notification sound
                        </Stack.Item>
                      )}
                    </Stack>
                  </Stack.Item>

                  <Stack.Item width={2} textAlign="right">
                    {selected && <Icon name="check" color="#1976d2" />}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            );
          })}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
