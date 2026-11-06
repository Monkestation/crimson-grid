// THIS IS A DARKPACK UI FILE
import { CheckboxInput, type FeatureToggle } from '../base';

export const enable_legacy_driving_controls: FeatureToggle = {
  name: 'Enable Legacy Driving Controls',
  category: 'GAMEPLAY',
  description: `
    Enables legacy driving controls, such as reverse-turning being inverted.
    Disable for a more consistent experience with other driving games.
  `,
  component: CheckboxInput,
};
