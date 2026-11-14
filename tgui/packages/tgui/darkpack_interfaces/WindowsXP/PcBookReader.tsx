import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';
import { PcRichText } from './PcRichText';
import { useProgram } from './useProgram';

export const PcBookReader = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const reader = data.reader || data;
  const books = Array.isArray(reader.books) ? reader.books : [];
  const book = reader.open;

  if (book) {
    return (
      <Stack fill vertical>
        <Stack.Item>
          <Section
            title={book.title}
            buttons={
              <Button icon="arrow-left" onClick={() => act('close')}>
                Shelf
              </Button>
            }
          >
            <Box>by {book.author}</Box>
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            <Box
              style={{
                whiteSpace: 'pre-wrap',
                wordBreak: 'break-word',
                lineHeight: 1.5,
              }}
            >
              <PcRichText text={book.text} />
            </Box>
          </Section>
        </Stack.Item>
        <Stack.Item>
          <Box textAlign="center">
            <Button
              icon="angles-left"
              disabled={book.page <= 1}
              onClick={() => act('page', { page: 1 })}
            />
            <Button
              icon="chevron-left"
              disabled={book.page <= 1}
              onClick={() => act('page', { page: book.page - 1 })}
            />
            <Box inline mx={1}>
              Page {book.page} / {book.page_count}
            </Box>
            <Button
              icon="chevron-right"
              disabled={book.page >= book.page_count}
              onClick={() => act('page', { page: book.page + 1 })}
            />
            <Button
              icon="angles-right"
              disabled={book.page >= book.page_count}
              onClick={() => act('page', { page: book.page_count })}
            />
          </Box>
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Section
      fill
      scrollable
      title="Saved Books"
      buttons={
        <Box inline>
          {books.length}/{reader.saved_max || 0}
        </Box>
      }
    >
      {books.length === 0 ? (
        <Box>
          <Icon name="book" mr={1} />
          Nothing saved yet. Use the Library Archive app to save books to this
          device.
        </Box>
      ) : (
        books.map((b) => (
          <Stack key={b.id} mb={0.5} align="center">
            <Stack.Item grow>
              <Button
                fluid
                icon="book-open"
                onClick={() => act('open', { id: b.id })}
              >
                {b.title} — {b.author}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="trash"
                color="bad"
                tooltip="Delete from this device"
                onClick={() => act('remove', { id: b.id })}
              />
            </Stack.Item>
          </Stack>
        ))
      )}
    </Section>
  );
};
