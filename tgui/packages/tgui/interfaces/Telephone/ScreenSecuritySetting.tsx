// THIS IS A DARKPACK UI FILE
import { useBackend } from 'tgui/backend';
import { Icon, Stack } from 'tgui-core/components';
import type { Data } from '.';
import { NavigableApps } from '.';

export const ScreenSecuritySetting = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();
  const { password_enabled } = data;

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
            Security
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
              <Stack.Item width={2} ml={0.3} mr={1.5}>
                <Icon name="unlock" size={1.5} />
              </Stack.Item>
              <Stack.Item grow>
                <Stack vertical>
                  <Stack.Item fontSize={1.1} fontWeight="bold">
                    Require Password
                  </Stack.Item>
                  <Stack.Item fontSize={0.9} mt={-0.5} opacity={0.7}>
                    Require a password to unlock
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item
                onClick={() => act('toggle_password_lock')}
                style={{
                  cursor: 'pointer',
                  padding: '0.4em 0.8em',
                  backgroundColor: password_enabled ? '#4caf50' : '#ccc',
                  borderRadius: '4px',
                  color: '#fff',
                  fontSize: '0.85em',
                  userSelect: 'none',
                }}
              >
                {password_enabled ? 'On' : 'Off'}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item
            p={1.5}
            ml={2}
            mr={2}
            className="Telephone__ContactsElement"
            onClick={() => act('change_password')}
          >
            <Stack align="center">
              <Stack.Item width={2} ml={0.3} mr={1.5}>
                <Icon name="key" size={1.5} />
              </Stack.Item>
              <Stack.Item grow>
                <Stack vertical>
                  <Stack.Item fontSize={1.1} fontWeight="bold">
                    Change Password
                  </Stack.Item>
                  <Stack.Item
                    fontSize={0.9}
                    mt={-0.5}
                    opacity={0.7}
                    style={{ minHeight: '1.2em' }}
                  >
                    Set a new password pin
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
