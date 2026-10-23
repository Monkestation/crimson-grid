import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui-core/components';
import { useProgram } from './useProgram';

const readInput = (a, b) => {
  if (typeof a === 'string' || typeof a === 'number') return String(a);
  if (typeof b === 'string' || typeof b === 'number') return String(b);
  if (a && typeof a === 'object' && a.target != null)
    return String(a.target.value ?? '');
  return '';
};

const sanitize = (html) => {
  const parser = new DOMParser();
  const doc = parser.parseFromString(String(html || ''), 'text/html');

  const dangerousTags = doc.querySelectorAll(
    'script, iframe, object, embed, form, input, button, textarea, meta, link',
  );
  dangerousTags.forEach((el) => el.remove()); // me when I'm a wrong linter

  const allElements = doc.querySelectorAll('*');
  allElements.forEach((el) => {
    for (const attr of Array.from(el.attributes)) {
      const name = attr.name.toLowerCase();
      if (name.startsWith('on') || /javascript:/i.test(attr.value)) {
        el.removeAttribute(attr.name);
      }
    }
  });
  return doc.documentElement.innerHTML;
};

const STARTER = `<center>
<h1><font color="yellow">~* Welcome to my Homepage *~</font></h1>
<marquee>Thanks for visiting!! Sign my guestbook!!</marquee>
<hr>
<p><font color="lime">This page is under construction.</font></p>
<table border="1" cellpadding="6"><tr><td>About me</td><td>Hobbies</td></tr></table>
</center>`;

const HtmlFrame = ({ html, bg }) => {
  const ref = useRef(null);
  const applied = useRef(null);
  const clean = useMemo(() => sanitize(html), [html]);

  useEffect(() => {
    if (!ref.current) return;
    if (applied.current === clean) return;

    ref.current.innerHTML = '';

    const parser = new DOMParser();
    const doc = parser.parseFromString(clean, 'text/html');

    const styles = doc.querySelectorAll('style');
    styles.forEach((styleEl) => {
      const activeStyle = document.createElement('style');
      activeStyle.textContent = styleEl.textContent;
      ref.current.appendChild(activeStyle);
      styleEl.remove();
    });

    const contentDiv = document.createElement('div');
    contentDiv.innerHTML = doc.body.innerHTML;
    ref.current.appendChild(contentDiv);

    applied.current = clean;
  }, [clean]);

  return (
    <div
      ref={ref}
      style={{
        backgroundColor: bg,
        color: '#ffffff',
        padding: '8px',
        minHeight: '200px',
        overflow: 'auto',
        position: 'relative',
        contain: 'layout paint',
        isolation: 'isolate',
        fontFamily: '"Times New Roman", serif',
      }}
    />
  );
};

const Viewer = ({ page }) => {
  if (!page) {
    return <Box p={2}>Pick a homepage from the list to visit it.</Box>;
  }
  return (
    <Box>
      <Box bold fontSize="14px" mb={0.5}>
        {page.title}
      </Box>
      <Box mb={1} style={{ fontSize: '11px' }}>
        by {page.char_name} · {page.visits} visits · updated {page.updated}
      </Box>
      <HtmlFrame html={page.html} bg={page.bg} />
    </Box>
  );
};

const Editor = ({ data, act }) => {
  const mine = data.mine;
  const [title, setTitle] = useState(mine?.title || 'My Homepage');
  const [bg, setBg] = useState(mine?.bg || '#000080');
  const [html, setHtml] = useState(mine?.html || STARTER);
  const [preview, setPreview] = useState(false);
  const cooldown = data.cooldown_left || 0;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Box style={{ display: 'flex', gap: '6px', alignItems: 'center' }}>
          <Box>Title</Box>
          <Input
            width="260px"
            maxLength={data.max_title}
            value={title}
            onChange={(a, b) => setTitle(readInput(a, b))}
          />
          <Box>Background</Box>
          <input
            type="color"
            value={bg}
            onChange={(e) => setBg(e.target.value)}
            style={{ width: 32, height: 24, padding: 0, border: 'none' }}
          />
        </Box>
      </Stack.Item>
      <Stack.Item grow>
        {preview ? (
          <Section fill scrollable>
            <Viewer
              page={{
                title,
                bg,
                html,
                char_name: data.my_name,
                visits: mine?.visits || 0,
                updated: 'preview',
              }}
            />
          </Section>
        ) : (
          <TextArea
            fluid
            height="100%"
            value={html}
            maxLength={data.max_html}
            onChange={(a, b) => setHtml(readInput(a, b))}
          />
        )}
      </Stack.Item>
      <Stack.Item>
        <Button
          icon={preview ? 'code' : 'eye'}
          onClick={() => setPreview(!preview)}
        >
          {preview ? 'Edit' : 'Preview'}
        </Button>
        <Button
          icon="upload"
          color="good"
          disabled={cooldown > 0}
          onClick={() => act('publish', { title, bg, html })}
        >
          {cooldown > 0 ? `Wait ${cooldown}s` : 'Publish'}
        </Button>
        <Button
          icon="file"
          onClick={() => setHtml(STARTER)}
          tooltip="Replace the editor contents with the starter template"
        >
          Template
        </Button>
        <Button
          icon="trash"
          color="bad"
          disabled={!mine}
          onClick={() => act('delete')}
        >
          Delete page
        </Button>
        <Box inline ml={1} style={{ fontSize: '10px' }}>
          {html.length}/{data.max_html} · one page per character ({data.my_name}
          )
        </Box>
        {!!data.message && (
          <Box inline ml={1} color="average" bold>
            {data.message}
          </Box>
        )}
      </Stack.Item>
    </Stack>
  );
};

export const PcGeocities = (props, context) => {
  const { act, data } = useProgram(props.programId, context);
  const sites = Array.isArray(data.sites) ? data.sites : [];
  const [tab, setTab] = useState('browse');
  const current = data.page ? data.page.key : null;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab
            selected={tab === 'browse'}
            onClick={() => setTab('browse')}
          >
            Browse
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 'mine'} onClick={() => setTab('mine')}>
            My Homepage
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        {tab === 'browse' ? (
          <Stack fill>
            <Stack.Item basis="230px" shrink={0}>
              <Section fill scrollable title="Who's online">
                {sites.length === 0 && (
                  <Box>No homepages from anyone present.</Box>
                )}
                {sites.map((s) => (
                  <Button
                    key={s.key}
                    fluid
                    mb={0.5}
                    selected={current === s.key}
                    onClick={() => act('view', { key: s.key })}
                  >
                    <Box bold>{s.title}</Box>
                    <Box style={{ fontSize: '10px' }}>
                      {s.owner} · {s.visits} visits
                    </Box>
                  </Button>
                ))}
                {!!data.message && (
                  <Box mt={1} color="average" bold>
                    {data.message}
                  </Box>
                )}
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section fill scrollable>
                <Viewer page={data.page} />
              </Section>
            </Stack.Item>
          </Stack>
        ) : (
          <Editor data={data} act={act} key={data.mine ? data.my_key : 'new'} />
        )}
      </Stack.Item>
    </Stack>
  );
};
