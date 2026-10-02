import { useState } from 'react';
import { Box, Button, Input, LabeledList, Section } from 'tgui-core/components';

import { useBackend } from '../../backend';

import type { ATMData } from './types';

export const AtmMain = (props) => {
  const { act, data } = useBackend<ATMData>();
  const [withdrawAmount, setWithdrawAmount] = useState('');
  const [newPin, setNewPin] = useState('');

  const { account_holder, atm_balance, account_balance } = data;

  const handleLogout = () => {
    act('logout');
  };

  const handleWithdraw = () => {
    act('withdraw', { withdraw_amount: withdrawAmount });
  };

  const handleDeposit = () => {
    act('deposit');
  };

  const handleChangePin = () => {
    act('change_pin', { new_pin: newPin });
  };

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Account Owner">
          {account_holder}
        </LabeledList.Item>
        <LabeledList.Item label="Balance">{account_balance}</LabeledList.Item>
        <LabeledList.Item label="Money in ATM">{atm_balance}</LabeledList.Item>
      </LabeledList>
      <Box mt={2}>
        <Box className="Atm__atm-column">
          <Box className="Atm__atm-row">
            <Button
              onClick={handleWithdraw}
              className="Atm__atm-button"
            >
              Withdraw
            </Button>
            <Input
              value={withdrawAmount}
              onChange={setWithdrawAmount}
              placeholder="Withdraw Amount"
              style={{ flex: 3 }}
            />
          </Box>

          <Box className="Atm__atm-row">
            <Button onClick={handleChangePin} className="Atm__atm-button">
              Change Pin
            </Button>
            <Input
              value={newPin}
              onChange={setNewPin}
              placeholder="New PIN"
              style={{ flex: 3 }}
            />
          </Box>

          <Box className="Atm__atm-row">
            <Button onClick={handleDeposit} className="Atm__atm-button">
              Deposit
            </Button>
          </Box>

          <Box className="Atm__atm-row">
            <Button onClick={handleLogout} className="Atm__atm-button">
              Log Out
            </Button>
          </Box>
        </Box>
      </Box>
    </Section>
  );
};
