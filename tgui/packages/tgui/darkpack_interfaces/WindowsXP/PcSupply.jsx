import { Box, Button, Section, Stack, Table } from 'tgui-core/components';
import { useProgram } from './useProgram';

export const PcSupply = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const { packs = [], cart = [] } = data.supply || data;

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section title="Available Supply Packs (Long-range)" fill scrollable>
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Cost</Table.Cell>
              <Table.Cell>Description</Table.Cell>
              <Table.Cell />
            </Table.Row>
            {packs.map((pack) => (
              <Table.Row key={pack.id}>
                <Table.Cell>{pack.name}</Table.Cell>
                <Table.Cell fontFamily="monospace">{pack.cost} ₡</Table.Cell>
                <Table.Cell>{pack.desc}</Table.Cell>
                <Table.Cell>
                  <Button
                    icon="cart-plus"
                    content="Order"
                    onClick={() => act('order', { id: pack.id })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
      {cart.length > 0 && (
        <Stack.Item>
          <Section title="Pending Requests">
            {cart.map((item, i) => (
              <Box key={i}>
                {item.name} × {item.amount}
              </Box>
            ))}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};
