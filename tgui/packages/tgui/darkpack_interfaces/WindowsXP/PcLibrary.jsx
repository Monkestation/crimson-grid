import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

export const PcLibrary = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const lib = data.library || data;

  const categories = Array.isArray(lib.search_categories)
    ? lib.search_categories
    : [];
  const pages = Array.isArray(lib.pages) ? lib.pages : [];
  const posters = Array.isArray(lib.posters) ? lib.posters : [];
  const saved = Array.isArray(lib.saved_ids) ? lib.saved_ids.map(String) : [];
  const busy = !!lib.busy;
  const full = (lib.saved_count || 0) >= (lib.saved_max || 0);
  const printerReady = lib.printer_status === 'Ready';

  const [title, setTitle] = useState(lib.title || '');
  const [author, setAuthor] = useState(lib.author || '');
  const [bookId, setBookId] = useState(lib.book_id ? String(lib.book_id) : '');
  const [category, setCategory] = useState(lib.category || '');
  const [poster, setPoster] = useState('');

  const search = () => act('search', { title, author, id: bookId, category });

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section title="Library Archive">
          {!lib.can_connect && (
            <NoticeBox danger>Unable to reach the archive database.</NoticeBox>
          )}
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={title}
                placeholder="Title"
                onInput={(a, b) => setTitle(readInput(a, b))}
                onChange={(a, b) => setTitle(readInput(a, b))}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={author}
                placeholder="Author"
                onInput={(a, b) => setAuthor(readInput(a, b))}
                onChange={(a, b) => setAuthor(readInput(a, b))}
              />
            </Stack.Item>
            <Stack.Item width="90px">
              <Input
                fluid
                value={bookId}
                placeholder="ID"
                onInput={(a, b) => setBookId(readInput(a, b))}
                onChange={(a, b) => setBookId(readInput(a, b))}
              />
            </Stack.Item>
          </Stack>
          <Stack mt={1}>
            <Stack.Item grow>
              <Dropdown
                width="100%"
                options={categories}
                selected={category || lib.category}
                onSelected={(v) => setCategory(v)}
              />
            </Stack.Item>
            <Stack.Item>
              <Button icon="search" disabled={busy} onClick={search}>
                Search
              </Button>
              <Button
                icon="eraser"
                disabled={busy}
                onClick={() => {
                  setTitle('');
                  setAuthor('');
                  setBookId('');
                  setCategory('');
                  act('clear');
                }}
              >
                Clear
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Section
          fill
          scrollable
          title="Results"
          buttons={
            <Box inline color={full ? 'bad' : 'label'}>
              Saved on this device: {lib.saved_count || 0}/{lib.saved_max || 0}
            </Box>
          }
        >
          {pages.length === 0 ? (
            <Box>No books found.</Box>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>ID</Table.Cell>
                <Table.Cell>Title</Table.Cell>
                <Table.Cell>Author</Table.Cell>
                <Table.Cell>Category</Table.Cell>
                <Table.Cell collapsing />
              </Table.Row>
              {pages.map((book) => {
                const isSaved = saved.includes(String(book.id));
                return (
                  <Table.Row key={book.id}>
                    <Table.Cell collapsing>#{book.id}</Table.Cell>
                    <Table.Cell>{book.title}</Table.Cell>
                    <Table.Cell>{book.author}</Table.Cell>
                    <Table.Cell>{book.category}</Table.Cell>
                    <Table.Cell collapsing>
                      {isSaved ? (
                        <>
                          <Box inline color="good" mr={1}>
                            <Icon name="check" mr={0.5} />
                            Saved
                          </Box>
                          <Button
                            compact
                            icon="print"
                            disabled={!printerReady}
                            tooltip={
                              printerReady
                                ? 'Print a copy'
                                : `Printer: ${lib.printer_status}`
                            }
                            onClick={() => act('print', { id: book.id })}
                          >
                            Print
                          </Button>
                        </>
                      ) : (
                        <Button
                          compact
                          icon="download"
                          disabled={busy || full}
                          tooltip={full ? 'Device storage is full' : undefined}
                          onClick={() => act('download', { id: book.id })}
                        >
                          Save
                        </Button>
                      )}
                    </Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Box textAlign="center">
          <Button
            icon="chevron-left"
            disabled={busy || lib.our_page <= 1}
            onClick={() => act('switch_page', { page: lib.our_page - 1 })}
          />
          <Box inline mx={1}>
            Page {lib.our_page || 1} / {lib.page_count || 1}
          </Box>
          <Button
            icon="chevron-right"
            disabled={busy || lib.our_page >= lib.page_count}
            onClick={() => act('switch_page', { page: lib.our_page + 1 })}
          />
        </Box>
      </Stack.Item>

      <Stack.Item>
        <Section
          title="Printer"
          buttons={
            <Box inline color={printerReady ? 'good' : 'bad'}>
              {lib.printer_status || 'Unknown'}
            </Box>
          }
        >
          {!!lib.status && <NoticeBox info>{lib.status}</NoticeBox>}
          <Stack>
            <Stack.Item>
              <Button
                icon="book-bible"
                disabled={!printerReady}
                onClick={() => act('print_bible')}
              >
                Print {lib.bible_name || 'bible'}
              </Button>
            </Stack.Item>
            {posters.length > 0 && (
              <>
                <Stack.Item grow>
                  <Dropdown
                    width="100%"
                    options={posters}
                    selected={poster || 'Choose a poster'}
                    onSelected={(v) => setPoster(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="image"
                    disabled={!printerReady || !poster}
                    onClick={() => act('print_poster', { poster_name: poster })}
                  >
                    Print poster
                  </Button>
                </Stack.Item>
              </>
            )}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
