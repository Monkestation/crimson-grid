// THIS IS A DARKPACK UI FILE
export const browser_gooble = (showResults = false, searchQuery = '') => `
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
		background: linear-gradient(135deg, #ffffff 0%, #f5f5f5 25%, #e8e8e8 50%, #f5f5f5 75%, #ffffff 100%) !important;
		background-size: 400% 400% !important;
		animation: ripple 4s ease-in-out, gradientShift 8s ease infinite !important;
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		margin: 0;
		padding: 0;
	}

	.gooble-page-bg {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: linear-gradient(135deg, #ffffff 0%, #f5f5f5 25%, #e8e8e8 50%, #f5f5f5 75%, #ffffff 100%);
		background-size: 400% 400%;
		animation: ripple 4s ease-in-out, gradientShift 8s ease infinite;
		z-index: -1;
	}

	.gooble-container {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		min-height: 60vh;
		padding: 20px;
	}

	h1, h2, h3, p, li, span, div, a {
		text-shadow: none !important;
	}

	.gooble-logo {
		font-size: 5em;
		font-weight: bold;
		margin-bottom: 1em;
		font-family: Arial, sans-serif;
		text-align: center;
	}

	.gooble-logo .g { color: #4285F4; }
	.gooble-logo .o1 { color: #EA4335; }
	.gooble-logo .o2 { color: #FBBC04; }
	.gooble-logo .b { color: #4285F4; }
	.gooble-logo .l { color: #34A853; }
	.gooble-logo .e { color: #EA4335; }

	.search-box-wrapper {
		width: 100%;
		max-width: 584px;
		margin-bottom: 1.5em;
	}

	.search-box {
		width: 100%;
		padding: 0.8em 1.2em;
		border: 1px solid #dfe1e5;
		border-radius: 24px;
		font-size: 1em;
		box-shadow: 0 1px 6px rgba(32, 33, 36, 0.28);
		transition: box-shadow 0.2s;
	}

	.search-box:hover {
		box-shadow: 0 2px 8px rgba(32, 33, 36, 0.35);
		border-color: rgba(223, 225, 229, 0);
	}

	.search-box:focus {
		outline: none;
		box-shadow: 0 2px 8px rgba(32, 33, 36, 0.35);
		border-color: rgba(223, 225, 229, 0);
	}

	.button-wrapper {
		display: flex;
		gap: 10px;
		justify-content: center;
		flex-wrap: wrap;
	}

	.gooble-button {
		background-color: #f8f9fa;
		border: 1px solid #f8f9fa;
		border-radius: 4px;
		color: #3c4043;
		font-size: 0.9em;
		padding: 0.7em 1.2em;
		cursor: pointer;
		transition: all 0.1s;
	}

	.gooble-button:hover {
		box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
		background-color: #f8f9fa;
		border: 1px solid #dadce0;
		color: #202124;
	}

	.footer-text {
		position: absolute;
		bottom: 20px;
		text-align: center;
		color: #70757a;
		font-size: 0.85em;
		margin-bottom: 5%;
	}

	.hidden {
		display: none !important;
	}

	.results-container {
		padding: 20px;
		max-width: 652px;
		margin: 0 auto;
	}

	.results-header {
		display: flex;
		align-items: center;
		margin-bottom: 30px;
		padding-top: 20px;
	}

	.results-logo {
		font-size: 1.8em;
		font-weight: bold;
		font-family: Arial, sans-serif;
		margin-right: 30px;
	}

	.results-search-box {
		flex: 1;
		padding: 0.6em 1em;
		border: 1px solid #dfe1e5;
		border-radius: 24px;
		font-size: 0.95em;
		box-shadow: 0 1px 6px rgba(32, 33, 36, 0.28);
	}

	.results-stats {
		color: #70757a;
		font-size: 0.85em;
		margin-bottom: 20px;
	}

	.no-results {
		margin-top: 30px;
	}

	.no-results h2 {
		font-size: 1.3em;
		color: #202124;
		margin-bottom: 10px;
	}

	.no-results p {
		color: #70757a;
		line-height: 1.6;
		margin: 8px 0;
	}

	.suggestions {
		margin-top: 20px;
		color: #70757a;
	}

	.suggestions ul {
		margin-top: 10px;
		margin-left: 20px;
	}

	.suggestions li {
		margin: 5px 0;
		color: #70757a;
	}
</style>

<div class="gooble-page-bg"></div>
${!showResults ? `
<div class="gooble-container" id="homePage">
	<div class="gooble-logo">
		<span class="g">G</span><span class="o1">o</span><span class="o2">o</span><span class="b">b</span><span class="l">l</span><span class="e">e</span>
	</div>

	<div class="search-box-wrapper">
		<input
			type="text"
			id="searchInput"
			class="search-box"
			placeholder="Search Gooble or type a URL"
			aria-label="Search"
			value="${searchQuery}"
		/>
	</div>

	<div class="button-wrapper">
		<button class="gooble-button" onclick="window.goobleSearch()">Gooble Search</button>
		<button class="gooble-button" onclick="window.goobleSearch()">I'm Feeling Lucky</button>
	</div>

	<div class="footer-text">
		Gooble Search - Making the world's information accessible
	</div>
</div>
` : `
<div class="results-container" id="resultsPage">
	<div class="results-header">
		<div class="results-logo" onclick="window.goobleHome()" style="cursor: pointer;">
			<span class="g">G</span><span class="o1">o</span><span class="o2">o</span><span class="b">b</span><span class="l">l</span><span class="e">e</span>
		</div>
		<input
			type="text"
			class="results-search-box"
			value="${searchQuery || 'your search'}"
			readonly
		/>
	</div>

	<div class="results-stats">No results found for "${searchQuery || 'your search'}"</div>

	<div class="no-results">
		<h2>Your search did not match any documents.</h2>
		<p><strong>Suggestions:</strong></p>
		<div class="suggestions">
			<ul>
				<li>Make sure all words are spelled correctly.</li>
				<li>Try different keywords.</li>
				<li>Try more general keywords.</li>
				<li>Try fewer keywords.</li>
			</ul>
		</div>
	</div>
</div>
`}
`
