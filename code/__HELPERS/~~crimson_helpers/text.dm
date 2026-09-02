/// Checks to see if a string starts with http:// or https://
/proc/is_http_protocol(text)
	var/static/regex/http_regex
	if(isnull(http_regex))
		http_regex = new("^https?://")
	return findtext(text, http_regex)

// example: my_ass_hurts -> MyAssHurts or My Ass Hurts (with underscore_as_space)
/// Snakecake to pascalcase
/proc/snake_to_pascal(text, underscore_as_space = FALSE)
	var/list/parts = splittext(text, "_")
	var/result = ""

	for (var/part in parts)
		if (underscore_as_space)
			if (result)
				result += " "
		result += uppertext(copytext(part, 1, 2)) + copytext(part, 2)

	return result
