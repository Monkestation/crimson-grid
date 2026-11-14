import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') {
    return String(a);
  }
  if (typeof b === 'string' || typeof b === 'number') {
    return String(b);
  }
  if (a && typeof a === 'object' && a.target != null) {
    return String(a.target.value ?? '');
  }
  return '';
};

export const PcRecords = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const recordsData = data.records || data;
  const records = Array.isArray(recordsData.records)
    ? recordsData.records
    : Array.isArray(recordsData)
      ? recordsData
      : [];

  const canAdmin = data.can_admin ?? true;
  const currentRole = data.current_role || 'User';
  const roleHierarchy = Array.isArray(data.role_hierarchy)
    ? data.role_hierarchy
    : ['Master', 'Admin', 'User', 'Guest'];

  // Filter roles up to your own privilege level (from your index to the end of the hierarchy)
  const myIndex = roleHierarchy.indexOf(currentRole);
  const availableRoles =
    myIndex !== -1 ? roleHierarchy.slice(myIndex) : ['User', 'Guest'];

  const [viewId, setViewId] = useState(null);
  const [creating, setCreating] = useState(false);
  const [title, setTitle] = useState('');
  const [body, setBody] = useState('');
  const [access, setAccess] = useState(availableRoles[0] || 'User');

  const selected = records.find((r) => r.id === viewId);

  if (creating) {
    return (
      <Section
        title="New Record"
        buttons={
          <Button
            icon="times"
            content="Cancel"
            onClick={() => setCreating(false)}
          />
        }
      >
        <Box mb={1}>
          <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
            Title
          </Box>
          <Input
            fluid
            value={title}
            onInput={(a, b) => setTitle(readInput(a, b))}
            onChange={(a, b) => setTitle(readInput(a, b))}
          />
        </Box>
        <Box mb={1}>
          <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
            Required Role Access
          </Box>
          <Dropdown
            options={availableRoles}
            value={access}
            selected={access}
            onSelected={(val) => setAccess(val)}
          />
        </Box>
        <Box mb={1}>
          <Box style={{ color: '#000', fontWeight: 'bold' }} mb={0.5}>
            Body
          </Box>
          <TextArea
            fluid
            height={23}
            value={body}
            onInput={(a, b) => setBody(readInput(a, b))}
            onChange={(a, b) => setBody(readInput(a, b))}
          />
        </Box>
        <Button
          icon="save"
          content="Save Record"
          color="good"
          disabled={!title}
          onClick={() => {
            act('create', { title, body, access });
            setTitle('');
            setBody('');
            setAccess(availableRoles[0] || 'User');
            setCreating(false);
          }}
        />
      </Section>
    );
  }

  if (selected) {
    return (
      <Section
        title={selected.title}
        buttons={
          <>
            <Button
              icon="arrow-left"
              content="Back"
              onClick={() => setViewId(null)}
            />
            {canAdmin && (
              <Button
                icon="trash"
                color="bad"
                content="Delete"
                onClick={() => {
                  act('delete', { id: selected.id });
                  setViewId(null);
                }}
              />
            )}
          </>
        }
      >
        <Box style={{ color: '#333', fontWeight: 'bold' }} mb={1}>
          Author: {selected.author} &bull; {selected.time} &bull; Access Level:{' '}
          {selected.access}
        </Box>
        <Box style={{ whiteSpace: 'pre-wrap', color: '#000' }}>
          {selected.body}
        </Box>
      </Section>
    );
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title={`Records Database [Role: ${currentRole}]`}
          buttons={
            <Button
              icon="plus"
              content="New Record"
              onClick={() => setCreating(true)}
            />
          }
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          {records.length === 0 && (
            <Box style={{ color: '#444' }} p={2}>
              No records found on this network.
            </Box>
          )}
          {records.map((rec) => (
            <Box
              key={rec.id}
              p={1}
              mb={0.5}
              style={{
                borderBottom: '1px solid #ccc',
                cursor: 'pointer',
                background: '#fff',
              }}
              onClick={() => setViewId(rec.id)}
            >
              <Box
                fontWeight="bold"
                style={{ color: '#000', fontSize: '12px' }}
              >
                {rec.title}
              </Box>
              <Box fontSize="11px" style={{ color: '#444', marginTop: '2px' }}>
                {rec.author} — {rec.time}{' '}
                {rec.access ? `[Access: ${rec.access}]` : ''}
              </Box>
            </Box>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
