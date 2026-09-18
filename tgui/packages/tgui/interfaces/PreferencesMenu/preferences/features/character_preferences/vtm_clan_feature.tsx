import {
  CheckboxInput,
  type FeatureChoiced,
  FeatureExternalInput,
  type FeatureToggle,
  type FeatureValueProps,
} from '../base';

export const clan_mark: FeatureChoiced = {
  name: 'Marks',
  component: (props: FeatureValueProps<string, string>) => {
    return <FeatureExternalInput {...props} />;
  },
};

export const gargoyle_legs_and_tail: FeatureToggle = {
  name: 'Gargoyle Legs and Tail',
  component: CheckboxInput,
};
