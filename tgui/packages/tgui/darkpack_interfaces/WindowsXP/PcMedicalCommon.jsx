import { useState } from 'react';
import { Box, Input, Section, Stack } from 'tgui-core/components';

export const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const Row = (props) => {
  if (props.value === null || props.value === undefined || props.value === '')
    return null;
  return (
    <Box style={{ color: '#000' }} mb={0.25}>
      <b>{props.label}:</b> {props.value}
    </Box>
  );
};

const Photo = (props) => (
  <Box inline mr={1} textAlign="center">
    {props.src ? (
      <img
        alt={props.label}
        src={`data:image/png;base64,${props.src}`}
        width={96}
        height={96}
        style={{
          imageRendering: 'pixelated',
          border: '1px solid #888',
          background: '#fff',
        }}
      />
    ) : (
      <Box
        style={{
          width: '96px',
          height: '96px',
          border: '1px dashed #888',
          color: '#666',
          lineHeight: '96px',
        }}
      >
        No photo
      </Box>
    )}
    <Box style={{ color: '#555', fontSize: '11px' }}>{props.label}</Box>
  </Box>
);

export const MedicalDirectory = (props) => {
  const { records, onOpen } = props;
  const [search, setSearch] = useState('');
  const q = search.trim().toLowerCase();
  const shown = records.filter(
    (r) =>
      !q ||
      String(r.name).toLowerCase().includes(q) ||
      String(r.rank || '')
        .toLowerCase()
        .includes(q),
  );
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          fluid
          placeholder="Search name or rank"
          value={search}
          onInput={(a, b) => setSearch(readInput(a, b))}
          onChange={(a, b) => setSearch(readInput(a, b))}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          {shown.length === 0 && (
            <Box style={{ color: '#444' }} p={2}>
              No records found.
            </Box>
          )}
          {shown.map((rec) => (
            <Box
              key={rec.name}
              p={1}
              mb={0.5}
              style={{
                borderBottom: '1px solid #ccc',
                cursor: 'pointer',
                background: '#fff',
              }}
              onClick={() => onOpen(rec.name)}
            >
              <Box
                style={{ color: '#000', fontSize: '12px', fontWeight: 'bold' }}
              >
                {rec.name}
              </Box>
              <Box
                style={{ color: '#444', fontSize: '11px', marginTop: '2px' }}
              >
                {rec.rank} {rec.edited ? '[Edited on network]' : ''}{' '}
                {rec.has_attachment ? '[Photo attached]' : ''}
              </Box>
            </Box>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const MedicalSummary = (props) => {
  const { rec, showText } = props;
  const notes = Array.isArray(rec.notes) ? rec.notes : [];
  return (
    <>
      <Box mb={1}>
        <Photo src={rec.front} label="Front" />
        <Photo src={rec.side} label="Side" />
      </Box>
      <Box mb={1}>
        <Row label="Age" value={rec.age} />
        <Row label="Gender" value={rec.gender} />
        <Row label="Species" value={rec.species} />
        <Row label="Blood type" value={rec.blood_type} />
        <Row label="Physical" value={rec.physical_status} />
        <Row label="Mental" value={rec.mental_status} />
        <Row label="Cause of death" value={rec.cause_of_death} />
        <Row label="Major conditions" value={rec.major_conditions} />
        <Row label="Minor conditions" value={rec.minor_conditions} />
        <Row label="Quirks" value={rec.quirk_notes} />
      </Box>
      {notes.length > 0 && (
        <Box mb={1}>
          <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
            Staff Notes
          </Box>
          {notes.map((n, i) => (
            <Box key={i} style={{ color: '#000' }} mb={0.25}>
              - {n.content}{' '}
              <span style={{ color: '#555' }}>
                ({n.author}, {n.time})
              </span>
            </Box>
          ))}
        </Box>
      )}
      {!!rec.edited && (
        <Box style={{ color: '#555' }} mb={1}>
          Network copy, last edited by {rec.editor} at {rec.time}
        </Box>
      )}
      {!!rec.attachment && (
        <Box mb={1}>
          <Photo
            src={rec.attachment}
            label={rec.attachment_name || 'Attached'}
          />
        </Box>
      )}
      {showText && (
        <>
          <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
            Medical History
          </Box>
          <Box style={{ whiteSpace: 'pre-wrap', color: '#000' }}>
            {rec.medical || 'No medical history on file.'}
          </Box>
        </>
      )}
    </>
  );
};
