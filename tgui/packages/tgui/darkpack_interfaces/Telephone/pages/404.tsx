// THIS IS A DARKPACK UI FILE
export const browser_404 = (siteName: string) => `
<style>
	* {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
	}

	body {
		font-family: Arial, sans-serif;
		line-height: 1.6;
		padding: 20px;
		min-height: 100vh;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.error-container {
		text-align: center;
		max-width: 600px;
	}

	h1 {
		font-size: 2.5em;
		margin-bottom: 0.5em;
		color: #fff;
		text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;
	}

	p {
		font-size: 1.2em;
		color: #fff;
		text-shadow: -1px -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;
	}
</style>
<div class="error-container">
	<h1>Error 404</h1>
	<p>Page "${siteName}" not found</p>
</div>
`;
