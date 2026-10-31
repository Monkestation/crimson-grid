import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

type Surgery = {
  name: string;
  desc: string;
  tool_rec: string;
  requirements?: string[];
  show_as_next: boolean;
  show_in_list: boolean;
  priority?: boolean;
  mechanic?: boolean;
};

type Patient = {
  stat: string;
  statstate: string;
  health: number;
  maxHealth: number;
  minHealth: number;
  bruteLoss: number;
  fireLoss: number;
  toxLoss: number;
  oxyLoss: number;
  blood_level: number;
  standard_blood_level: number;
  blood_type: string;
  surgery_state?: string[];
};

// The stock "good"/"green" colors are too light on the grey background.
const DARK_GREEN = '#14532d';

const ZONE_LABELS: Record<string, string> = {
  head: 'Head',
  chest: 'Chest',
  l_arm: 'Left Arm',
  r_arm: 'Right Arm',
  l_leg: 'Left Leg',
  r_leg: 'Right Leg',
  eyes: 'Eyes',
  mouth: 'Mouth',
  groin: 'Groin',
  l_hand: 'Left Hand',
  r_hand: 'Right Hand',
  l_foot: 'Left Foot',
  r_foot: 'Right Foot',
};

// tgui-core Input handlers differ between versions: (value) or (event, value).
const readText = (a: any, b: any): string => {
  for (const v of [b, a]) {
    if (typeof v === 'string') return v;
  }
  if (a && typeof a === 'object' && a.target != null) {
    return String(a.target.value ?? '');
  }
  return '';
};

const cleanRequirements = (reqs?: string[]): string[] =>
  (reqs || [])
    .flatMap((r) => String(r).split(/[;,]/))
    .map((r) => r.trim())
    .filter((r) => r)
    .map((r) => r.charAt(0).toUpperCase() + r.slice(1));

export const PcOperating = (props, context) => {
  const { act, data: raw } = useProgram(props.programId, context);
  const data = raw.operating || raw;

  const [search, setSearch] = useState('');
  // Index into data.surgeries. Names are not unique, so never key/select by name.
  const [selected, setSelected] = useState<number | null>(null);

  if (data.locked) {
    return <NoticeBox danger>{data.locked}</NoticeBox>;
  }

  const patient: Patient | undefined = data.patient;
  const surgeries: Surgery[] = data.surgeries || [];
  const zones: string[] = data.zones || [];
  const hasExperiments = (data.experiments || []).length > 0;

  const query = search.trim().toLowerCase();
  const visible = surgeries
    .map((s, i) => ({ s, i }))
    .filter(({ s }) => s.show_in_list || s.show_as_next)
    .filter(
      ({ s }) =>
        !query ||
        s.name.toLowerCase().includes(query) ||
        s.desc.toLowerCase().includes(query) ||
        String(s.tool_rec).toLowerCase().includes(query),
    )
    .sort((a, b) => Number(!!b.s.show_as_next) - Number(!!a.s.show_as_next));

  const current = selected !== null ? surgeries[selected] : undefined;

  return (
    <Stack fill>
      <Stack.Item basis="38%">
        <Stack vertical fill>
          <Stack.Item grow>
            <Section fill scrollable title="Patient">
              {!data.has_table && (
                <NoticeBox>No operating table linked.</NoticeBox>
              )}
              {!!data.has_table && !patient && (
                <NoticeBox>No patient on the table.</NoticeBox>
              )}
              {!!patient && (
                <LabeledList>
                  <LabeledList.Item
                    labelColor="black"
                    label="State"
                    color={
                      patient.statstate === 'good'
                        ? DARK_GREEN
                        : patient.statstate
                    }
                  >
                    {patient.stat}
                  </LabeledList.Item>
                  <LabeledList.Item labelColor="black" label="Health">
                    <ProgressBar
                      value={patient.health}
                      minValue={patient.minHealth}
                      maxValue={patient.maxHealth}
                      ranges={{
                        good: [patient.maxHealth * 0.5, Infinity],
                        average: [0, patient.maxHealth * 0.5],
                        bad: [-Infinity, 0],
                      }}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item
                    labelColor="black"
                    label="Brute"
                    color="red"
                  >
                    {Math.round(patient.bruteLoss)}
                  </LabeledList.Item>
                  <LabeledList.Item
                    labelColor="black"
                    label="Burn"
                    color="orange"
                  >
                    {Math.round(patient.fireLoss)}
                  </LabeledList.Item>
                  <LabeledList.Item
                    labelColor="black"
                    label="Toxin"
                    color={DARK_GREEN}
                  >
                    {Math.round(patient.toxLoss)}
                  </LabeledList.Item>
                  <LabeledList.Item
                    labelColor="black"
                    label="Suffocation"
                    color="blue"
                  >
                    {Math.round(patient.oxyLoss)}
                  </LabeledList.Item>
                  <LabeledList.Item
                    labelColor="black"
                    label={`Blood (${patient.blood_type})`}
                  >
                    <ProgressBar
                      value={patient.blood_level}
                      minValue={0}
                      maxValue={patient.standard_blood_level}
                      ranges={{
                        good: [patient.standard_blood_level * 0.9, Infinity],
                        average: [patient.standard_blood_level * 0.6, Infinity],
                        bad: [-Infinity, patient.standard_blood_level * 0.6],
                      }}
                    />
                  </LabeledList.Item>
                  {!!patient.surgery_state?.length && (
                    <LabeledList.Item labelColor="black" label="Surgery">
                      {patient.surgery_state.join(', ')}
                    </LabeledList.Item>
                  )}
                </LabeledList>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item grow>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Target Zone">
              {zones.map((zone) => (
                <Button
                  key={zone}
                  selected={zone === data.target_zone}
                  onClick={() => act('change_zone', { new_zone: zone })}
                >
                  {ZONE_LABELS[zone] || zone}
                </Button>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            {current ? (
              <SurgeryDetail
                surgery={current}
                onBack={() => setSelected(null)}
              />
            ) : (
              <Section
                fill
                scrollable
                title="Procedures"
                buttons={
                  <Input
                    placeholder="Search..."
                    value={search}
                    width="14em"
                    onInput={(a, b) => setSearch(readText(a, b))}
                  />
                }
              >
                {visible.map(({ s, i }) => (
                  <Button
                    key={i}
                    fluid
                    color={s.show_as_next ? 'good' : 'default'}
                    onClick={() => setSelected(i)}
                  >
                    <Stack>
                      <Stack.Item grow>{s.name}</Stack.Item>
                      <Stack.Item>{String(s.tool_rec)}</Stack.Item>
                    </Stack>
                  </Button>
                ))}
                {visible.length === 0 && (
                  <Box>
                    {surgeries.length === 0
                      ? 'No procedures loaded.'
                      : 'No procedures match your search.'}
                  </Box>
                )}
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const SurgeryDetail = (props: { surgery: Surgery; onBack: () => void }) => {
  const { surgery, onBack } = props;
  const reqs = cleanRequirements(surgery.requirements);
  return (
    <Section
      fill
      scrollable
      title={surgery.name}
      buttons={
        <Button icon="arrow-left" onClick={onBack}>
          Back
        </Button>
      }
    >
      {!!surgery.show_as_next && (
        <NoticeBox success>Suggested next step for this patient.</NoticeBox>
      )}
      <Box mb={2}>{surgery.desc}</Box>
      <Box mb={0.5}>
        <b>Tool:</b> {String(surgery.tool_rec)}
      </Box>
      {!!surgery.mechanic && (
        <Box mb={0.5}>
          <b>Type:</b> Mechanical
        </Box>
      )}
      {reqs.length > 0 && (
        <Section title="Requirements">
          {reqs.map((r) => (
            <Box key={r}>&bull; {r}</Box>
          ))}
        </Section>
      )}
    </Section>
  );
};
