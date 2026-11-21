import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

export const PcEmail = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const emailData = data.email || data;
  const address = emailData.address || 'anonymous';
  const network = emailData.network || 'Local Area Network';
  const isSchrecknet = emailData.is_schrecknet || false;
  const inbox = Array.isArray(emailData.inbox) ? emailData.inbox : [];

  const [tab, setTab] = useState('inbox');
  const [selected, setSelected] = useState(null);
  const [to, setTo] = useState('');
  const [subject, setSubject] = useState('');
  const [body, setBody] = useState('');

  const selectedMail = inbox.find((_, i) => i === selected);
  const domainSuffix = isSchrecknet ? '@schreckNET.nod' : '@tmail.com';

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <Box style={{ color: '#000' }}>
            <Box inline fontWeight="bold">
              {isSchrecknet ? 'SchreckNet Node:' : 'Telus Mail Service:'}
            </Box>{' '}
            <Box inline fontFamily="monospace" fontWeight="bold">
              {address}
              {domainSuffix}
            </Box>
            <Box inline mx={2}>
              Network:
            </Box>{' '}
            <Box
              style={{
                padding: '8px 12px',
                color: '#000000',
                borderTop: '1px solid #b8b8b8',
              }}
            >
              <Box fontWeight="bold" mb={0.5}>
                <Icon name="network-wired" mr={1} />
                Network: {data.network_name || 'Local'}
              </Box>
            </Box>
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab selected={tab === 'inbox'} onClick={() => setTab('inbox')}>
            Inbox ({inbox.length})
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'compose'}
            onClick={() => setTab('compose')}
          >
            Compose
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      {tab === 'inbox' && (
        <Stack.Item grow>
          <Stack fill>
            <Stack.Item basis="40%">
              <Section title="Messages" fill scrollable>
                {inbox.length === 0 && <Box p={1}>Inbox empty.</Box>}
                {inbox.map((mail, i) => (
                  <Box
                    key={i}
                    p={1}
                    mb={0.5}
                    style={{
                      background:
                        selected === i
                          ? '#cce0ff'
                          : mail.read
                            ? '#fff'
                            : '#fff8dc',
                      cursor: 'pointer',
                      borderBottom: '1px solid #ddd',
                      color: '#000',
                    }}
                    onClick={() => {
                      setSelected(i);
                      if (!mail.read) act('mark_read', { index: i });
                    }}
                  >
                    <Box fontWeight={mail.read ? 'normal' : 'bold'}>
                      {mail.subject || '(no subject)'}
                    </Box>
                    <Box fontSize="11px" style={{ color: '#555' }}>
                      From: {mail.from} — {mail.time}
                    </Box>
                  </Box>
                ))}
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section
                title={selectedMail ? selectedMail.subject : 'Select a message'}
                fill
                scrollable
              >
                {selectedMail ? (
                  <>
                    <Box
                      mb={1}
                      style={{
                        color: '#555',
                        borderBottom: '1px solid #eee',
                        paddingBottom: '4px',
                      }}
                    >
                      <strong>From:</strong> {selectedMail.from}
                      <br />
                      <strong>Time:</strong> {selectedMail.time}
                    </Box>
                    <Box style={{ whiteSpace: 'pre-wrap', color: '#000' }}>
                      {selectedMail.body}
                    </Box>
                  </>
                ) : (
                  <Box>No message selected.</Box>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      {tab === 'compose' && (
        <Stack.Item grow>
          <Section title="New Message" fill>
            <Stack vertical fill>
              <Stack.Item>
                <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
                  To (e.g. rusty_venture)
                </Box>
                <Input
                  fluid
                  value={to}
                  placeholder="recipient handle or name"
                  onInput={(a, b) => setTo(readInput(a, b))}
                  onChange={(a, b) => setTo(readInput(a, b))}
                />
              </Stack.Item>
              <Stack.Item>
                <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
                  Subject
                </Box>
                <Input
                  fluid
                  value={subject}
                  onInput={(a, b) => setSubject(readInput(a, b))}
                  onChange={(a, b) => setSubject(readInput(a, b))}
                />
              </Stack.Item>
              <Stack.Item grow>
                <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
                  Body
                </Box>
                <TextArea
                  fluid
                  height="100%"
                  value={body}
                  onInput={(a, b) => setBody(readInput(a, b))}
                  onChange={(a, b) => setBody(readInput(a, b))}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="paper-plane"
                  content="Send"
                  color="good"
                  disabled={!to || !body}
                  onClick={() => {
                    act('send', { to, subject, body });
                    setTo('');
                    setSubject('');
                    setBody('');
                    setTab('inbox');
                  }}
                />
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};
