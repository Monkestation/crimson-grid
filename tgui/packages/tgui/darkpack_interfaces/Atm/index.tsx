import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { AtmLogin } from './AtmLogin';
import { AtmMain } from './AtmMain';

import type { ATMData } from './types';

export const Atm = (props) => {
  const { act, data } = useBackend<ATMData>();
  return (
    <Window width={300} height={400} theme="retro">
      <Window.Content>
        {data.logged_in ? (
          <AtmMain data={data} act={act} />
        ) : (
          <AtmLogin data={data} act={act} />
        )}
      </Window.Content>
    </Window>
  );
};
