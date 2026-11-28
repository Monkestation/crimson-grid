import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { MedicalDirectory, MedicalSummary, readInput } from './PcMedicalCommon';
import { useProgram } from './useProgram';

export const PcMedicalWriter = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const records = Array.isArray(data.records) ? data.records : [];
  const photos = Array.isArray(data.photos) ? data.photos : [];
  const limits = data.limits || {};
  const selected = data.selected;
  const printCd = data.print_cooldown || 0;

  const [draft, setDraft] = useState('');
  const selectedName = selected ? selected.name : null;
  const serverText = selected ? selected.medical || '' : '';

  // Load the record's text into the editor whenever a different record is opened.
  useEffect(() => {
    setDraft(serverText);
  }, [selectedName]);

  if (data.error) {
    return (
      <Section title="Medical Records Editor">
        <Box style={{ color: '#a00' }}>{data.error}</Box>
      </Section>
    );
  }

  const dirty = draft !== serverText;

  return (
    <Stack fill vertical>
      {!!data.status && (
        <Stack.Item>
          <NoticeBox info>{data.status}</NoticeBox>
        </Stack.Item>
      )}
      {!data.can_write && (
        <Stack.Item>
          <NoticeBox danger>
            Insert a card and log in with a permitted role to make changes.
          </NoticeBox>
        </Stack.Item>
      )}
      <Stack.Item grow>
        {selected ? (
          <Section
            fill
            scrollable
            title={`Editing: ${selected.name}`}
            buttons={
              <>
                <Button
                  icon="print"
                  disabled={printCd > 0 || data.printer_status !== 'Ready'}
                  tooltip={`Printer: ${data.printer_status}`}
                  onClick={() => act('print')}
                >
                  {printCd > 0 ? `Wait ${printCd}s` : 'Print'}
                </Button>
                <Button icon="arrow-left" onClick={() => act('deselect')}>
                  Back
                </Button>
              </>
            }
          >
            <MedicalSummary rec={selected} showText={false} />

            <Box style={{ color: '#555' }} mb={1}>
              Changes are saved to this network only, not the station manifest.
            </Box>
            <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
              Medical History ({draft.length}/{limits.text})
            </Box>
            <TextArea
              fluid
              height="180px"
              value={draft}
              maxLength={limits.text}
              onInput={(a, b) => setDraft(readInput(a, b))}
              onChange={(a, b) => setDraft(readInput(a, b))}
            />
            <Box mt={1}>
              <Button
                icon="save"
                color="good"
                disabled={!data.can_write || !dirty}
                onClick={() => act('save', { text: draft })}
              >
                Save to Network
              </Button>
              <Button
                icon="undo"
                color="bad"
                disabled={!data.can_write || !selected.edited}
                onClick={() => act('revert')}
              >
                Revert to Manifest
              </Button>
            </Box>

            <Section title="Photo Attachment" mt={2}>
              {!!selected.attachment && (
                <Button
                  icon="times"
                  color="bad"
                  disabled={!data.can_write}
                  onClick={() => act('detach')}
                >
                  Remove attached photo
                </Button>
              )}
              {photos.length === 0 && (
                <Box style={{ color: '#555' }}>
                  Carry a photo to attach it to this record.
                </Box>
              )}
              {photos.map((p) => (
                <Button
                  key={p.ref}
                  icon="camera"
                  disabled={!data.can_write}
                  onClick={() => act('attach', { photo: p.ref })}
                >
                  {p.name}
                </Button>
              ))}
            </Section>
          </Section>
        ) : (
          <MedicalDirectory
            records={records}
            onOpen={(name) => act('select', { name })}
          />
        )}
      </Stack.Item>
    </Stack>
  );
};
