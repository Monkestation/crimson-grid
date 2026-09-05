// THIS IS A DARKPACK UI FILE
import { Box, Icon, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import type { Data } from '.';

const FakeCallingControls = (props) => {
  const { act, data } = useBackend<Data>();
  const { speaker_mode, muted, on_hold} = data;

  return (
    <Box className="Telephone__CallOptionsGrid" textAlign="center">
      {/* Speaker */}
      <Box>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon
              name="volume-high"
              size={2}
              color={speaker_mode ? 'green' : ''}
              onClick={() => {
                act('speaker');
              }}
              style={{
                borderRadius: '50%',
                cursor: 'pointer',
              }}/>
            </Stack.Item>
          </Stack>
        </Box>
        Speaker
      </Box>
      {/* Mute */}
      <Box>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon
              name="microphone-slash"
              size={2}
              color={muted ? 'green' : ''}
              onClick={() => {
                act('mute');
              }}
              style={{
                borderRadius: '50%',
                cursor: 'pointer',
              }}/>
            </Stack.Item>
          </Stack>
        </Box>
        Mute
      </Box>
      {/* Keypad */}
      <Box>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon name="keyboard" size={2} />
            </Stack.Item>
          </Stack>
        </Box>
        Keypad
      </Box>
      {/* Hold call */}
      <Box>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon
              name="fa-pause"
              size={2}
              color={on_hold ? 'green' : ''}
              onClick={() => {
                act('hold_call');
              }}
              style={{
                borderRadius: '50%',
                cursor: 'pointer',
              }}/>
            </Stack.Item>
          </Stack>
        </Box>
        Hold call
      </Box>
    </Box>
  );
};

// This is separate from ScreenInCall because it's too difficult
// to manage a three-variable state machine in one component
export const ScreenCalling = (props) => {
  const { act, data } = useBackend<Data>();
  const { calling_user, city_name } = data;

  return (
    <Stack fill vertical className="Telephone__PhoneScreen">
      <Stack.Item>
        <Box mt={2} ml={2}>
          Calling...
        </Box>
      </Stack.Item>
      <Stack.Item height={15}>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            <Box bold fontSize={2} textAlign="center">
              {calling_user}
            </Box>
            <Box textAlign="center">{city_name}</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Box height={15.6}></Box>
      </Stack.Item>
      <Stack.Item>
        <Stack mt={-3} fill align="center" justify="center">
          <Stack.Item>
            <Box
              backgroundColor="#fff"
              style={{
                borderRadius: '50%',
                cursor: 'pointer',
              }}
              height={4}
              width={4}
              onClick={() => {
                act('hang');
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="phone" textColor="red" size={2} rotation={135} />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const ScreenInCall = (props) => {
  const { act, data } = useBackend<Data>();
  const { calling_user, phone_ringing, phone_in_call, city_name } = data;

  return (
    <Stack fill vertical className="Telephone__PhoneScreen">
      <Stack.Item>
        <Box mt={2} ml={2}>
          {phone_ringing ? 'Call From' : 'Online'}
        </Box>
      </Stack.Item>
      <Stack.Item height={15}>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            <Box bold fontSize={2} textAlign="center">
              {calling_user}
            </Box>
            <Box textAlign="center">{city_name}</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        {phone_in_call ? <FakeCallingControls phone_calling /> : <Box height={16}></Box>}
      </Stack.Item>
      <Stack.Item>
        <Stack mt={-3} fill align="center" justify="center">
          {phone_ringing ? (
            <Stack.Item>
              <Box
                backgroundColor="#fff"
                style={{
                  borderRadius: '50%',
                  cursor: 'pointer',
                }}
                height={4}
                width={4}
                onClick={() => act('accept')}
              >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="phone" textColor="green" size={2} />
                </Stack.Item>
              </Stack>
              </Box>
            </Stack.Item>
          ) : null}
          <Stack.Item>
            <Box
              backgroundColor="#fff"
              style={{
                borderRadius: '50%',
                cursor: 'pointer',
              }}
              height={4}
              width={4}
              onClick={() => {
                phone_ringing ? act('decline'): act('hang');
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="phone" textColor="red" size={2} rotation={135} />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
