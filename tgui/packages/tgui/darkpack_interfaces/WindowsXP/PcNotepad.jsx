import { useState } from 'react';
import { Button, Section, TextArea } from 'tgui-core/components';
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

export const PcNotepad = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const serverText = (data.notepad || data).text || '';

  const [text, setText] = useState(serverText);
  const [lastServerText, setLastServerText] = useState(serverText);

  if (serverText !== lastServerText) {
    setLastServerText(serverText);
    setText(serverText);
  }

  return (
    <Section
      title="Notepad"
      fill
      buttons={
        <Button
          icon="save"
          content="Save"
          onClick={() => act('save', { text })}
        />
      }
    >
      <TextArea
        fluid
        height="100%"
        value={text}
        placeholder="Type notes here..."
        onInput={(a, b) => setText(readInput(a, b))}
        onChange={(a, b) => setText(readInput(a, b))}
      />
    </Section>
  );
};
