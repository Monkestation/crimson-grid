import type { BooleanLike } from 'tgui-core/react';

import type { sendAct } from '../../events/act';
import type {
  LoadoutCategory,
  LoadoutList,
  typePath,
} from './CharacterPreferences/loadout/base';
import type { Gender } from './preferences/gender';

export enum Food {
  Alcohol = 'ALCOHOL',
  Breakfast = 'BREAKFAST',
  Bugs = 'BUGS',
  Cloth = 'CLOTH',
  Dairy = 'DAIRY',
  Fried = 'FRIED',
  Fruit = 'FRUIT',
  Gore = 'GORE',
  Grain = 'GRAIN',
  Gross = 'GROSS',
  Junkfood = 'JUNKFOOD',
  Meat = 'MEAT',
  Nuts = 'NUTS',
  Oranges = 'ORANGES',
  Pineapple = 'PINEAPPLE',
  Raw = 'RAW',
  Seafood = 'SEAFOOD',
  Stone = 'STONE',
  Sugar = 'SUGAR',
  Toxic = 'TOXIC',
  Vegetables = 'VEGETABLES',
  Egg = 'EGG',
}

export enum JobPriority {
  Low = 1,
  Medium = 2,
  High = 3,
}

export type Name = {
  can_randomize: BooleanLike;
  explanation: string;
  group: string;
};

export type Species = {
  name: string;
  desc: string;
  lore: string[];
  icon: string;

  use_skintones: BooleanLike;
  sexes: BooleanLike;

  enabled_features: string[];

  perks: {
    positive: Perk[];
    negative: Perk[];
    neutral: Perk[];
  };

  diet?: {
    liked_food: Food[];
    disliked_food: Food[];
    toxic_food: Food[];
  };
};

// DARKPACK EDIT START - DISCIPLINES
export type DisciplineInfo = {
  name: string;
  desc: string;
  max_level: number;
  rarity: 'rare' | 'common';
  icon?: string;
  icon_state?: string;
};
// DARKPACK EDIT END - DISCIPLINES

export type Splats = { // DARKPACK EDIT ADD START - SPLATS
  name: string;
  desc: string;
  lore: string[];
  icon: string;

  use_skintones: BooleanLike;
  sexes: BooleanLike;

  enabled_features: string[];

  perks: {
    positive: Perk[];
    negative: Perk[];
    neutral: Perk[];
  };

  diet?: {
    liked_food: Food[];
    disliked_food: Food[];
    toxic_food: Food[];
  };
}; // DARKPACK EDIT ADD END - SPLATS

export type Perk = {
  ui_icon: string;
  name: string;
  description: string;
};

export type Department = {
  head?: string;
};

export type Job = {
  description: string;
  department: string;
  // DARKPACK EDIT ADD - ALTERNATIVE_JOB_TITLES
  alt_titles?: string[];
};

export type Quirk = {
  description: string;
  icon: string;
  name: string;
  value: number;
  customizable: boolean;
  customization_options?: string[];
};

export type QuirkInfo = {
  max_positive_quirks: number;
  quirk_info: Record<string, Quirk>;
  quirk_blacklist: string[][];
  points_enabled: boolean;
};

export type Personality = {
  name: string;
  description: string;
  pos_gameplay_description: string | null;
  neg_gameplay_description: string | null;
  neut_gameplay_description: string | null;
  path: typePath;
  groups: string[] | null;
};

export enum RandomSetting {
  AntagOnly = 1,
  Disabled = 2,
  Enabled = 3,
}

export enum JoblessRole {
  BeOverflow = 1,
  BeRandomJob = 2,
  ReturnToLobby = 3,
}

export enum GamePreferencesSelectedPage {
  Settings,
  Keybindings,
}

export const createSetPreference =
  (act: typeof sendAct, preference: string) => (value: unknown) => {
    act('set_preference', {
      preference,
      value,
    });
  };

export enum PrefsWindow {
  Character = 0,
  Game = 1,
  Keybindings = 2,
}

export type CharacterPreferencesData = {
  clothing: Record<string, string>;
  features: Record<string, string>;
  game_preferences: Record<string, unknown>;
  non_contextual: {
    random_body: RandomSetting;
    [otherKey: string]: unknown;
  };
  secondary_features: Record<string, unknown>;
  supplemental_features: Record<string, unknown>;
  manually_rendered_features: Record<string, string>;

  names: Record<string, string>;

  misc: {
    gender: Gender;
    joblessrole: JoblessRole;
    species: string;
    splats: string; // DARKPACK EDIT ADD - SPLATS
    loadout_list: LoadoutList;
    job_clothes: BooleanLike;
  };

  randomization: Record<string, RandomSetting>;
};

export type PreferencesMenuData = {
  character_preview_view: string;
  character_profiles: (string | null)[];

  character_preferences: CharacterPreferencesData;

  content_unlocked: BooleanLike;

  job_bans?: string[];
  job_days_left?: Record<string, number>;
  job_required_experience?: Record<
    string,
    {
      experience_type: string;
      required_playtime: number;
    }
  >;
  job_preferences: Record<string, JobPriority>;
// DARKPACK EDIT ADD -  ALTERNATIVE_JOB_TITLES
  job_alt_titles: Record<string, string>;
  keybindings: Record<string, string[]>;
  overflow_role: string;
  default_quirk_balance: number;
  selected_quirks: string[];
  selected_personalities: typePath[] | null;
  max_personalities: number;
  mood_enabled: BooleanLike;
  splat_disallowed_quirks: string[]; // DARKPACK EDIT CHANGE - SPLATS
  // DARKPACK EDIT ADD START - DISCIPLINES
  discipline_levels: Record<string, number>;
  clan_disciplines: string[];
  clan_name: string | null;
  discipline_points_available: number;
  discipline_points_spent: number;
  discipline_tier: string;
  discipline_tier_details: string;
  is_trusted: BooleanLike;
  max_trusted_generation: number;
  max_public_generation: number;
  highest_generation_limit: number;
  // DARKPACK EDIT ADD END - DISCIPLINES

  // DARKPACK EDIT ADD START
  stats: Record<
    string,
    {
      name: string;
      desc: string;
      score: number;
      bonus_score: number;
      max_score: number;
      editable: number;
      category: string;
      subcategory: string;
      points: number;
      abstract_type: string;
    }
  >;
  // DARKPACK EDIT ADD END

  antag_bans?: string[];
  antag_days_left?: Record<string, number>;
  selected_antags: string[];

  active_slot: number;
  name_to_use: string;

  window: PrefsWindow;
};

export type ServerData = {
  jobs: {
    departments: Record<string, Department>;
    jobs: Record<string, Job>;
  };
  names: {
    types: Record<string, Name>;
  };
  quirks: QuirkInfo;
  personality: {
    personalities: Personality[];
    personality_incompatibilities: Record<string, string[]>;
  };
  random: {
    randomizable: string[];
  };
  loadout: {
    loadout_tabs: LoadoutCategory[];
  };
  species: Record<string, Species>;
  // DARKPACK EDIT START
  splats: Record<string, Splats>;
  disciplines: Record<string, DisciplineInfo>;
  // DARKPACK EDIT END
  [otherKey: string]: unknown;
};
