// THIS IS A DARKPACK UI FILE
import { useState, useEffect } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Stack, Icon } from 'tgui-core/components';
import type { NavigableApps } from '.';

interface BackendData {
endpost_username?: string;
show_endpost_registration?: boolean;
posts?: Array<{
    body: string;
    date: string;
    author: string;
    time: string;
}>;
is_admin?: boolean;
}

export const ScreenEndpost = (props: {
setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
const { setApp } = props;
const { act, data } = useBackend<BackendData>();
const { is_admin } = data;
const convertTo12Hour = (timeStr: string) => {
    if (!timeStr || !timeStr.includes(':')) return timeStr || '';
    const [hourStr, minute] = timeStr.split(':');
    const hour = parseInt(hourStr, 10);
    const period = hour >= 12 ? 'PM' : 'AM';
    const displayHour = hour % 12 || 12;
    return `${displayHour}:${minute} ${period}`;
    };


const [body, setBody] = useState<string>('');
const [composing, setComposing] = useState<boolean>(false);
const [submitted, setSubmitted] = useState<boolean>(false);
const [askedForUsername, toldToRegister] = useState<boolean>(false);
const username = (data as any).endpost_username;
const posts = (data as any).posts || [];

useEffect(() => {
    if (askedForUsername && username) {//hacky but works. will probably refactor later
        setComposing(true);
        toldToRegister(false);
    }
}, [username, askedForUsername]);

const handleNewPost = () => {
    if (!username) {
        toldToRegister(true);
        act('endpost_registration');
    } else {
        setComposing(true);
    }
};

const handleSubmit = () => {
    if (!body.trim()) {
        return;
    }

    act('submit_post', {
        body: body,
    });

    setSubmitted(true);
    setBody('');
    setTimeout(() => {
        setSubmitted(false);
        setComposing(false);
    }, 1500);
};

return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
        <Stack.Item backgroundColor="#4a90e2" textColor="#fff" p={1}>
            <Stack align="center">
                <Box onClick={() => setApp(null)} style={{ cursor: 'pointer' }}>
                <Icon
                    name="arrow-left"
                    style={{ cursor: 'pointer' }}
                />
                </Box>
                <Stack.Item grow>EndPost</Stack.Item>
            {(data as any).show_endpost_registration && !composing ? (
                <Button
                    onClick={() => act('endpost_registration')}
                    color="transparent"
                    textColor="#fff"
                >
                    📝{username ? `Re-` : ``}Register
                </Button>
            ) : `${username}`}
                {!composing && (
                    <Button
                    onClick={handleNewPost}
                        color="transparent"
                        textColor="#fff"
                    >
                        + New EndPost
                    </Button>
                )}
            </Stack>
        </Stack.Item>
        {composing && (
            <Stack.Item
                backgroundColor="#f5f5f5"
                style={{ borderBottom: '1px solid #ddd' }}
            >
                <Stack vertical>
                    <Stack.Item mb={1}>
                        <Box ml={1} fontSize="0.85em" color={username ? '#2e7d32' : '#d32f2f'}>
                            {username ? `Posting as: ${username}` : 'Registration required before posting'}
                        </Box>
                    </Stack.Item>

                    <Stack.Item mb={-3} grow mr={2} ml={2}>

                        <textarea
                            placeholder="Posts are deleted after 24hrs"
                            value={body}
                            onChange={(e) => setBody(e.target.value.slice(0, 140))}
                            maxLength={140}
                            //disabled={!username}
                            style={{
                                width: '100%',
                                padding: '0.5em',
                                borderRadius: '4px',
                                border: '1px solid #ccc',
                                fontSize: '0.9em',
                                boxSizing: 'border-box',
                                minHeight: '50px',
                                resize: 'vertical',
                                opacity: username ? 1 : 0.5,
                                marginBottom: 0.1,
                                cursor: username ? 'text' : 'not-allowed',
                            }}
                        />
                        <Box fontSize="0.75em" color="#999" textAlign="right" mt={0.5} mr={3}>
                            {body.length}/140
                        </Box>
                    </Stack.Item>
                    {submitted ? (
                        <Stack.Item>
                            <Box color="#2e7d32" fontSize="0.9em">
                                ✓ EndPosted!
                            </Box>
                        </Stack.Item>
                    ) : (
                        <Stack.Item>
                            <Stack>
                                <Button
                                    onClick={handleSubmit}
                                    color="blue"
                                    disabled={!body.trim()}
                                    ml={2}
                                    mb={2}
                                >
                                    EndPost
                                </Button>
                                <Button
                                    onClick={() => setComposing(false)} color="gray"
                                    mb={2}
                                >
                                    Cancel
                                </Button>
                            </Stack>
                        </Stack.Item>
                    )}
                </Stack>
            </Stack.Item>
        )}
        <Stack.Item grow style={{
        overflow: 'auto',
        scrollbarWidth: 'none',
        msOverflowStyle: 'none',
        }}>
            {posts.length === 0 ? (
                <Box p={2} textAlign="center" color="#999">
                    No EndPosts yet... Post one!
                </Box>
            ) : (
                <Stack vertical mb={10}>
                    {[...posts].reverse().map((post_content: any, index: number) => (
                        <Stack.Item
                            key={index}
                            p={1.5}
                            ml={1}
                            mr={2}
                            backgroundColor={index % 2 === 0 ? '#fff' : '#fafafa'}
                            style={{ borderBottom: '1px solid #e0e0e0' }}>
                            <Stack vertical>
                                <Stack mb={0.5}>
                                    <Box ml={-1} fontWeight="bold" color="#4a90e2">
                                        {post_content.author}
                                    </Box>
                                    <Box ml="auto" fontSize="0.8em" color="#999" textAlign="right">
                                        {post_content.date}<br />{convertTo12Hour(post_content.time)}
                                    </Box>
                                    {is_admin && (
                                        <Button
                                            onClick={() => act('remove_endpost', { post_index: posts.length - index })}
                                            color="red"
                                            ml={1}
                                            style={{ fontSize: '0.7em', padding: '0.3em 0.6em' }}
                                        >
                                            X
                                        </Button>
                                    )}
                                </Stack>
                                <Box style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
                                    {post_content.body}
                                </Box>
                            </Stack>
                        </Stack.Item>
                    ))}
                </Stack>
            )}
        </Stack.Item>
    </Stack>
);
};
