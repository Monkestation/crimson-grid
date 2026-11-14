import { Box, Button, NoticeBox, Section, Stack } from 'tgui-core/components';
import { MedicalDirectory, MedicalSummary } from './PcMedicalCommon';
import { useProgram } from './useProgram';

export const PcMedicalReader = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const records = Array.isArray(data.records) ? data.records : [];
  const selected = data.selected;
  const printCd = data.print_cooldown || 0;

  if (data.error) {
    return (
      <Section title="Medical Records">
        <Box style={{ color: '#a00' }}>{data.error}</Box>
      </Section>
    );
  }

  return (
    <Stack fill vertical>
      {!!data.status && (
        <Stack.Item>
          <NoticeBox info>{data.status}</NoticeBox>
        </Stack.Item>
      )}
      <Stack.Item grow>
        {selected ? (
          <Section
            fill
            scrollable
            title={selected.name}
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
            <MedicalSummary rec={selected} showText />
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
