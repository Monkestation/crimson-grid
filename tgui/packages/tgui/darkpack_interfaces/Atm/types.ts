import type { BooleanLike } from 'tgui-core/react';

export type ATMData = {
  logged_in: BooleanLike;
  card: BooleanLike;
  entered_code: string | number | null;
  atm_balance: number;

  // These exist only when a card is inserted:
  account_balance: number;
  account_holder: string;
  account_id: number;
  bank_pin: string;
};
