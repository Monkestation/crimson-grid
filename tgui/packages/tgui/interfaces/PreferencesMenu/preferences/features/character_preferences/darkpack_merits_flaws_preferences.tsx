// THIS IS A DARKPACK UI FILE
import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const territorial: FeatureChoiced = {
  name: 'Territory',
  description: 'The Hunting Territory of this character.',
  component: FeatureDropdownInput,
};

export const prey_exclusion: FeatureChoiced = {
  name: 'Prey Exclusion',
  description: 'The Prey Exclusion of this character.',
  component: FeatureDropdownInput,
};

export const missing_arm: FeatureChoiced = {
  name: 'Missing Arm',
  component: FeatureDropdownInput,
};

export const lame_leg: FeatureChoiced = {
  name: 'Lame Leg',
  component: FeatureDropdownInput,
};

export const acute_sense: FeatureChoiced = {
  name: 'Acute Sense',
  component: FeatureDropdownInput,
};

export const fetish_merit: FeatureChoiced = {
  name: 'Fetish',
  description: 'Choice of fetish.',
  component: FeatureDropdownInput,
};
