import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const Pager = ({ page, count, onPage }) => (
  <Box textAlign="center" mt={1}>
    <Button
      icon="chevron-left"
      disabled={page <= 1}
      onClick={() => onPage(page - 1)}
    />
    <Box inline mx={1}>
      Page {page} / {count}
    </Box>
    <Button
      icon="chevron-right"
      disabled={page >= count}
      onClick={() => onPage(page + 1)}
    />
  </Box>
);

export const PcCheckout = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const lib = data.checkout || data;

  const [tab, setTab] = useState('inventory');
  const [borrower, setBorrower] = useState('');
  const [minutes, setMinutes] = useState('30');

  if (lib.can_manage === false) {
    return (
      <NoticeBox danger>
        Librarian access required to manage checkouts.
      </NoticeBox>
    );
  }

  const inventory = Array.isArray(lib.inventory) ? lib.inventory : [];
  const checkouts = Array.isArray(lib.checkouts) ? lib.checkouts : [];

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab
            selected={tab === 'inventory'}
            onClick={() => setTab('inventory')}
          >
            Inventory
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'checkouts'}
            onClick={() => setTab('checkouts')}
          >
            Checked out ({checkouts.length ? '*' : '0'})
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>

      {!!lib.status && (
        <Stack.Item>
          <NoticeBox info>{lib.status}</NoticeBox>
        </Stack.Item>
      )}

      {tab === 'inventory' && (
        <>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Shelf inventory"
              buttons={
                <Button icon="sync" onClick={() => act('rescan')}>
                  Rescan shelves
                </Button>
              }
            >
              {inventory.length === 0 ? (
                <Box>No books in inventory.</Box>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell>Title</Table.Cell>
                    <Table.Cell>Author</Table.Cell>
                    <Table.Cell collapsing />
                  </Table.Row>
                  {inventory.map((book) => (
                    <Table.Row key={book.ref}>
                      <Table.Cell>{book.title}</Table.Cell>
                      <Table.Cell>{book.author}</Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          compact
                          icon="hand-holding"
                          selected={lib.selected_ref === book.ref}
                          disabled={book.on_loan}
                          tooltip={book.on_loan ? 'Already on loan' : undefined}
                          onClick={() => act('select', { ref: book.ref })}
                        >
                          Select
                        </Button>
                        <Button
                          compact
                          icon="trash"
                          color="bad"
                          tooltip="Remove from inventory"
                          onClick={() =>
                            act('inventory_remove', { ref: book.ref })
                          }
                        />
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
              <Pager
                page={lib.inventory_page || 1}
                count={lib.inventory_page_count || 1}
                onPage={(p) => act('inventory_page', { page: p })}
              />
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Check out">
              {lib.selected_title ? (
                <Stack align="center">
                  <Stack.Item grow>
                    <Box bold>{lib.selected_title}</Box>
                  </Stack.Item>
                  <Stack.Item width="160px">
                    <Input
                      fluid
                      value={borrower}
                      placeholder="Borrower"
                      onInput={(a, b) => setBorrower(readInput(a, b))}
                      onChange={(a, b) => setBorrower(readInput(a, b))}
                    />
                  </Stack.Item>
                  <Stack.Item width="70px">
                    <Input
                      fluid
                      value={minutes}
                      placeholder="Min"
                      onInput={(a, b) => setMinutes(readInput(a, b))}
                      onChange={(a, b) => setMinutes(readInput(a, b))}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="check"
                      onClick={() => {
                        act('checkout', { loaned_to: borrower, minutes });
                        setBorrower('');
                      }}
                    >
                      Check out
                    </Button>
                    <Button
                      icon="times"
                      onClick={() => act('clear_selection')}
                    />
                  </Stack.Item>
                </Stack>
              ) : (
                <Box>
                  Select a book above, or scan one with a barcode scanner.
                </Box>
              )}
            </Section>
          </Stack.Item>
        </>
      )}

      {tab === 'checkouts' && (
        <Stack.Item grow>
          <Section fill scrollable title="Checked out books">
            {checkouts.length === 0 ? (
              <Box>Nothing is checked out.</Box>
            ) : (
              <Table>
                <Table.Row header>
                  <Table.Cell>Borrower</Table.Cell>
                  <Table.Cell>Title</Table.Cell>
                  <Table.Cell>Due</Table.Cell>
                  <Table.Cell collapsing />
                </Table.Row>
                {checkouts.map((loan) => (
                  <Table.Row key={loan.ref}>
                    <Table.Cell>{loan.borrower}</Table.Cell>
                    <Table.Cell>{loan.title}</Table.Cell>
                    <Table.Cell color={loan.overdue ? 'bad' : 'good'}>
                      {loan.overdue ? 'OVERDUE' : `${loan.due_in_minutes} min`}
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        compact
                        icon="undo"
                        onClick={() => act('checkin', { ref: loan.ref })}
                      >
                        Check in
                      </Button>
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            )}
            <Pager
              page={lib.checkout_page || 1}
              count={lib.checkout_page_count || 1}
              onPage={(p) => act('checkout_page', { page: p })}
            />
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};
