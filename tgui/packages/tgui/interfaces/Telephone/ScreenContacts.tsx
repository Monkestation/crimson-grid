// THIS IS A DARKPACK UI FILE

import { sortBy } from 'es-toolkit';
import { useCallback, useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Collapsible,
  Icon,
  MenuBar,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { type Contact, type Data, NavigableApps } from '.';

export const ContactElement = (props: {
  contact: Contact;
  deleteIcon?: string | null;
  onClick?: () => void;
  onDelete?: () => void;
  historyIcon?: string | null;
  time?: string | null;
  historyTooltip?: string | null;
  messageIcon?: string | null;
  onMessage?: () => void;
  isUnread?: boolean;
}) => {
  const {
    contact,
    onClick,
    deleteIcon,
    onDelete,
    historyIcon,
    time,
    historyTooltip,
    messageIcon,
    onMessage,
    isUnread,
  } = props;
  const { act, data } = useBackend();

  return (
    <Stack align="center" className="Telephone__ContactsElement">
      <Stack.Item grow>
        <Stack align="center" pt={1} pb={1} pl={1} onClick={onClick}>
          <Stack.Item>
            <Box
              width={3}
              height={3}
              backgroundColor="#74b1d5"
              style={{ borderRadius: '50%' }}
              fontSize={1.5}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>{contact.name ? contact.name[0] : '?'}</Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item grow>
            <Box>{contact.name || 'Unknown Name'}</Box>
            <Box
              fontWeight={isUnread ? 'bold' : 'normal'}
              textColor={isUnread ? '#313131' : '#aaa'}
            >
              {time ? time : contact.number || 'Unknown Number'}
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {deleteIcon ? (
        <Stack.Item
          className="Telephone__ContactsElement"
          mr={1}
          onClick={onDelete}
        >
          <Icon name={deleteIcon} size={1.5} />
        </Stack.Item>
      ) : null}
      {historyIcon ? (
        <Tooltip content={historyTooltip}>
          <Icon name={historyIcon} size={1.5} pr={1} />
        </Tooltip>
      ) : null}
      {messageIcon ? (
        <Stack.Item style={{ cursor: 'pointer' }} mr={1} onClick={onMessage}>
          <Icon name={messageIcon} size={1.5} />
        </Stack.Item>
      ) : null}
    </Stack>
  );
};

export const ScreenContacts = (props: {
  enteredNumber: string;
  setEnteredNumber: React.Dispatch<React.SetStateAction<string>>;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { enteredNumber, setEnteredNumber, setApp } = props;
  const { act, data } = useBackend<Data>();
  const { my_number, published_numbers, our_contacts, our_blocked_contacts } =
    data;

  const [showSettings, setShowSettings] = useState(false);
  const [openMenuBar, setOpenMenuBar] = useState<string | null>(null);
  const [openOnHover, setOpenOnHover] = useState(false);

  const number_filter = useCallback(
    (contact: Contact) => contact.number !== my_number,
    [my_number],
  );

  const sorted_published_numbers = useMemo(
    () =>
      sortBy(published_numbers.filter(number_filter), [
        (contact: Contact) => contact.name,
      ]),
    [published_numbers, number_filter],
  );
  const sorted_contacts = useMemo(
    () =>
      sortBy(our_contacts.filter(number_filter), [
        (contact: Contact) => contact.name,
      ]),
    [our_contacts, number_filter],
  );
  const sorted_blocked_contacts = useMemo(
    () => sortBy(our_blocked_contacts, [(contact: Contact) => contact.name]),
    [our_blocked_contacts],
  );

  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item>
        <Box
          backgroundColor="orange"
          textColor="#fff"
          pl={1}
          pb={1.5}
          pt={1.5}
          pr={1}
          verticalAlign="middle"
          fontSize={1.5}
        >
          <Stack align="center">
            <MenuBar>
              <MenuBar.Dropdown
                display={<Icon name="gear" />}
                entry="publishmenu"
                openMenuBar={openMenuBar}
                setOpenMenuBar={setOpenMenuBar}
                openOnHover={openOnHover}
                setOpenOnHover={setOpenOnHover}
                openWidth="22rem"
              >
                <MenuBar.Dropdown.MenuItem
                  displayText={
                    data.sim_published ? 'Unpublish number' : 'Publish number'
                  }
                  onClick={() => {
                    act(
                      data.sim_published
                        ? 'unpublish_number'
                        : 'publish_number',
                    );
                  }}
                />
                <MenuBar.Dropdown.MenuItem
                  displayText={'Add Contact'}
                  onClick={() => {
                    act('add_contact');
                  }}
                />
                <MenuBar.Dropdown.MenuItem
                  displayText={'Remove Contact'}
                  onClick={() => {
                    act('remove_contact');
                  }}
                />
              </MenuBar.Dropdown>
            </MenuBar>
            <Stack.Item grow>Contacts</Stack.Item>
          </Stack>
          <Stack.Item grow fontSize={1}>
            {data.sim_published_name
              ? `Published as: ${data.sim_published_name}`
              : 'Currently Unpublished'}
          </Stack.Item>
        </Box>
      </Stack.Item>
      {showSettings ? (
        <Stack.Item grow mb={6} mt={0}>
          <Box p={1} backgroundColor="#0003">
            This Phone&apos;s Number: {my_number}
          </Box>
        </Stack.Item>
      ) : (
        <Stack.Item grow mt={-1} style={{ overflowY: 'scroll' }}>
          <Collapsible open={true} color="orange" title="My Contacts" ml={-0.5}>
            {sorted_contacts.map((contact) => (
              <ContactElement
                contact={contact}
                key={contact.name + contact.number}
                deleteIcon="trash"
                messageIcon="comment"
                onClick={() => {
                  setEnteredNumber(contact.number);
                  setApp(NavigableApps.Phone);
                }}
                onDelete={() => act('remove_contact', { name: contact.name })}
                onMessage={() => {
                  setEnteredNumber(contact.number);
                  setApp(NavigableApps.Messages); // opens a text conversation
                }}
              />
            ))}
          </Collapsible>
          <Collapsible color="orange" title="Published Numbers" ml={-0.5}>
            {sorted_published_numbers.map((contact) => (
              <ContactElement
                contact={contact}
                key={contact.name + contact.number}
                messageIcon="comment"
                onClick={() => {
                  setEnteredNumber(contact.number);
                  setApp(NavigableApps.Phone);
                }}
                onMessage={() => {
                  setEnteredNumber(contact.number);
                  setApp(NavigableApps.Messages);
                }}
              />
            ))}
          </Collapsible>
          <Collapsible color="orange" title="Blocked Numbers" ml={-0.5}>
            {sorted_blocked_contacts.map((contact) => (
              <ContactElement
                contact={contact}
                key={contact.name + contact.number}
                deleteIcon="unlock"
                onClick={() => {
                  setEnteredNumber(contact.number);
                  setApp(NavigableApps.Phone);
                }}
                onDelete={() => act('unblock', { name: contact.name })}
              />
            ))}
          </Collapsible>
        </Stack.Item>
      )}
    </Stack>
  );
};
