// THIS IS A DARKPACK UI FILE
import { useState, useEffect, useMemo, useRef, memo } from 'react';
import { Box, Icon, Stack } from 'tgui-core/components';
import type { NavigableApps } from '.';

// web pages. just html in a `` block in a typescript file. sue me.
import { browser_home } from './pages/home';
import { browser_endron } from './pages/endron';
import { browserStyles } from './pages/browserStyles';
import { browser_gooble } from './pages/gooble';
import { browser_endbook } from './pages/endbook';
import { browser_404 } from './pages/404';

export const ScreenBrowser = memo((props: {
setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
const { setApp } = props;

const [currentSite, setCurrentSite] = useState<string>('Enter a URL');
const [urlInput, setUrlInput] = useState<string>('');
const [goobleShowResults, setGoobleShowResults] = useState(false);
const [goobleSearchQuery, setGoobleSearchQuery] = useState('');
const endronContentRef = useRef<string | null>(null);
const contentBoxRef = useRef<HTMLDivElement>(null);

useEffect(() => {
	(window as any).goobleSearch = () => {
		const input = document.getElementById('searchInput') as HTMLInputElement;
		const query = input?.value || 'your search';
		setGoobleSearchQuery(query);
		setGoobleShowResults(true);
	};

	(window as any).goobleHome = () => {
		setGoobleShowResults(false);
	};

	return () => {
		delete (window as any).goobleSearch;
		delete (window as any).goobleHome;
	};
}, []);

useEffect(() => {
	if (currentSite !== 'www.gooble.com') {
		setGoobleShowResults(false);
		setGoobleSearchQuery('');
	}
	if (currentSite === 'Enter a URL' || currentSite === 'Home') {
		setUrlInput('');
	}
}, [currentSite]);

const websites = useMemo(() => ({
	'Home': browser_home,
	'Enter a URL': browser_home,
    'www.gooble.com': () => browser_gooble(goobleShowResults, goobleSearchQuery),
	'www.endbook.com': browser_endbook,
	'www.endron-international.com': () => {
		if (!endronContentRef.current) {
			endronContentRef.current = browser_endron();
		}
		return endronContentRef.current;
	},
}), [goobleShowResults, goobleSearchQuery]);

const handleNavigate = () => {
    if (urlInput.trim()) {
        setCurrentSite(urlInput.trim());
        setUrlInput(`https://${urlInput.trim()}`); // pretend to be a real browser!
    }
};

const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
	if (e.key === 'Enter') {
	handleNavigate();
	}
};

const siteContent = useMemo(() => {
	const site = websites[currentSite];
	if (typeof site === 'function') {
		return site();
	}
	return site || browser_404(currentSite);
}, [currentSite, websites]);

const backgroundGradient = useMemo(() => {
	if (currentSite === 'www.gooble.com' || currentSite === 'www.endbook.com') {
		return 'linear-gradient(135deg, #ffffff 0%, #f5f5f5 25%, #e8e8e8 50%, #f5f5f5 75%, #ffffff 100%)';
	}
	return 'linear-gradient(180deg, rgb(0, 166, 172) 0%, rgb(0, 166, 172) 20%, rgb(0, 166, 172) 35%, #00a6ac 50%, #3c8c8f 65%, #93f7fb 80%, #ffffff 90%, #ffffff 100%)';
}, [currentSite]);

useEffect(() => {
	if (contentBoxRef.current) {
		contentBoxRef.current.innerHTML = siteContent;
		if (currentSite === 'www.gooble.com') {
			(window as any).goobleSearch = () => {
				const input = document.getElementById('searchInput') as HTMLInputElement;
				const query = input?.value || 'your search';
				setGoobleSearchQuery(query);
				setGoobleShowResults(true);
			};

			(window as any).goobleHome = () => {
				setGoobleShowResults(false);
			};
		}
	}
}, [siteContent, currentSite]);

return (
    <Stack vertical fill textColor="#000" backgroundColor="rgb(0, 166, 172)">
    <style>
        {browserStyles}
        {`div::-webkit-scrollbar { display: none; }`}
    </style>
    <Stack.Item backgroundColor="rgb(0, 166, 172)" textColor="#fff" p={1}>
        <Stack align="center">
        <Icon
            name="arrow-left"
            onClick={() => {
                if (currentSite === 'Enter a URL') {
                    setApp(null);
                } else {
                    setCurrentSite('Enter a URL');
                }
                setUrlInput('');
            }}
            style={{ cursor: 'pointer' }}
        />
        <Stack.Item grow>EndBrowser v1.0.1</Stack.Item>
        </Stack>
    </Stack.Item>

    <Stack.Item ml={1} mr={1} mt={0.5}>
        <Stack>
        <Stack.Item grow>
            <input
            placeholder= 'Enter a URL'
            value={urlInput}
            onChange={(e) => setUrlInput(e.target.value)}
            onKeyDown={(e) => handleKeyPress(e as React.KeyboardEvent<HTMLInputElement>)}
            style={{
                width: '100%',
                padding: '0.5em',
                borderRadius: '4px',
                border: '1px solid #ccc',
                fontSize: '0.9em',
                boxSizing: 'border-box',
            }}
            />
        </Stack.Item>
        <Stack.Item mt={-0.5}>
            <Box
            onClick={handleNavigate}
            style={{
                padding: '0.5em 1em',
                backgroundColor: 'rgb(0, 166, 172)',
                color: '#fff',
                borderRadius: '4px',
                cursor: 'pointer',
                textAlign: 'center',
                userSelect: 'none',
            }}
            >
            Go
            </Box>
        </Stack.Item>
        </Stack>
    </Stack.Item>

    <Stack.Item grow style={{ overflow: 'auto' }}>
        <div
        ref={contentBoxRef}
        style={{
            height: '100%',
            overflowY: 'auto',
            background: backgroundGradient,
            backgroundSize: '100% 100%',
            backgroundPosition: 'center top',
            backgroundAttachment: 'fixed',
            scrollbarWidth: 'none',
            msOverflowStyle: 'none',
        }}
        />
    </Stack.Item>

    <Stack.Item
    mb={-1}
    >
    </Stack.Item>
    </Stack>
);
});
