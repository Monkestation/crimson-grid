//THIS IS A DARKPACK UI FILE
import { useBackend } from '../backend';
import { Box, Button, Section, Table, DmIcon } from 'tgui-core/components';
import { Window } from '../layouts';

type Product = {
  name: string;
  path: string;
  price: number;
  stock: number;
  available: boolean;
  ref: string;
  icon: string;
  icon_state: string;
}

type User = {
  points: number;
  name: string;
  has_dark_thaumaturgy: boolean;
  has_privileges: boolean;
}

type SpellbookVendorData = {
  product_records: Product[];
  user: User | null;
}

const STYLE = {
  section: {
    backgroundColor: '#001a00',
    borderColor: '#004d00',
    color: '#248f24',
  },
  tableDark: {
    backgroundColor: '#0d0000',
  },
  row: {
    backgroundColor: '#001a00',
    borderColor: '#004d00',
  },
};

const ProductRow = (props) => {
  const { product, user, onPurchase } = props;
  const inStock = product.stock > 0;
  const canAfford = user && product.price <= user.points;

  return (
    <Table.Row style={STYLE.row}>
      <Table.Cell style={{ color: '#248f24' }}>
        <DmIcon
          icon={product.icon}
          icon_state={product.icon_state}
          style={{
            verticalAlign: 'middle',
            filter: inStock
              ? 'hue-rotate(0deg) saturate(1.2) brightness(0.9)'
              : 'grayscale(100%) brightness(0.5)',
          }}
        />{' '}
        <b style={{ color: inStock ? '#00b300' : '#666666' }}>{product.name}</b>
        <br />
        <span style={{ fontSize: '0.8em', color: inStock ? '#996666' : '#555555' }}>
          Stock: {product.stock || 0}
        </span>
      </Table.Cell>
      <Table.Cell>
        <Button
          disabled={!canAfford || !inStock}
          onClick={() => onPurchase(product.ref)}
          style={{ minWidth: '105px', textAlign: 'center' }}
        >
          {inStock ? `${product.price || 0} favor` : 'Out of Stock!'}
        </Button>
      </Table.Cell>
    </Table.Row>
  );
};

export const BaaliSpellbookVendor = (props) => {
  const { act, data } = useBackend<SpellbookVendorData>();

  const { product_records = [], user } = data;
  const greeting = 'Greetings, accursed...';

  return (
    <Window width={465} height={700} theme="blood_cult">
      <Window.Content scrollable>
        <Section title="Infernalist" style={STYLE.section}>
          {user && (
            <Box style={{ color: '#248f24' }}>
              {greeting}
              <br />
              You have <b style={{ color: '#00b300' }}>{user.points} favor</b>.
            </Box>
          )}
        </Section>

        <Section title="Infernal Compendium" style={STYLE.section}>
          <Table style={STYLE.tableDark}>
            {product_records.map((product) => (
              <ProductRow
                key={product.name}
                product={product}
                user={user}
                onPurchase={(ref) => act('purchase', { ref })}
              />
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
