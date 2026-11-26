// THIS IS A DARKPACK UI FILE
import type React from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type DrugDeal = {
  id: string;
  drug: string;
  amount: number;
  delivered: number;
  min_purity: number;
  est_pay: number;
  accepted: BooleanLike;
  tracking: BooleanLike;
  seconds_left: number;
};

type DealerData = {
  dealer_enabled: BooleanLike;
  drug_deals: DrugDeal[];
};

const formatTime = (seconds: number) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
};

const DealCard = (props: { deal: DrugDeal }) => {
  const { act } = useBackend<DealerData>();
  const { deal } = props;
  const accepted = !!deal.accepted;

  return (
    <Box
      mb={1}
      p={1}
      style={{
        background: 'rgba(255, 255, 255, 0.08)',
        borderRadius: '8px',
        borderLeft: `4px solid ${accepted ? '#4caf50' : '#ffb300'}`,
      }}
    >
      <Stack justify="space-between" align="center">
        <Stack.Item bold>
          {deal.amount}x {deal.drug}
        </Stack.Item>
        <Stack.Item color="good" bold>
          ~${deal.est_pay}
        </Stack.Item>
      </Stack>
      <Box color="label" fontSize="12px" mt={0.5}>
        {deal.min_purity > 0
          ? `Wants at least ${deal.min_purity}% pure`
          : 'Any quality'}
        {accepted && ` | ${deal.delivered}/${deal.amount} delivered`}
      </Box>
      <Box color="label" fontSize="12px">
        <Icon name="clock" mr={0.5} />
        {accepted ? 'Meet window: ' : 'Offer expires: '}
        {formatTime(deal.seconds_left)}
      </Box>
      <Stack mt={1}>
        {accepted ? (
          <Stack.Item grow>
            <Button
              fluid
              icon="location-arrow"
              color={deal.tracking ? 'good' : 'default'}
              onClick={() => act('deal_track', { id: deal.id })}
            >
              {deal.tracking ? 'Tracking' : 'Track drop-off'}
            </Button>
          </Stack.Item>
        ) : (
          <>
            <Stack.Item grow>
              <Button
                fluid
                icon="check"
                color="good"
                onClick={() => act('deal_accept', { id: deal.id })}
              >
                Accept
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fluid
                icon="xmark"
                color="bad"
                onClick={() => act('deal_decline', { id: deal.id })}
              >
                Decline
              </Button>
            </Stack.Item>
          </>
        )}
        {accepted && (
          <Stack.Item>
            <Button
              icon="xmark"
              color="bad"
              tooltip="Call it off"
              onClick={() => act('deal_decline', { id: deal.id })}
            />
          </Stack.Item>
        )}
      </Stack>
    </Box>
  );
};

export const ScreenDealer = (props: {
  setApp: React.Dispatch<React.SetStateAction<any>>;
}) => {
  const { act, data } = useBackend<DealerData>();
  const { setApp } = props;
  const deals = data.drug_deals || [];
  const enabled = !!data.dealer_enabled;

  return (
    <Box
      height="100%"
      p={1}
      pb={4}
      textColor="#fff"
      style={{ background: 'rgba(0, 0, 0, 0.82)', overflowY: 'auto' }}
    >
      <Stack align="center" mb={1}>
        <Stack.Item>
          <Button icon="chevron-left" onClick={() => setApp(null)} />
        </Stack.Item>
        <Stack.Item grow bold fontSize="16px">
          Dealer
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="power-off"
            color={enabled ? 'good' : 'bad'}
            tooltip={
              enabled ? 'Stop receiving offers' : 'Start receiving offers'
            }
            onClick={() => act('dealer_toggle')}
          />
        </Stack.Item>
      </Stack>
      {!enabled && (
        <Box color="label" textAlign="center" mt={4}>
          You're off the clock. Power the app on to start getting offers.
        </Box>
      )}
      {enabled && deals.length === 0 && (
        <Box color="label" textAlign="center" mt={4}>
          No offers right now. Keep your phone on you and your stock ready.
        </Box>
      )}
      {enabled && deals.map((deal) => <DealCard key={deal.id} deal={deal} />)}
    </Box>
  );
};
