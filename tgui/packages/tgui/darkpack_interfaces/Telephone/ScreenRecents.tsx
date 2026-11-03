// THIS IS A DARKPACK UI FILE
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui-core/components';

import { type Data, NavigableApps } from '.';
import { ContactElement } from './ScreenContacts';

export const ScreenRecents = (props: {
  enteredNumber: string;
  setEnteredNumber: React.Dispatch<React.SetStateAction<string>>;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { enteredNumber, setEnteredNumber, setApp } = props;
  const { act, data } = useBackend<Data>();
  const { phone_history } = data;

  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item>
        <Box
          backgroundColor="#028ae4"
          textColor="#fff"
          pl={1}
          pb={1.5}
          pt={1.5}
          pr={1}
          verticalAlign="middle"
          fontSize={1.5}
        >
          <Stack align="center">
            <Stack.Item grow>Call History</Stack.Item>
            <Stack.Item
              style={{ cursor: 'pointer' }}
              onClick={() => act('delete_call_history')}
            >
              <Icon name="trash" />
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      <Stack.Item grow mb={6} mt={0} style={{ overflowY: 'scroll' }}>
        {phone_history.map((contact) => (
          <ContactElement
            contact={contact}
            key={contact.name + contact.number}
            onClick={() => {
              setEnteredNumber(contact.number);
              setApp(NavigableApps.Phone);
            }}
            historyIcon={contact.type}
            historyTooltip={contact.type_tooltip}
            time={contact.time}
          />
        ))}
      </Stack.Item>
    </Stack>
  );
};
