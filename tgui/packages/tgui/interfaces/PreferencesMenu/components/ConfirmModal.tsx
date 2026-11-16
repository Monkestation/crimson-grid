// THIS IS A DARKPACK UI FILE

import { Box, Button, Stack } from 'tgui-core/components';

const DEFAULT_BODY = "Changing significant character details (Clan, age, etc.) will wipe ALL of your existing disciplines. This cannot be undone. Are you sure?";

type Props = {
  title?: string;
  body?: string;
  onConfirm: () => void;
  onCancel: () => void;
};

export function ConfirmModal(props: Props) {
  const { title = 'Change Character Details?', body = DEFAULT_BODY, onConfirm, onCancel } = props;

  return (
    <Box
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        background: 'rgba(0,0,0,0.75)',
        zIndex: 9999,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <Box
        style={{
          background: '#1b1b1b',
          border: '1px solid #555',
          padding: '20px',
          maxWidth: '380px',
          width: '90%',
        }}
      >
        <Box bold textAlign="center" fontSize={1.1} mb={1} mt={-1}>
          {title}
        </Box>
        <Box color="label" mb={2}>
          {body}
        </Box>
        <Stack textAlign="center" justify="center">
          <Stack.Item>
            <Button textAlign="center" onClick={onCancel}>
              Cancel
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button textAlign="center" color="bad" onClick={onConfirm}>
              Proceed
            </Button>
          </Stack.Item>
        </Stack>
      </Box>
    </Box>
  );
}
