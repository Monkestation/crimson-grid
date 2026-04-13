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
  component: FeatureDropdownInput
}
