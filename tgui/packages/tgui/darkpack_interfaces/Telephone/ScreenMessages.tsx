// THIS IS A DARKPACK UI FILE
import { useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui-core/components';
import type { Data, NavigableApps } from '.';
import { ContactElement } from './ScreenContacts';

export const Keyboard = (props: { onClick?: (keyPressed: string) => void }) => {
  const { onClick } = props;
  const { act, data } = useBackend<Data>();
  const [caps, setCaps] = useState(false);
  const [showSymbols, setShowSymbols] = useState(false);
  const [keyboardVisible, setKeyboardVisible] = useState(true);
  const keyHandler = (key: string) => {
    if (onClick) {
      onClick(key);
      // CRIMSON EDIT ADDITION START
      let sound: string | undefined;
      switch (key) {
        case 'Backspace':
          sound = 'del';
          break;
        case ' ':
          sound = 'spb';
          break;
        case 'Enter':
          sound = 'ret';
          break;
        default:
          sound = undefined;
      }
      // CRIMSON EDIT ADDITION END
      act('keyboard_click', { sound }); // CRIMSON EDIT ADDITION - ORIGINAL: act('keyboard_click');
    }
  };

  // keyboard rows
  const letters_row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  const letters_row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  const letters_row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  const symbols_row1 = ['[', ']', '{', '}', '#', '%', '^', '*', '+', '='];
  const symbols_row2 = ['_', '\\', '|', '~', '<', '>', '€', '£', '¥'];
  const symbols_row3 = ['`', ';', ':', '"', "'", '/', '?'];

  const row1 = showSymbols ? symbols_row1 : letters_row1;
  const row2 = showSymbols ? symbols_row2 : letters_row2;
  const row3 = showSymbols ? symbols_row3 : letters_row3;

  const numberKeyboard = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  const symbolKeyboard = ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')'];
  const activeKeyboard = showSymbols ? symbolKeyboard : numberKeyboard; //swap the above keyboard rows

  return (
    <Stack vertical fill backgroundColor="#aed7ff" pt={1} pb={1}>
      <Stack.Item>
        <Stack align="center" justify="center">
          <Box
            width={1.8}
            height={2}
            backgroundColor="#beecff"
            textColor="#000"
            fontSize={1.2}
            style={{
              borderRadius: '4px',
              cursor: 'pointer',
            }}
            onClick={() => setKeyboardVisible(!keyboardVisible)}
          >
            <Stack fill align="center" justify="center">
              <Stack.Item>
                <Icon name={keyboardVisible ? 'chevron-down' : 'chevron-up'} />
              </Stack.Item>
            </Stack>
          </Box>
        </Stack>
      </Stack.Item>
      {keyboardVisible && (
        <>
          <Stack.Item>
            <Stack align="center" justify="center">
              {activeKeyboard.map((numberKey) => (
                <Stack.Item
                  key={numberKey}
                  onClick={() => keyHandler(numberKey)}
                  style={{ cursor: 'pointer' }}
                >
                  <Box
                    inline
                    width={1.8}
                    height={2}
                    backgroundColor="#beecff"
                    textColor="#000"
                    fontSize={1.2}
                    style={{
                      borderRadius: '4px',
                    }}
                  >
                    <Stack fill align="center" justify="center">
                      <Stack.Item>{numberKey}</Stack.Item>
                    </Stack>
                  </Box>
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack fill align="center" justify="center">
              {row1.map((key) => {
                if (!caps) {
                  key = key.toLowerCase();
                }
                return (
                  <Stack.Item
                    key={key}
                    onClick={() => keyHandler(key)}
                    style={{ cursor: 'pointer' }}
                  >
                    <Box
                      inline
                      width={1.8}
                      height={2.4}
                      backgroundColor="#d5ffff"
                      textColor="#000"
                      fontSize={1.2}
                      style={{
                        borderRadius: '4px',
                      }}
                    >
                      <Stack fill align="center" justify="center">
                        <Stack.Item>{key}</Stack.Item>
                      </Stack>
                    </Box>
                  </Stack.Item>
                );
              })}
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack fill align="center" justify="center">
              {row2.map((key) => {
                if (!caps) {
                  key = key.toLowerCase();
                }
                return (
                  <Stack.Item
                    key={key}
                    onClick={() => keyHandler(key)}
                    style={{ cursor: 'pointer' }}
                  >
                    <Box
                      inline
                      width={1.8}
                      height={2.4}
                      backgroundColor="#d5ffff"
                      textColor="#000"
                      fontSize={1.2}
                      style={{
                        borderRadius: '4px',
                      }}
                    >
                      <Stack fill align="center" justify="center">
                        <Stack.Item>{key}</Stack.Item>
                      </Stack>
                    </Box>
                  </Stack.Item>
                );
              })}
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack fill align="center" justify="center">
              <Stack.Item>
                <Box
                  inline
                  width={3}
                  height={2.4}
                  backgroundColor="#beecff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                    cursor: 'pointer',
                  }}
                  onClick={() => setCaps((x) => !x)}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>
                      <Icon name="arrow-up" color={caps ? 'blue' : 'black'} />
                    </Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
              {row3.map((key) => {
                if (!caps) {
                  key = key.toLowerCase();
                }
                return (
                  <Stack.Item
                    key={key}
                    onClick={() => keyHandler(key)}
                    style={{ cursor: 'pointer' }}
                  >
                    <Box
                      inline
                      width={1.8}
                      height={2.4}
                      backgroundColor="#d5ffff"
                      textColor="#000"
                      fontSize={1.2}
                      style={{
                        borderRadius: '4px',
                      }}
                    >
                      <Stack fill align="center" justify="center">
                        <Stack.Item>{key}</Stack.Item>
                      </Stack>
                    </Box>
                  </Stack.Item>
                );
              })}
              <Stack.Item
                style={{ cursor: 'pointer' }}
                onClick={() => keyHandler('Backspace')}
              >
                <Box
                  inline
                  width={3}
                  height={2.4}
                  backgroundColor="#beecff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>
                      <Icon name="delete-left" />
                    </Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack fill align="center" justify="center">
              <Stack.Item
                style={{ cursor: 'pointer' }}
                onClick={() => setShowSymbols(!showSymbols)}
              >
                <Box
                  inline
                  width={3}
                  height={2.4}
                  backgroundColor="#beecff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>{showSymbols ? 'ABC' : '?123'}</Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box
                  inline
                  width={1.8}
                  height={2.4}
                  backgroundColor="#d5ffff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>
                      <Icon name="microphone" />
                    </Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
              <Stack.Item
                style={{ cursor: 'pointer' }}
                onClick={() => keyHandler(',')}
              >
                <Box
                  inline
                  width={1.8}
                  height={2.4}
                  backgroundColor="#d5ffff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>,</Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
              <Stack.Item
                style={{ cursor: 'pointer' }}
                onClick={() => keyHandler(' ')}
              >
                <Box
                  width={8.7}
                  height={2.4}
                  backgroundColor="#d5ffff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  {' '}
                </Box>
              </Stack.Item>
              <Stack.Item
                style={{ cursor: 'pointer' }}
                onClick={() => keyHandler('.')}
              >
                <Box
                  inline
                  width={1.8}
                  height={2.4}
                  backgroundColor="#d5ffff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>.</Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
              <Stack.Item
                style={{ cursor: 'pointer' }}
                onClick={() => keyHandler('Enter')}
              >
                <Box
                  inline
                  width={3}
                  height={2.4}
                  backgroundColor="#beecff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>
                      <Icon name="arrow-turn-down" rotation={90} />
                    </Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};

export const ScreenMessages = (props: {
  enteredNumber: string;
  setEnteredNumber: React.Dispatch<React.SetStateAction<string>>;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { act, data } = useBackend<Data>();
  const convertTo12Hour = (timeStr: string) => {
    if (!timeStr || !timeStr.includes(':')) return timeStr || '';
    const [hourStr, minute] = timeStr.split(':');
    const hour = parseInt(hourStr, 10);
    const period = hour >= 12 ? 'PM' : 'AM';
    const displayHour = hour % 12 || 12;
    return `${displayHour}:${minute} ${period}`;
  };
  const {
    my_number,
    published_numbers,
    our_contacts,
    our_blocked_contacts,
    current_conversation_messages,
    conversations,
    date,
  } = data;
  const { enteredNumber, setEnteredNumber, setApp } = props;

  const [selectedContact, setSelectedContact] = useState<string | null>(null);
  const [messageText, setMessageText] = useState('');
  const messagesContainerRef = useRef<HTMLDivElement>(null);
  const prevMessageCountRef = useRef<number>(0);

  useEffect(() => {
    if (enteredNumber && !selectedContact) {
      setSelectedContact(enteredNumber);
      act('view_conversation', { contact_number: enteredNumber });
      setEnteredNumber('');
    }
  }, [enteredNumber, selectedContact, setEnteredNumber, act]);

  // keep scrollin scrollin scrollin scrollin
  useEffect(() => {
    const messageCount = current_conversation_messages?.length || 0;
    if (
      messagesContainerRef.current &&
      messageCount > prevMessageCountRef.current
    ) {
      messagesContainerRef.current.scrollTop =
        messagesContainerRef.current.scrollHeight;
    }
    prevMessageCountRef.current = messageCount;
  }, [current_conversation_messages]);

  useEffect(() => {
    if (selectedContact && messagesContainerRef.current) {
      messagesContainerRef.current.scrollTop =
        messagesContainerRef.current.scrollHeight;
    }
  }, [selectedContact]);

  const handleKeyPress = (key: string) => {
    if (key === 'Backspace') {
      setMessageText((prev) => prev.slice(0, -1));
    } else if (key === 'Enter') {
      handleSend();
    } else {
      setMessageText((prev) => prev + key);
    }
  };

  const handleSend = () => {
    if (messageText && selectedContact) {
      act('send_message', {
        contact_number: selectedContact,
        message_text: messageText,
      });
      setMessageText('');
    }
  };

  const handleSelectContact = (contactNumber: string) => {
    setSelectedContact(contactNumber);
    act('view_conversation', { contact_number: contactNumber });
  };

  useEffect(() => {
    if (selectedContact) {
      const conv = conversations.find((c) => c.number === selectedContact);
      if (conv) {
        const seenConversations = JSON.parse(
          localStorage.getItem('seen_conversations') || '{}',
        );
        seenConversations[selectedContact] = conv.last_timestamp;
        localStorage.setItem(
          'seen_conversations',
          JSON.stringify(seenConversations),
        ); // updating this removes the unread badge
      }
    }
  }, [selectedContact, conversations]);

  const getContactName = (contactNumber: string) => {
    const contact = our_contacts.find((c) => c.number === contactNumber);
    if (contact) return contact.name;
    const published = published_numbers.find((p) => p.number === contactNumber);
    if (published) return published.name;
    return contactNumber;
  };
  // largely copy pasted from screencontacts.tsx
  if (selectedContact) {
    return (
      <Stack vertical fill backgroundColor="#fff" textColor="#000">
        <Stack.Item backgroundColor="#0069ff" textColor="#fff" p={1}>
          <Stack align="center">
            <Icon
              name="arrow-left"
              onClick={() => setSelectedContact(null)}
              style={{ cursor: 'pointer' }}
            />
            <Stack.Item grow>{getContactName(selectedContact)}</Stack.Item>
          </Stack>
        </Stack.Item>

        <Stack.Item grow style={{ overflow: 'hidden' }}>
          <div
            ref={messagesContainerRef}
            style={{
              overflowY: 'auto',
              height: '100%',
              scrollbarWidth: 'none',
              msOverflowStyle: 'none',
            }}
            className="hide-scrollbar"
          >
            <style>{`
              .hide-scrollbar::-webkit-scrollbar {
                display: none;
              }
            `}</style>
            <Box fontSize={0.8} textAlign="center" textColor="#969696">
              {date}
            </Box>
            {current_conversation_messages?.map((msg, idx) => (
              // flex-end for INCOMING, flex-start for OUTGOING. left and right sides
              <Stack
                key={idx}
                mb={1}
                p={1}
                justify={msg.is_outgoing ? 'flex-end' : 'flex-start'}
              >
                <Box
                  backgroundColor={msg.is_outgoing ? '#0069ff' : '#e0e0e0'} //TODO maybe change this to green if we do expensive vs cheap phones
                  textColor={msg.is_outgoing ? '#fff' : '#000'}
                  p={1}
                  style={{
                    borderRadius: '8px',
                    maxWidth: '70%',
                    wordWrap: 'break-word',
                  }}
                >
                  {msg.message_text}
                  <Box
                    textAlign={msg.is_outgoing ? 'right' : 'left'}
                    fontSize={0.7}
                    mt={0.5}
                    textColor={msg.is_outgoing ? '#ffffff' : '#303030'}
                  >
                    {convertTo12Hour(msg.time)}
                  </Box>
                </Box>
              </Stack>
            ))}
          </div>
        </Stack.Item>
        <Stack.Item
          p={1}
          backgroundColor="#f0f0f0"
          style={{ borderTop: '1px solid #ddd' }}
        >
          <style>{`
            @keyframes blink {
              0%, 50% { opacity: 1; }
              51%, 100% { opacity: 0; }
            }
            .cursor {
              display: inline-block;
              animation: blink 1s infinite;
              margin-left: 2px;
            }
          `}</style>
          <Box
            p={0.5}
            style={{
              backgroundColor: '#fff',
              borderRadius: '4px',
              border: '1px solid #ccc',
              minHeight: '2.5em',
            }}
          >
            {messageText}
            {messageText.length === 0 && selectedContact && (
              <span className="cursor">|</span>
            )}
          </Box>
        </Stack.Item>
        <Stack.Item mb={6}>
          <Keyboard onClick={handleKeyPress} />
        </Stack.Item>
      </Stack>
    );
  }

  // all of our gott dang convos are here
  const seenConversations = JSON.parse(
    localStorage.getItem('seen_conversations') || '{}',
  );
  const allContacts = Array.isArray(conversations)
    ? conversations
        .filter((c) => c.number !== my_number)
        .sort((a, b) => {
          const aTime =
            typeof a.last_timestamp === 'number' ? a.last_timestamp : 0;
          const bTime =
            typeof b.last_timestamp === 'number' ? b.last_timestamp : 0;
          return bTime - aTime;
        }) // sort by most recent first
        .map((c) => ({
          name: getContactName(c.number),
          number: c.number,
          lastMessage: c.last_message_text,
          isUnread:
            (seenConversations[c.number] || 0) === 0 ||
            (c.last_timestamp &&
              c.last_timestamp > (seenConversations[c.number] || 0)), // fuck
        }))
    : [];
  if (allContacts.length === 0) {
    return (
      <Stack vertical fill backgroundColor="#fff" textColor="#000">
        <Stack.Item backgroundColor="#0069ff" textColor="#fff" p={1}>
          <Stack align="center">
            <Icon
              name="arrow-left"
              onClick={() => setApp(null)}
              style={{ cursor: 'pointer' }}
            />
            Messages
          </Stack>
        </Stack.Item>
        <Stack.Item grow overflowY="auto">
          <Box p={1} textAlign="center" textColor="#969696">
            No conversations yet
          </Box>
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item backgroundColor="#0069ff" textColor="#fff" p={1}>
        <Stack align="center">
          <Icon
            name="arrow-left"
            onClick={() => setApp(null)}
            style={{ cursor: 'pointer' }}
          />
          Messages
        </Stack>
      </Stack.Item>
      <Stack.Item grow overflowY="auto">
        <Stack vertical>
          {allContacts?.map((contact) => (
            <ContactElement
              contact={contact}
              key={contact.name + contact.number}
              onClick={() => handleSelectContact(contact.number)}
              time={contact.lastMessage || contact.number}
              isUnread={contact.isUnread || false}
            />
          ))}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
