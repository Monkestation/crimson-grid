// THIS IS A DARKPACK UI FILE
export const browser_endbook = () => `
<style>
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

	body {
		background: linear-gradient(135deg, #f0f2f5 0%, #e4e6eb 25%, #dfe1e6 50%, #e4e6eb 75%, #f0f2f5 100%) !important;
		background-size: 400% 400% !important;
		animation: ripple 4s ease-in-out, gradientShift 8s ease infinite !important;
		margin: 0;
		padding: 0;
		font-family: Helvetica, Arial, sans-serif;
		min-height: 100vh;
		display: flex;
		align-items: center;
		justify-content: center;
	}
	h1, h2, h3, p, li, span, div, a, input, button {
		text-shadow: none !important;
	}

	.endbook-container {
		display: flex;
		align-items: center;
		justify-content: space-between;
		max-width: 1000px;
		width: 100%;
		padding: 20px;
		gap: 40px;
	}

	.endbook-left {
		flex: 1;
		padding-right: 20px;
	}

	.endbook-logo {
		font-size: 4em;
		font-weight: bold;
		color: #1877f2;
		margin-bottom: 0.2em;
		font-family: Arial, sans-serif;
	}

	.endbook-tagline {
		font-size: 1.8em;
		color: #1c1e21;
		line-height: 1.4;
	}

	.endbook-right {
		flex: 1;
		background: white;
		border-radius: 8px;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1), 0 8px 16px rgba(0, 0, 0, 0.1);
		padding: 20px;
	}

	.login-form {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}

	.login-input {
		padding: 14px 16px;
		font-size: 17px;
		border: 1px solid #dddfe2;
		border-radius: 6px;
		outline: none;
		color: #1c1e21;
		background: white;
	}

	.login-input:focus {
		border-color: #1877f2;
		box-shadow: 0 0 0 2px rgba(24, 119, 242, 0.2);
	}

	.login-button {
		background: #1877f2;
		color: white;
		padding: 14px 16px;
		font-size: 20px;
		font-weight: bold;
		border: none;
		border-radius: 6px;
		cursor: pointer;
		margin-top: 8px;
	}

	.login-button:hover {
		background: #166fe5;
	}

	.forgot-password {
		text-align: center;
		margin-top: 16px;
	}

	.forgot-password a {
		color: #1877f2;
		text-decoration: none;
		font-size: 14px;
	}

	.forgot-password a:hover {
		text-decoration: underline;
	}

	.divider {
		border-top: 1px solid #dadde1;
		margin: 20px 0;
	}

	.create-account {
		text-align: center;
	}

	.create-button {
		background: #42b72a;
		color: white;
		padding: 14px 16px;
		font-size: 17px;
		font-weight: bold;
		border: none;
		border-radius: 6px;
		cursor: pointer;
		display: inline-block;
	}

	.create-button:hover {
		background: #36a420;
	}

	@media (max-width: 768px) {
		.endbook-container {
			flex-direction: column;
			max-width: 400px;
		}

		.endbook-left {
			text-align: center;
			padding-right: 0;
		}

		.endbook-logo {
			font-size: 3em;
		}

		.endbook-tagline {
			font-size: 1.4em;
		}
	}
</style>

<div class="endbook-container">
	<div class="endbook-left">
		<div class="endbook-logo">endbook</div>
		<div class="endbook-tagline">Connect with friends and the world around you on EndBook.</div>
	</div>

	<div class="endbook-right">
		<form class="login-form">
			<input type="text" class="login-input" placeholder="Email or phone number" />
			<input type="password" class="login-input" placeholder="Password" />
			<button type="button" class="login-button">Log In</button>
		</form>

		<div class="forgot-password">
			<a href="#">Forgot password?</a>
		</div>

		<div class="divider"></div>

		<div class="create-account">
			<button type="button" class="create-button">Create new account</button>
		</div>
	</div>
    <p style="text-align: left; margin-bottom: 15px; margin-top: 20px; color: #606770;"> © EndBook, a Pentex subsidiary</p>
</div>
`;
