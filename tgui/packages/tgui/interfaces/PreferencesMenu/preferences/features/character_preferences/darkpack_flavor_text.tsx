// THIS IS A DARKPACK UI FILE
import {
  type Feature,
  FeatureTextInput,
  FeatureShortTextInput,
  FeatureToggle,
  CheckboxInput,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const flavor_text: Feature<string> = {
  name: 'Flavor Text',
  description: "Appears when your character is examined (but only if they're identifiable - try a gas mask).",
  component: FeatureTextInput,
};

export const war_form_flavor_text: Feature<string> = {
  name: 'Flavor Text (War form)',
  description: "Appears when your character is examined as a war form fera (Crinos). This replaces the main flavor text section.",
  component: FeatureTextInput,
};

export const feral_form_flavor_text: Feature<string> = {
  name: 'Flavor Text (Feral form)',
  description: "Appears when your character is examined as a feral and dire form fera (Hispo/Lupus). This replaces the main flavor text section.",
  component: FeatureTextInput,
};

export const nsfw_flavor_text: Feature<string> = {
  name: 'Flavor Text (NSFW)',
  description: "Appears when your character is examined (but only if they're identifiable - try a gas mask).",
  component: FeatureTextInput,
};

export const character_notes: Feature<string> = {
  name: 'Character Notes',
  description:
    'OOC information about your character specifically! Like if you want a human ghouled or embraced.',
  component: FeatureTextInput,
};

export const ooc_notes: Feature<string> = {
  name: 'OOC Notes (NSFW)',
  description: 'Anything you want other players to know about you goes here, such as antag information, OOC triggers, etc.',
  component: FeatureTextInput,
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const criminal_record: Feature<string> = {
  name: 'Records (Criminal)',
  description: 'Viewable with security access. For criminal records, arrest history, things like that.',
  component: FeatureTextInput,
};

export const medical_record: Feature<string> = {
  name: 'Records (Medical)',
  description: 'Viewable with medical access. For things like medical history, prescriptions, DNR orders, etc.',
  component: FeatureTextInput,
};

export const exploitable_info: Feature<string> = {
  name: 'Records (Exploitable)',
  description:
    'Can be IC or OOC. Viewable by certain antagonists, as well as ghosts. Generally contains \
  things like weaknesses, strengths, important background, trigger words, etc. It ALSO may contain things like \
  antagonist preferences, e.g. if you want to be antagonized, by whom, with what, etc.',
  component: FeatureTextInput,
};

export const background_info: Feature<string> = {
  name: 'Records (Background)',
  description: 'Only viewable by yourself and ghosts. You can have whatever you want in here - it may be valuable as a way to orient yourself to what your character is.',
  component: FeatureTextInput,
};

export const illegal_identity: Feature<string> = {
  name: 'Fake Name',
  description:
    'What name is going to be on your fake documents, if you have any?',
  component: FeatureShortTextInput,
};

export const fake_age: Feature<string> = {
  name: 'Fake Age',
  description:
    'What age is going to be on your fake documents, if you have any?',
  component: FeatureShortTextInput,
};

export const fake_organ_donor: FeatureToggle = {
  name: 'Fake Organ Donor',
  description:
    'What organ donor status is going to be on your fake documents, if you have any?',
  component: CheckboxInput,
};

export const fake_gender: Feature<string> = {
  name: 'Fake Gender Marker',
  description:
    'What gender marker is going to be on your fake documents, if you have any?',
  component: FeatureDropdownInput,
};

export const organ_donor: FeatureToggle = {
  name: 'Organ Donor',
  description:
    'Are you an organ donor?',
  component: CheckboxInput,
};
