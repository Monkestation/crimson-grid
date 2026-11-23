/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const THEMES = ['light', 'dark', 'vampire'] as const; // DARKPACK EDIT CHANGE - Vampire Theme - ORIGINAL: export const THEMES = ['light', 'dark'] as const;

export const COLORS = {
  DARK: {
    BG_BASE: '#202020',
    BG_SECOND: '#151515',
    BUTTON: '#404040',
    TEXT: '#A6A6A6',
    TEXT_IMPORTANT: '#A6A6A6',
    BG_IMPORTANT: '#492020',
  },
  LIGHT: {
    BG_BASE: '#EEEEEE',
    BG_SECOND: '#FFFFFF',
    BUTTON: '#FFFFFF',
    TEXT: '#000000',
    TEXT_IMPORTANT: '#A6A6A6',
    BG_IMPORTANT: '#910707',
  },
  // DARKPACK EDIT ADD START - Vampire Theme
  VAMPIRE: {
    BG_BASE: '#1a0505',
    BG_SECOND: '#0f0202',
    BUTTON: '#2d0909',
    TEXT: '#d4a574',
    TEXT_IMPORTANT: '#e6b888',
    BG_IMPORTANT: '#5c0f0f',
  },
  // DARKPACK EDIT ADD END - Vampire Theme
} as const;

export const SETTINGS_TABS = [
  {
    id: 'general',
    name: 'General',
  },

  {
    id: 'textHighlight',
    name: 'Text Highlights',
  },
  {
    id: 'chatPage',
    name: 'Chat Tabs',
  },
  {
    id: 'statPanel',
    name: 'Stat Panel',
  },
  {
    id: 'websocket',
    name: 'Websocket',
  },
] as const;

export const FONTS_DISABLED = 'Default';

export const FONTS = [
  FONTS_DISABLED,
  'Verdana',
  'Arial',
  'Arial Black',
  'Comic Sans MS',
  'Impact',
  'Lucida Sans Unicode',
  'Tahoma',
  'Trebuchet MS',
  'Courier New',
  'Lucida Console',
] as const;

export const WARN_AFTER_HIGHLIGHT_AMT = 10;
