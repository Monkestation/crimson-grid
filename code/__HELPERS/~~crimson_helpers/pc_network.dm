///used in ui rendering without a markdown parser
/proc/strip_markdown(raw)
	if(!istext(raw))
		return ""
	raw = replacetext(raw, "<br>", "\n")
	raw = replacetext(raw, "<br />", "\n")
	raw = replacetext(raw, "<br/>", "\n")
	raw = replacetext(raw, "</p>", "\n")
	raw = replacetext(raw, "</h1>", "\n")
	raw = replacetext(raw, "</h2>", "\n")
	raw = replacetext(raw, "</h3>", "\n")
	return trim(html_decode(strip_html(raw)))
