// THIS IS A CRIMSON UI FILE: Add new field for setting custom phone contact ID
import { type Feature, FeatureShortTextInput } from '../base';

export const phone_contact_name: Feature<string> = {
  name: 'Phone Contact Name',
  description:
    "Your display name for your phone contact. Blank uses your character's name.",
  component: FeatureShortTextInput,
};
