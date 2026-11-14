import { useBackend } from 'tgui/backend';

export const useProgram = (id, context) => {
  const { act, data } = useBackend(context);
  return {
    act: (action, params = {}) => act(action, { ...params, program: id }),
    data: data.program_data?.[id] || {},
  };
};
