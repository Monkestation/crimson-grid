// THIS IS A DARKPACK UI FILE
import { CheckboxInput } from '../base'
import type { FeatureToggle } from '../base';

export const looc_admin_pref: FeatureToggle = {
  name: 'See admin LOOC',
  category: 'ADMIN',
  description:
    'Toggles whether you want to see LOOC anywhere as an admin or not.',
  component: CheckboxInput,
};
