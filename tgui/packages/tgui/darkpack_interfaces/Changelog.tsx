// SPLIT_CHANGELOG
import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { Component, Fragment } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Image,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { sendAct as act } from '../events/act';
import { Window } from '../layouts';

const icons = {
  add: { icon: 'check-circle', color: 'green' },
  admin: { icon: 'user-shield', color: 'purple' },
  balance: { icon: 'balance-scale-right', color: 'yellow' },
  bugfix: { icon: 'bug', color: 'green' },
  code_imp: { icon: 'code', color: 'green' },
  config: { icon: 'cogs', color: 'purple' },
  expansion: { icon: 'check-circle', color: 'green' },
  experiment: { icon: 'radiation', color: 'yellow' },
  image: { icon: 'image', color: 'green' },
  imageadd: { icon: 'tg-image-plus', color: 'green' },
  imagedel: { icon: 'tg-image-minus', color: 'red' },
  qol: { icon: 'hand-holding-heart', color: 'green' },
  refactor: { icon: 'tools', color: 'green' },
  rscadd: { icon: 'check-circle', color: 'green' },
  rscdel: { icon: 'times-circle', color: 'red' },
  server: { icon: 'server', color: 'purple' },
  sound: { icon: 'volume-high', color: 'green' },
  soundadd: { icon: 'tg-sound-plus', color: 'green' },
  sounddel: { icon: 'tg-sound-minus', color: 'red' },
  spellcheck: { icon: 'spell-check', color: 'green' },
  map: { icon: 'map', color: 'green' },
  tgs: { icon: 'toolbox', color: 'purple' },
  tweak: { icon: 'wrench', color: 'green' },
  unknown: { icon: 'info-circle', color: 'label' },
  wip: { icon: 'hammer', color: 'orange' },
};

type Change = Record<string, string>;
type AuthorChanges = Record<string, Change[]>;
type ChangelogYaml = Record<string, AuthorChanges>;

type ChangelogState = {
  loaded_text: ChangelogYaml | string;
  darkpack_text: ChangelogYaml | string;
  crimson_text: ChangelogYaml | string; // CRIMSON EDIT ADD - SPLIT_CHANGELOG
  selectedDate: string;
  selectedIndex: number;
};

type ChangelogData = {
  dates: string[];
};

export class ChangelogContent extends Component<any, ChangelogState> {
  dateChoices: string[];

  constructor(props) {
    super(props);
    this.dateChoices = [];
    this.state = {
      loaded_text: 'Loading changelog data...',
      darkpack_text: 'Loading changelog data...',
      crimson_text: 'Loading changelog data...', // CRIMSON EDIT ADD - SPLIT_CHANGELOG
      selectedDate: '',
      selectedIndex: 0,
    };
  }

  setData(loaded_text) {
    this.setState({ loaded_text });
  }

  setEffigyData(darkpack_text) {
    this.setState({ darkpack_text });
  }

  // CRIMSON EDIT ADD START - SPLIT_CHANGELOG
  setCrimsonData(crimson_text) {
    this.setState({ crimson_text });
  }
  // CRIMSON EDIT ADD END

  setSelectedDate(selectedDate) {
    this.setState({ selectedDate });
  }

  setSelectedIndex(selectedIndex) {
    this.setState({ selectedIndex });
  }

  getData = (date, attemptNumber = 1) => {
    const maxAttempts = 6;

    if (attemptNumber > maxAttempts) {
      this.setData(`Failed to load data after ${maxAttempts} attempts`);
      this.setEffigyData(`Failed to load data after ${maxAttempts} attempts`);
      this.setCrimsonData(`Failed to load data after ${maxAttempts} attempts`); // CRIMSON EDIT ADD - SPLIT_CHANGELOG
      return;
    }

    act('get_month', { date });

    Promise.all([
      fetch(resolveAsset(`${date}.yml`)),
      fetch(resolveAsset(`darkpack_${date}.yml`)),
      fetch(resolveAsset(`crimson_${date}.yml`)), // CRIMSON EDIT ADD - SPLIT_CHANGELOG
    ]).then(async ([changelogData, darkpackData, crimsonData]) => {
      // CRIMSON EDIT CHANGE - SPLIT_CHANGELOG
      if (!changelogData.ok && !darkpackData.ok && !crimsonData.ok) {
        // CRIMSON EDIT CHANGE - SPLIT_CHANGELOG
        const timeout = 50 + attemptNumber * 50;

        this.setData(`Loading changelog data${'.'.repeat(attemptNumber + 3)}`);
        this.setEffigyData(
          `Loading changelog data${'.'.repeat(attemptNumber + 3)}`,
        );
        this.setCrimsonData(
          `Loading changelog data${'.'.repeat(attemptNumber + 3)}`,
        ); // CRIMSON EDIT ADD - SPLIT_CHANGELOG

        setTimeout(() => {
          this.getData(date, attemptNumber + 1);
        }, timeout);

        return;
      }

      if (changelogData.ok) {
        const result = await changelogData.text();

        this.setData(
          yaml.load(result, {
            schema: yaml.CORE_SCHEMA,
          }) as ChangelogYaml,
        );
      }

      if (darkpackData.ok) {
        const result = await darkpackData.text();

        this.setEffigyData(
          yaml.load(result, {
            schema: yaml.CORE_SCHEMA,
          }) as ChangelogYaml,
        );
      }
     // CRIMSON EDIT ADD START - SPLIT_CHANGELOG
      if (crimsonData.ok) {
        const result = await crimsonData.text();

        this.setCrimsonData(
          yaml.load(result, {
            schema: yaml.CORE_SCHEMA,
          }) as ChangelogYaml,
        );
      }
      // CRIMSON EDIT ADD END

    });
  };

  componentDidMount() {
    const { data } = useBackend<ChangelogData>();
    const { dates = [] } = data;

    this.dateChoices = dates.map((date) => dateformat(date, 'mmmm yyyy', true));

    if (dates.length > 0) {
      this.setSelectedDate(this.dateChoices[0]);
      this.getData(dates[0]);
    }
  }

  renderChangelogEntries(authors: AuthorChanges, server) {
    return Object.entries(authors).map(([name, changes]) => (
      <Fragment key={name}>
        <h4>
          <Image
            verticalAlign="bottom"
            src={resolveAsset(`${server}_16.png`)}
          />
          {name} changed:
        </h4>

        <Box ml={3}>
          <Table>
            {changes.map((change) => {
              const changeType = Object.keys(change)[0];

              return (
                <Table.Row key={changeType + change[changeType]}>
                  <Table.Cell
                    className={classes([
                      'Changelog__Cell',
                      'Changelog__Cell--Icon',
                    ])}
                  >
                    <Icon
                      color={
                        icons[changeType]
                          ? icons[changeType].color
                          : icons.unknown.color
                      }
                      name={
                        icons[changeType]
                          ? icons[changeType].icon
                          : icons.unknown.icon
                      }
                    />
                  </Table.Cell>

                  <Table.Cell className="Changelog__Cell">
                    {change[changeType]}
                  </Table.Cell>
                </Table.Row>
              );
            })}
          </Table>
        </Box>
      </Fragment>
    ));
  }

  render() {
    const { data } = useBackend<ChangelogData>();
    const { dates = [] } = data;

    const {
      loaded_text,
      darkpack_text,
      crimson_text,
      selectedIndex,
      selectedDate,
    } = this.state; // CRIMSON EDIT CHANGE - SPLIT_CHANGELOG

    const { dateChoices } = this;

    const dateDropdown = dateChoices.length > 0 && (
      <Stack>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === 0}
            icon="chevron-left"
            onClick={() => {
              const index = selectedIndex - 1;

              this.setData('Loading changelog data...');
              this.setEffigyData('Loading changelog data...');
              this.setCrimsonData('Loading changelog data...'); // CRIMSON EDIT CHANGE - SPLIT_CHANGELOG
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);

              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            autoScroll={false}
            options={dateChoices}
            onSelected={(value) => {
              const index = dateChoices.indexOf(value);

              this.setData('Loading changelog data...');
              this.setEffigyData('Loading changelog data...');
              this.setCrimsonData('Loading changelog data...'); // CRIMSON EDIT CHANGE - SPLIT_CHANGELOG
              this.setSelectedIndex(index);
              this.setSelectedDate(value);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
            selected={selectedDate}
            width="150px"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === dateChoices.length - 1}
            icon={'chevron-right'}
            onClick={() => {
              const index = selectedIndex + 1;

              this.setData('Loading changelog data...');
              this.setEffigyData('Loading changelog data...');
              this.setCrimsonData('Loading changelog data...'); // CRIMSON EDIT CHANGE - SPLIT_CHANGELOG
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
      </Stack>
    );
    // CRIMSON EDIT ADD BELOW - Original <h1>Darkpack: Second City</h1> and adds Darkpack: Second City to Thanks To
    const header = (
      <Section>
        <h1>Crimson Grid</h1>
        <p>
          <b>Thanks to: </b>
          Darkpack: Second City, The Final Nights, World of Darkness 13, RequiemSS13, TGstation,
          Baystation 12, /vg/station, NTstation, CDK Station devs,
          FacepunchStation, GoonStation devs, the original Space Station 13
          developers, Invisty for the title image and the countless others who
          have contributed to the game, issue tracker or wiki over the years.
        </p>
        <p>
          {'Current organization members can be found '}
          <a href="https://github.com/orgs/DarkPack13/people">here</a>
          {', recent GitHub contributors can be found '}
          <a href="https://github.com/DarkPack13/SecondCity/pulse/monthly">
            here
          </a>
          .
        </p>
        <p>
          {'You can also join our discord '}
          <a href="https://discord.gg/wT95uK8VZj">here</a>.
        </p>
        {dateDropdown}
      </Section>
    );

    const footer = (
      <Section>
        {dateDropdown}
        <h3>GoonStation 13 Development Team</h3>
        <p>
          <b>Coders: </b>
          Stuntwaffle, Showtime, Pantaloons, Nannek, Keelin, Exadv1, hobnob,
          Justicefries, 0staf, sniperchance, AngriestIBM, BrianOBlivion
        </p>
        <p>
          <b>Spriters: </b>
          Supernorn, Haruhi, Stuntwaffle, Pantaloons, Rho, SynthOrange, I Said
          No
        </p>
        <p>
          Traditional Games Space Station 13 is thankful to the GoonStation 13
          Development Team for its work on the game up to the
          {' r4407 release. The changelog for changes up to r4407 can be seen '}
          <a href="https://wiki.ss13.co/Pre-2016_Changelog#April_2010">here</a>.
        </p>
        <p>
          {'Except where otherwise noted, Goon Station 13 is licensed under a '}
          <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/">
            Creative Commons Attribution-Noncommercial-Share Alike 3.0 License
          </a>
          {'. Rights are currently extended to '}
          <a href="http://forums.somethingawful.com/">SomethingAwful Goons</a>
          {' only.'}
        </p>
        <h3>Traditional Games Space Station 13 License</h3>
        <p>
          {'All code after '}
          <a
            href={
              'https://github.com/tgstation/tgstation/commit/' +
              '333c566b88108de218d882840e61928a9b759d8f'
            }
          >
            commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at
            4:38 PM PST
          </a>
          {' is licensed under '}
          <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>
          {'. All code before that commit is licensed under '}
          <a href="https://www.gnu.org/licenses/gpl-3.0.html">GNU GPL v3</a>
          {', including tools unless their readme specifies otherwise. See '}
          <a href="https://github.com/tgstation/tgstation/blob/master/LICENSE">
            LICENSE
          </a>
          {' and '}
          <a href="https://github.com/tgstation/tgstation/blob/master/GPLv3.txt">
            GPLv3.txt
          </a>
          {' for more details.'}
        </p>
        <p>
          The TGS DMAPI API is licensed as a subproject under the MIT license.
          {' See the footer of '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/__DEFINES/tgs.dm'
            }
          >
            code/__DEFINES/tgs.dm
          </a>
          {' and '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/modules/tgs/LICENSE'
            }
          >
            code/modules/tgs/LICENSE
          </a>
          {' for the MIT license.'}
        </p>
        <p>
          {'All assets including icons and sound are under a '}
          <a href="https://creativecommons.org/licenses/by-sa/3.0/">
            Creative Commons 3.0 BY-SA license
          </a>
          {' unless otherwise indicated.'}
        </p>
      </Section>
    );

    const changelog = typeof loaded_text === 'object' ? loaded_text : null;

    const darkpackChangelog =
      typeof darkpack_text === 'object' ? darkpack_text : null;

    const crimsonChangelog = typeof crimson_text === 'object' ? crimson_text : null; // CRIMSON EDIT ADD - SPLIT_CHANGELOG

    const combinedDates = new Set([
      ...(changelog ? Object.keys(changelog) : []),
      ...(darkpackChangelog ? Object.keys(darkpackChangelog) : []),
      ...(crimsonChangelog ? Object.keys(crimsonChangelog) : []), // CRIMSON EDIT ADD - SPLIT_CHANGELOG
    ]);

    const changes = [...combinedDates]
      .sort()
      .reverse()
      .map((date) => (
        <Section key={date} title={dateformat(date, 'd mmmm yyyy', true)}>
          <Box ml={3}>
            {/* CRIMSON EDIT ADD START - SPLIT_CHANGELOG */}
            {crimsonChangelog?.[date] && (
              <Section>
                {this.renderChangelogEntries(crimsonChangelog[date], 'crimson')}
              </Section>
            )}
            {/* CRIMSON EDIT ADD END */}
            {darkpackChangelog?.[date] && (
              <Section>
                {this.renderChangelogEntries(
                  darkpackChangelog[date],
                  'darkpack',
                )}
              </Section>
            )}

            {changelog?.[date] && (
              <Section mt="-20px">
                {this.renderChangelogEntries(changelog[date], 'tg')}
              </Section>
            )}
          </Box>
        </Section>
      ));

    return (
      <>
        {header}
        {changes}
        {typeof loaded_text === 'string' && <p>{loaded_text}</p>}
        {footer}
      </>
    );
  }
}

export const Changelog = () => {
  return (
    <Window title="Changelog" width={675} height={650}>
      <Window.Content scrollable>
        <ChangelogContent />
      </Window.Content>
    </Window>
  );
};
