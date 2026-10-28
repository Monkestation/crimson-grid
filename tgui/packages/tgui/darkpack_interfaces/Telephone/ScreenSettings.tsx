// THIS IS A DARKPACK UI FILE
import { Icon, Stack } from 'tgui-core/components';
import { NavigableApps } from '.';

// fake phone info generated when the phone is spawned. random for now, maybe implemented later. maybe never.
const totalStorage = 128;
const storageUsed = Math.min(
  Math.floor(Math.random() * (totalStorage - 10)),
  totalStorage - 40,
); //im bad at math
const storageFree = totalStorage - storageUsed;

const batteryPercentage = Math.min(Math.floor(Math.random() * 100), 100);
const batteryDays = Math.floor(Math.random() * 3) + 1;
const batteryHours = Math.floor(Math.random() * 5) + 1;

type SettingsChoice = {
  name: string;
  description?: string;
  icon: string;
  functional: boolean;
  action: () => void;
};

export const ScreenSettings = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;

  // most of these are fake... for now
  const choices: SettingsChoice[] = [
    {
      name: 'Network & Internet',
      description: 'Mobile, Wi-Fi, hotspot',
      icon: 'wifi',
      functional: false,
      action: () => null,
    },
    {
      name: 'Connected Devices',
      description: 'Bluetooth, pairing',
      icon: 'computer',
      functional: false,
      action: () => null,
    },
    {
      name: 'Personalize',
      description: "Change your phone's background",
      icon: 'image',
      functional: true,
      action: () => setApp(NavigableApps.Backgrounds),
    },
    {
      name: 'Display',
      description: 'Dark theme, font size, brightness',
      icon: 'sun',
      functional: false,
      action: () => null,
    },
    {
      name: 'Home & lock screen',
      description: 'Customize what is displayed on home & lock screens',
      icon: 'phone',
      functional: false,
      action: () => null,
    },
    {
      name: 'Sound & vibration',
      description: 'Volume, vibration, Do Not Disturb, ringtones', //CRIMSON GRID EDIT - ORIGINAL: description: 'Volume, vibration, Do Not Disturb',
      icon: 'volume-up',
      functional: true,
      action: () => setApp(NavigableApps.SoundSettings),
    },
    {
      name: 'Notifications',
      description: 'Notification history, conversations',
      icon: 'bell',
      functional: false,
      action: () => null,
    },
    {
      name: 'Gestures',
      description:
        'Use gestures and keys to quickly open frequently used functions',
      icon: 'hand-pointer',
      functional: false,
      action: () => null,
    },
    {
      name: 'Battery',
      description: `${batteryPercentage}% - ${batteryDays} days, ${batteryHours}hr`,
      icon: 'battery-full',
      functional: false,
      action: () => null,
    },
    {
      name: 'Storage',
      description: `${storageUsed}% used - ${storageFree} GB free`,
      icon: 'hdd',
      functional: false,
      action: () => null,
    },
    {
      name: 'Location',
      description: 'On - 3 apps have access to location',
      icon: 'map-marker-alt',
      functional: false,
      action: () => null,
    },
    {
      name: 'Accessibility',
      description: 'Display, interaction, audio',
      icon: 'person',
      functional: false,
      action: () => null,
    },
  ];
  return (
    <Stack vertical fill backgroundColor="#ffffff" textColor="#000">
      <Stack.Item backgroundColor="#5f5f5f" textColor="#fff" p={1}>
        <Stack align="center">
          <Icon
            name="arrow-left"
            onClick={() => setApp(null)}
            style={{ cursor: 'pointer' }}
          />
          <Stack.Item grow ml={1}>
            Settings
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item
        grow
        overflowY="auto"
        style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
      >
        <Stack vertical mb={5}>
          {choices.map((choice, index) => (
            <Stack.Item
              key={index}
              p={1}
              onClick={choice.action}
              className={
                choice.functional ? 'Telephone__ContactsElement' : null
              } // only working apps are clickable
            >
              <Stack align="center" mb={1}>
                <Stack.Item ml={2} mr={2} width={2}>
                  <Icon name={choice.icon} size={1.5} />
                </Stack.Item>
                <Stack.Item grow ml={1.2} mr={2}>
                  <Stack vertical>
                    <Stack.Item fontSize={1.3}>{choice.name}</Stack.Item>
                    {choice.description ? (
                      <Stack.Item fontSize={1} mt={-1} opacity={0.7}>
                        {choice.description}
                      </Stack.Item>
                    ) : null}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          ))}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
