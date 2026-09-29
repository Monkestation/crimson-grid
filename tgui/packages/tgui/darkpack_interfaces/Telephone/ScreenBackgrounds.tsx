// THIS IS A DARKPACK UI FILE
import { useBackend } from 'tgui/backend';
import { resolveAsset } from 'tgui/assets';
import { Box, Icon, Stack } from 'tgui-core/components';
import { type Data, NavigableApps } from '.';
import { backgrounds } from './backgroundImages';

export const ScreenBackgrounds = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { act, data } = useBackend<Data>();
  const { setApp } = props;

  const choices = [
    {
      name: 'Snowy Mountain',
      key: 'BG_1',
    },
    {
      name: 'Dog in Nature',
      key: 'BG_2',
    },
    {
      name: 'Waves',
      key: 'BG_3',
    },
    {
      name: 'Relaxing Cat',
      key: 'BG_4',
    },
    {
      name: 'Happy Dog',
      key: 'BG_5',
    },
    {
      name: 'Natural Landscape',
      key: 'BG_6',
    },
    {
      name: 'Mr. Mittens',
      key: 'BG_7',
    },
    {
      name: 'Lazy Cat',
      key: 'BG_8',
    },
    {
      name: 'Dozerine',
      key: 'BG_9',
    },
    {
      name: 'Golden Gate Bridge',
      key: 'BG_10',
    },
    {
      name: 'Forest of Firs',
      key: 'BG_11',
    },
    {
      name: 'Police Motorcycles',
      key: 'BG_12',
    },
    {
      name: 'Pixel Art',
      key: 'BG_13',
    },
    {
      name: 'Sleepy Cat',
      key: 'BG_14',
    },
    {
      name: 'Snowy Landscape',
      key: 'BG_15',
    },
    {
      name: 'Bokeh Lights',
      key: 'BG_16',
    },
    {
      name: 'Modern Wallpaper',
      key: 'BG_17',
    },
    {
      name: 'Tree Canopy',
      key: 'BG_18',
    },
    {
      name: 'Custom',
      key: 'custom_background',
    },
    /*
    // see backgroundImages.ts for adding backgrounds here
    {
      name: 'Example Background',
      key: 'example_key',
    },
    */
  ];

  const setBackground = (key: string) => {
    if (key === 'custom_background') {
      act('custom_background');
      setApp(null);
    } else {
      act('set_background', { background_url: key });
      setApp(null);
    }
  };

  return (
    <Stack vertical fill backgroundColor="#ffffff" textColor="#000">
      <Stack.Item backgroundColor="#5f5f5f" textColor="#fff" p={1}>
        <Stack align="center">
          <Icon
            name="arrow-left"
            onClick={() => setApp(NavigableApps.Settings)}
            style={{ cursor: 'pointer' }}
          />
          <Stack.Item grow ml={1}>Backgrounds</Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow overflowY="auto" style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}>
        <Stack vertical>
          {choices.slice(0, -1).map((background, index) => (
            <Stack.Item key={index}>
              <Stack
                align="center"
                p={1}
                className="Telephone__ContactsElement"
                onClick={() => setBackground(background.key)}
                style={{ cursor: 'pointer' }}
              >
                <Stack.Item>
                  <Box
                    width={4}
                    height={3}
                    style={{
                      backgroundImage: `url(${resolveAsset(backgrounds[background.key])})`,
                      backgroundSize: 'cover',
                      backgroundPosition: 'center',
                      borderRadius: '4px',
                    }}
                  />
                </Stack.Item>
                <Stack.Item grow ml={1} mb={0.5}>
                  <Box>{background.name}</Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          ))}
          <Stack.Item>
            <Stack
              align="center"
              p={1}
              className="Telephone__ContactsElement"
              onClick={() => setBackground('custom_background')}
              style={{ cursor: 'pointer' }}
            >
              <Stack.Item height={2} grow ml={3} mb={3}>
                <Box><Icon ml={-0.5} mt={1.5} size={2} name="cog" /><Stack.Item ml={7} mt={-3}> Custom </Stack.Item></Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>

        <Stack.Item mb={3} />

      </Stack.Item>
      <Stack.Item>
        <Stack.Item mb={6} />
      </Stack.Item>

    </Stack>
  );
};
