export const browserStyles = `
@keyframes ripple {
    0% {
        background-position: 0% 50%;
        background-size: 100% 100%;
    }
    25% {
        background-position: 50% 50%;
        background-size: 150% 150%;
    }
    50% {
        background-position: 100% 50%;
        background-size: 200% 200%;
    }
    75% {
        background-position: 50% 50%;
        background-size: 150% 150%;
    }
    100% {
        background-position: 0% 50%;
        background-size: 100% 100%;
    }
}

@keyframes gradientShift {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

:root {
    --bg-primary: #ffffff;
    --text-primary: #333333;
    --text-secondary: #666666;
    --accent-blue: #0069ff;
    --border-color: #dddddd;
    --bg-secondary: #f5f5f5;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box
    background-color: rgb(0, 166, 172);;}

body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    color: var(--text-primary)
    background-color: rgb(0, 166, 172);
    background: linear-gradient(135deg, #667eea 0%, #6c4b8d 25%, #f093fb 50%, #4facfe 75%, #667eea 100%) !important;
    background-size: 400% 400% !important;
    animation: ripple 4s ease-in-out, gradientShift 8s ease infinite !important;
    background-attachment: fixed !important;
    min-height: 100vh;
}
    h1 {
        font-size: 1.8em;
        margin: 0.5em 0;
        color: #fff;
        text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;
    }
    h2 {
        font-size: 1.4em;
        margin: 0.5em 0;
        color: #fff;
        text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;
    }
    h3 {
        font-size: 1.1em;
        margin: 0.5em 0;
        color: #fff;
        text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;
    }
p {
    margin: 0.5em 0;
    color: #fff;
    text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;
}

ul, ol {
    margin: 0.5em 0;
    padding-left: 2em;
}
li {
    margin: 0.3em 0;
    color: #fff;
    text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;
}

table { width: 100%; border-collapse: collapse; margin: 1em 0; }
th, td { border: 1px solid var(--border-color); padding: 0.5em; text-align: left; }
th { background-color: var(--bg-secondary); font-weight: bold; }

a { color: var(--accent-blue); text-decoration: none; }
a:hover { text-decoration: underline; }
a:visited { color: #6200ee; }

button, input[type="button"], input[type="submit"] {
background-color: var(--accent-blue);
color: #fff;
border: none;
padding: 0.5em 1em;
border-radius: 4px;
cursor: pointer;
font-size: 0.9em;
}

button:hover, input[type="button"]:hover, input[type="submit"]:hover {
background-color: #0050cc;
}

button:focus, input:focus { outline: 2px solid var(--accent-blue); }

input[type="text"], input[type="email"], input[type="password"], textarea, select {
    padding: 0.5em;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    font-family: inherit;
    font-size: 0.9em;
}

textarea { resize: vertical; }

.content-box {
background-color: var(--bg-secondary);
border: 1px solid var(--border-color);
border-radius: 4px;
padding: 1em;
margin: 1em 0;
}

.content-box.info {
background-color: #e3f2fd;
border-color: #1976d2;
color: #0d47a1;
}

.content-box.warning {
    background-color: #fff3e0;
    border-color: #f57c00;
    color: #e65100;
}

.content-box.error {
background-color: #ffebee;
border-color: #d32f2f;
color: #b71c1c;
}

img { max-width: 100%; height: auto; border-radius: 4px; }

blockquote {
margin: 1em 0;
padding-left: 1em;
border-left: 4px solid var(--accent-blue);
color: var(--text-secondary);
}

code {
background-color: var(--bg-secondary);
padding: 0.2em 0.4em;
border-radius: 3px;
font-family: monospace;
}

pre {
background-color: #f0f0f0;
padding: 1em;
border-radius: 4px;
overflow-x: auto;
border: 1px solid var(--border-color);
}

pre code { background-color: transparent; padding: 0; font-size: 0.9em; }

hr { border: none; border-top: 1px solid var(--border-color); margin: 1.5em 0; }

iframe { border: 1px solid var(--border-color); border-radius: 4px; width: 100%; }
`;
