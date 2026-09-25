// THIS IS A DARKPACK UI FILE
export const browser_home = `
<style>
	@keyframes ripple {
		0% {
			background-position: center top;
			background-size: 100% 100%;
		}
		25% {
			background-position: center top;
			background-size: 100% 150%;
		}
		50% {
			background-position: center top;
			background-size: 100% 200%;
		}
		75% {
			background-position: center top;
			background-size: 100% 150%;
		}
		100% {
			background-position: center top;
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

	@keyframes float {
		0%, 100% {
			transform: translate(0, 0) scale(1);
			opacity: 0.07;
		}
		25% {
			transform: translate(20px, 30px) scale(1.1);
			opacity: 0.08;
		}
		50% {
			transform: translate(-15px, 60px) scale(0.9);
			opacity: 0.09;
		}
		75% {
			transform: translate(-25px, 30px) scale(1.05);
			opacity: 0.1;
		}
	}

	.floating-dots {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		pointer-events: none;
		z-index: 0;
	}

	.dot {
		position: absolute;
		border-radius: 50%;
		background: radial-gradient(circle, rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.2));
		animation: float ease-in-out infinite;
	}

	.dot:nth-child(1) {
		width: 60px;
		height: 60px;
		top: 25%;
		left: 15%;
		animation-duration: 8s;
		animation-delay: 0s;
	}

	.dot:nth-child(2) {
		width: 40px;
		height: 40px;
		top: 60%;
		left: 80%;
		animation-duration: 10s;
		animation-delay: 2s;
	}

	.dot:nth-child(3) {
		width: 80px;
		height: 80px;
		top: 75%;
		left: 10%;
		animation-duration: 12s;
		animation-delay: 1s;
	}

	.dot:nth-child(4) {
		width: 50px;
		height: 50px;
		top: 50%;
		left: 70%;
		animation-duration: 9s;
		animation-delay: 3s;
	}

	.dot:nth-child(5) {
		width: 35px;
		height: 35px;
		top: 45%;
		left: 40%;
		animation-duration: 11s;
		animation-delay: 1.5s;
	}

	.dot:nth-child(6) {
		width: 55px;
		height: 55px;
		top: 85%;
		left: 60%;
		animation-duration: 10.5s;
		animation-delay: 2.5s;
	}

	* {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
	}

	html, body {
		width: 100%;
		height: 100%;
		overflow-x: hidden;
	}

	body {
		background-color: #00a6ac;
		background-image: linear-gradient(180deg, #00a6ac 0%, #00a6ac 20%, #5cc9cf 35%, #667eea 50%, #764ba2 65%, #f093fb 80%, #4facfe 90%, #667eea 100%);
		background-size: 100% 100%;
		background-position: center top;
		background-attachment: fixed;
	}

	.page-wrapper {
		min-height: 100vh;
		padding: 20px;
		font-family: Arial, sans-serif;
		line-height: 1.5;
		position: relative;
		z-index: 1;
	}

	h1, h2, p, li, strong {
		color: #fff;
		text-shadow:
			-1px -1px 0 #000,
			1px -1px 0 #000,
			-1px 1px 0 #000,
			1px 1px 0 #000;
	}

	h1 {
		margin: -1em 0 -2em 0;
		font-size: 2.5em;
		font-weight: bold;
		letter-spacing: 1px;
	}

	h2 {
		margin-top: -2em;
		font-size: 1.5em;
	}

	hr {
		margin: 4em -10em;
		border: none;
		border-top: 2px solid rgba(255, 255, 255, 0.7);
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
	}

	p, li {
		font-size: 1.1em;
	}

	ul {
		margin-left: -3em;
        margin-top: -1em;
        align-items: center;
        text-align: center;
	}

	li {
		margin: 0.5em 0;
        align-items: center;
	}
</style>
<div class="floating-dots">
	<div class="dot"></div>
	<div class="dot"></div>
	<div class="dot"></div>
	<div class="dot"></div>
	<div class="dot"></div>
	<div class="dot"></div>
</div>
<div class="page-wrapper">
	<h1 style="text-align: center;">Welcome to EndBrowser!</h1>
    <hr />
	<h2 style="text-align: center;">Recommended Websites</h2>
	<ul>
		<li><strong>www.gooble.com</strong> <br>
        Gooble Search Engine</li>
		<li><strong>www.endbook.com</strong> <br>
        EndBook Social Network</li>
		<li><strong>www.endron-international.com</strong> <br>
        Endron International Official Website</li>
	</ul>
	<p style="text-align: center; font-style: italic; font-size: 0.8em;">© EndBrowser v1.0.1</p>
</div>
`

