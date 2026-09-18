// THIS IS A DARKPACK UI FILE
import type { PropsWithChildren, ReactNode } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui-core/components';

import { type Data, NavigableApps } from '.';
import { backgrounds } from './backgroundImages';

export const AppIcon = (
  props: PropsWithChildren<{
    size?: number;
    backgroundColor?: string;
    iconColor?: string;
    iconName?: string;
    text?: ReactNode;
    onClick?: () => void;
    notification?: number;
    filter?: string;
  }>,
) => {
  const {
    children,
    size,
    backgroundColor,
    iconColor,
    iconName,
    text,
    onClick,
    notification,
  } = props;

  const actualSize = size || 2;

  return (
    <Stack vertical align="center" justify="center" onClick={onClick}>
      <Stack.Item
        style={{
          cursor: onClick ? 'pointer' : 'default',
          position: 'relative',
        }}
      >
        <Box
          backgroundColor={backgroundColor}
          height={actualSize * 2}
          width={actualSize * 2}
          style={{
            borderRadius: '30%',
            filter: 'drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3))',
            border: '2px solid rgba(0, 0, 0, 0.2)',
          }}
        >
          <Stack justify="center" align="center" fill>
            <Stack.Item>
              {iconName ? (
                <Icon name={iconName} size={actualSize} textColor={iconColor} />
              ) : null}
              {children}
            </Stack.Item>
          </Stack>
        </Box>
        {notification !== undefined &&
          notification > 0 && ( //the unread notification thing on the messages app
            <Box
              style={{
                position: 'absolute',
                top: '-1em',
                right: '-1em',
                backgroundColor: '#ff3b30',
                color: '#fff',
                borderRadius: '50%',
                width: '2.5em',
                height: '2.5em',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                filter: 'drop-shadow(0 0 4px #000a)',
                fontSize: '0.7em',
                fontWeight: 'bold',
                //padding: '0.1em 0.3em',
              }}
            >
              {notification > 99 ? '99+' : notification}
            </Box>
          )}
      </Stack.Item>
      {text ? (
        <Stack.Item
          fontSize={actualSize / 2}
          style={{ textShadow: '0 0 3px #000, 0 0 3px #000, 0 0 3px #000' }}
        >
          {text}
        </Stack.Item>
      ) : null}
    </Stack>
  );
};

export const IconDots = (props) => {
  return (
    <Box position="relative" ml={-2} mt={-2}>
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0}
        left={0}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0}
        left={0.75}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0}
        left={1.5}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0.75}
        left={0}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0.75}
        left={0.75}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0.75}
        left={1.5}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={1.5}
        left={0}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={1.5}
        left={0.75}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={1.5}
        left={1.5}
        size={0.5}
      />
    </Box>
  );
};

export const ScreenHome = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { act, data } = useBackend<Data>();
  const { setApp } = props;
  const navigateTo = (app: NavigableApps) => {
    // act('keyboard_click') // CRIMSON EDIT REMOVAL: screen taps
    setApp(app);
  };
  const { time, date, background_url } = data;
  const convertTo12Hour = (timeStr: string) => {
    const [hourStr, minute] = timeStr.split(':');
    const hour = parseInt(hourStr, 10);
    const period = hour >= 12 ? 'PM' : 'AM';
    const displayHour = hour % 12 || 12;
    return `${displayHour}:${minute} ${period}`;
  };
  const displayTime = convertTo12Hour(time);

  const homeBackground = background_url
    ? backgrounds[background_url] || background_url
    : 'modular_darkpack/modules/phones/icons/backgrounds/pixel1-background-975028_1280.webp';

  // check for unread conversations
  let unreadCount = 0;
  const seenConversations = JSON.parse(
    localStorage.getItem('seen_conversations') || '{}',
  );
  if (data.conversations) {
    data.conversations.forEach((conv) => {
      const lastSeen = seenConversations[conv.number] || 0;
      if (
        lastSeen === 0 ||
        (conv.last_timestamp && conv.last_timestamp > lastSeen)
      ) {
        unreadCount++;
      }
    });
  }
  return (
    <Box
      style={{
        backgroundImage: `url("${homeBackground}")`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        height: '100%',
        width: '100%',
      }}
    >
      <Stack fill vertical>
        <Stack.Item grow>
          <Stack align="center" justify="space-between">
            <Stack.Item>
              <Box
                inline
                fontFamily="sans-serif"
                fontSize={4}
                ml={2}
                mt={2}
                style={{
                  textShadow: '0 0 3px #000, 0 0 3px #000, 0 0 3px #000',
                }}
              >
                {displayTime}
              </Box>
              <Box
                ml={2.5}
                style={{
                  textShadow: '0 0 3px #000, 0 0 3px #000, 0 0 3px #000',
                }}
              >
                {date}
              </Box>
            </Stack.Item>
            <Stack.Item mr={2}>
              <Icon
                name="cloud"
                size={2}
                style={{ filter: 'drop-shadow(0 0 4px #000a)' }}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack fill align="center" justify="space-around" wrap="wrap">
            <Stack.Item>
              <AppIcon
                backgroundColor="#505050"
                text="Settings"
                iconName="cogs"
                iconColor="white"
                onClick={() => navigateTo(NavigableApps.Settings)}
              />
            </Stack.Item>
            <Stack.Item>
              <AppIcon
                backgroundColor="#fff"
                text="Gallery"
                iconName="file-image"
                iconColor="orange"
              />
            </Stack.Item>
            <Stack.Item>
              <AppIcon
                backgroundColor="#fff"
                text="Camera"
                iconName="camera"
                iconColor="black"
              />
            </Stack.Item>
            <Stack.Item>
              <AppIcon
                backgroundColor="#4a90e2"
                text="EndPost"
                iconName="bullhorn"
                iconColor="white"
                onClick={() => navigateTo(NavigableApps.Endpost)}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {/* Screen dots */}
        <Stack.Item height={1} p={2}>
          <Stack fill align="center" justify="center">
            <Stack.Item p={1}>
              <Icon
                name="house"
                color="white"
                style={{ filter: 'drop-shadow(0 0 4px #000a)' }}
              />
            </Stack.Item>
            <Stack.Item p={1}>
              <Icon
                name="circle"
                color="#ffffffa0"
                style={{ filter: 'drop-shadow(0 0 4px #000a)' }}
              />
            </Stack.Item>
            <Stack.Item p={1}>
              <Icon
                name="circle"
                color="#ffffffa0"
                style={{ filter: 'drop-shadow(0 0 4px #000a)' }}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {/* Bottom Bar */}
        <Stack.Item height={5} p={1} mb={7}>
          <Stack fill align="center" justify="space-around">
            <Stack.Item>
              <AppIcon
                backgroundColor="#00dd00"
                iconColor="white"
                iconName="phone"
                text="Phone"
                onClick={() => navigateTo(NavigableApps.Phone)}
              />
            </Stack.Item>
            <Stack.Item>
              <AppIcon
                backgroundColor="#e58e1d"
                iconColor="white"
                iconName="user"
                text="Contacts"
                onClick={() => navigateTo(NavigableApps.Contacts)}
              />
            </Stack.Item>
            <Stack.Item>
              <AppIcon
                backgroundColor="blue"
                iconColor="white"
                iconName="comments"
                text="Message+"
                notification={unreadCount}
                onClick={() => navigateTo(NavigableApps.Messages)}
              />
            </Stack.Item>
            <Stack.Item>
              <AppIcon
                backgroundColor="#00f7ffff"
                text="Browser"
                iconName="globe-americas"
                iconColor="black"
                onClick={() => navigateTo(NavigableApps.Browser)}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};
