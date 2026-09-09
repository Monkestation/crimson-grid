import { CheckboxInput, type FeatureToggle } from '../base';

export const spawn_wallet: FeatureToggle = {
  name: 'Spawn with Wallet',
  description:
    'If checked, your character will spawn with a wallet to hold relevant job items. Otherwise, those items will be quick equipped if possible.',
  component: CheckboxInput,
};
