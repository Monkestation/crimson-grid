import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { Loader } from '../common/Loader';
import { ListInputModal } from './ListInputModal';

type ListInputData = {
  init_value: string;
  items: string[];
  large_buttons: boolean;
  message: string;
  timeout: number;
  title: string;
  autofocus: boolean; // DARKPACK EDIT ADD - autofocus: boolean;
};

export const ListInputWindow = () => {
  const { act, data } = useBackend<ListInputData>();
  const {
    items = [],
    message = '',
    init_value,
    large_buttons,
    timeout,
    title,
    autofocus, // DARKPACK EDIT ADD - autofocus,
  } = data;

  // Dynamically changes the window height based on the message.
  const windowHeight =
    325 + Math.ceil(message.length / 3) + (large_buttons ? 5 : 0);

  return ( // DARKPACK EDIT ADD - Line 42 autofocus={autofocus}
    <Window title={title} width={325} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content>
        <ListInputModal
          items={items}
          default_item={init_value}
          message={message}
          on_selected={(entry) => act('submit', { entry })}
          on_cancel={() => act('cancel')}
          autofocus={autofocus}
        />
      </Window.Content>
    </Window>
  );
};
