import { CheckboxInput, type FeatureToggle, FeatureSliderInput, type FeatureNumeric } from '../base';

export const blooper_send: FeatureToggle = {
  name: 'Enable sending vocal bloopers',
  category: 'SOUND',
  description:
    'When enabled, plays a customizable sound effect when your character speaks.',
  component: CheckboxInput,
};

export const blooper_hear: FeatureToggle = {
  name: 'Enable hearing vocal bloopers',
  category: 'SOUND',
  description: `When enabled, allows you to hear other character's speech sounds.`,
  component: CheckboxInput,
};

export const sound_blooper_volume: FeatureNumeric = {
  name: 'Character Voice Volume',
  category: 'SOUND',
  description: 'The volume that the Vocal Barks sounds will play at.',
  component: FeatureSliderInput,
};
