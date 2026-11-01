/datum/stock_lot
    var/shares = 0
    var/cost = 0
    var/bought_at = 0

/datum/stock_lot/New(shares, cost, bought_at)
    src.shares = shares
    src.cost = cost
    src.bought_at = bought_at

SUBSYSTEM_DEF(stocks)
	name = "Night Exchange"
	wait = 1 MINUTES
	ss_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/list/datum/stock/stocks = list()
	var/list/stocks_by_ticker = list()
	var/list/sector_mood = list()
	/// Each entry: list(timestamp, public headline, whisper or "")
	var/list/news = list()
	var/list/datum/stock_event/possible_events = list()
	var/list/portfolios = list()
	var/dividend_counter = 0
	///labels
	var/list/sector_labels = list(
		"finance" = "Finance",
		"media" = "Media & Entertainment",
		"industry" = "Heavy Industry",
		"pharma" = "Biotech",
		"data" = "Information Services",
		"resources" = "Natural Resources",
		"health" = "Healthcare",
		"logistics" = "Shipping & Logistics",
		"funerary" = "Funeral & Insurance",
		"vice" = "Hospitality & Imports",
		"security" = "Security Services",
		"blood" = "Healthcare Supply",
		"tech" = "Technology",
		"wyrm" = "Conglomerate",
	)

/datum/controller/subsystem/stocks/Initialize()
	build_stocks()
	build_events()
	if(!GLOB.news_network.network_channels_by_name[STOCK_NEWS_CHANNEL])
		GLOB.news_network.create_feed_channel(STOCK_NEWS_CHANNEL, STOCK_NEWS_AUTHOR, "Market reports and business news from the Night Exchange floor.", locked = TRUE)
	local_news("The Night Exchange opens for trading.")
	return SS_INIT_SUCCESS

/datum/controller/subsystem/stocks/proc/build_stocks()
	for(var/path in subtypesof(/datum/stock))
		var/datum/stock/S = new path
		S.initialize_history()
		stocks += S
		stocks_by_ticker[S.ticker] = S
		sector_mood[S.sector] = 0

/datum/controller/subsystem/stocks/proc/build_events()
	for(var/path in subtypesof(/datum/stock_event))
		possible_events += new path

/// Adds an entry to the in-program ticker. Whisper may be "".
/datum/controller/subsystem/stocks/proc/local_news(headline, whisper = "")
	news.Insert(1, list(list(time2text(world.timeofday, "hh:mm"), headline, whisper)))
	if(news.len > STOCK_NEWS_LEN)
		news.Cut(STOCK_NEWS_LEN + 1)

/// Publishes a non breach story to the newscaster network. Nightcrawler splits "headline<SEP>body".
/datum/controller/subsystem/stocks/proc/publish_story(headline, body, alert = FALSE)
	if(!GLOB.news_network.network_channels_by_name[STOCK_NEWS_CHANNEL])
		return
	GLOB.news_network.submit_article("[headline][NIGHTCRAWLER_SEPARATOR][body]", STOCK_NEWS_AUTHOR, STOCK_NEWS_CHANNEL, update_alert = alert)

/datum/controller/subsystem/stocks/fire(resumed = FALSE)
	if(prob(STOCK_EVENT_CHANCE) && possible_events.len)
		fire_event(pick(possible_events))

	for(var/datum/stock/S as anything in stocks)
		S.tick(sector_mood[S.sector] || 0)

	for(var/sector in sector_mood)
		sector_mood[sector] *= 0.7
		if(abs(sector_mood[sector]) < 0.001)
			sector_mood[sector] = 0

	dividend_counter++
	if(dividend_counter >= STOCK_DIVIDEND_FIRES)
		dividend_counter = 0
		pay_dividends()

/datum/controller/subsystem/stocks/proc/fire_event(datum/stock_event/E)
	local_news(E.headline, E.whisper)
	publish_story(E.headline, E.body, E.is_big())   // whisper is deliberately NOT published
	for(var/sector in E.effects)
		if(sector in sector_mood)
			sector_mood[sector] += E.effects[sector]

/datum/controller/subsystem/stocks/proc/pay_dividends()
	var/paid_any = FALSE

	// Existing personal portfolios
	for(var/id in portfolios)
		var/datum/bank_account/acc = SSeconomy.bank_accounts_by_id[id]
		if(!acc)
			continue
		var/total = 0
		var/list/holdings = portfolios[id]
		for(var/ticker in holdings)
			var/datum/stock/S = stocks_by_ticker[ticker]
			if(!S || S.dividend <= 0)
				continue
			total += round(count_shares(holdings[ticker]) * S.price * S.dividend)
		if(total > 0)
			acc.adjust_money(total, "Night Exchange: dividends")
			paid_any = TRUE

	// ETF pools
	for(var/net_id in GLOB.pc_networks)
		var/datum/pc_network/net = GLOB.pc_networks[net_id]
		if(!net?.etf)
			continue
		if(net.etf.receive_dividends() > 0)
			paid_any = TRUE

	if(paid_any)
		local_news("The Exchange distributes dividends to shareholders.")

/datum/controller/subsystem/stocks/proc/finance_dots(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return 0
	return clamp(H.st_get_stat(STAT_FINANCE) || 0, 0, 5)

/datum/controller/subsystem/stocks/proc/tax_rate_for(dots)
	return max(0, STOCK_TAX_BASE - (dots * STOCK_TAX_PER_DOT))

/datum/controller/subsystem/stocks/proc/fee_rate_for(dots)
	return max(0, STOCK_FEE_BASE - (dots * STOCK_FEE_PER_DOT))

/datum/controller/subsystem/stocks/proc/outlook_for(datum/stock/S)
	var/mood = sector_mood[S.sector] || 0
	if(mood > 0.01)
		return "bullish"
	if(mood < -0.01)
		return "bearish"
	return "neutral"

/datum/controller/subsystem/stocks/proc/count_shares(list/lots)
	var/total = 0
	for(var/datum/stock_lot/L as anything in lots)
		total += L.shares
	return total

/datum/controller/subsystem/stocks/proc/get_lots(datum/bank_account/acc, ticker, create = FALSE)
	var/key = "[acc.account_id]"
	var/list/holdings = portfolios[key]
	if(!holdings)
		if(!create)
			return list()
		holdings = list()
		portfolios[key] = holdings
	var/list/lots = holdings[ticker]
	if(!lots)
		if(!create)
			return list()
		lots = list()
		holdings[ticker] = lots
	return lots

/datum/controller/subsystem/stocks/proc/shares_owned(datum/bank_account/acc, ticker)
	return count_shares(get_lots(acc, ticker))

/datum/controller/subsystem/stocks/proc/cost_of(datum/bank_account/acc, ticker)
	var/total = 0
	for(var/datum/stock_lot/L as anything in get_lots(acc, ticker))
		total += L.cost
	return total

/datum/controller/subsystem/stocks/proc/portfolio_value(datum/bank_account/acc)
	var/value = 0
	var/list/holdings = portfolios["[acc.account_id]"]
	for(var/ticker in holdings)
		var/datum/stock/S = stocks_by_ticker[ticker]
		if(S)
			value += count_shares(holdings[ticker]) * S.price
	return round(value)

/datum/controller/subsystem/stocks/proc/buy_shares(datum/bank_account/acc, ticker, amount, fee_rate)
	var/datum/stock/S = stocks_by_ticker[ticker]
	if(!S || amount < 1)
		return FALSE
	var/cost = round(S.price * amount)
	var/fee = max(1, round(cost * fee_rate))
	var/total = cost + fee
	if(!acc.has_money(total))
		return FALSE
	if(!acc.adjust_money(-total, "Night Exchange: bought [amount] [S.ticker]"))
		return FALSE

	var/list/lots = get_lots(acc, ticker, TRUE)
	lots += new /datum/stock_lot(amount, total, world.time)
	S.apply_trade_pressure(amount, TRUE)
	return TRUE

/// Sells oldest shares first (FIFO). Returns a result list, or null on failure.
/// Short-term gain (lots held under STOCK_LONG_TERM) is taxed; losses on short-term
/// lots offset gains within the same sale but never create a refund.
/datum/controller/subsystem/stocks/proc/sell_shares(datum/bank_account/acc, ticker, amount, fee_rate, tax_rate)
	var/datum/stock/S = stocks_by_ticker[ticker]
	if(!S || amount < 1)
		return null
	var/list/lots = get_lots(acc, ticker)
	var/owned = count_shares(lots)
	if(owned < 1)
		return null
	amount = min(amount, owned)

	var/remaining = amount
	var/short_gain = 0
	for(var/datum/stock_lot/L as anything in lots.Copy())
		if(remaining <= 0)
			break
		var/take = min(L.shares, remaining)
		var/take_cost = round(L.cost * (take / L.shares))
		if(world.time - L.bought_at < STOCK_LONG_TERM)
			short_gain += round(S.price * take) - take_cost
		L.cost -= take_cost
		L.shares -= take
		remaining -= take
		if(L.shares <= 0)
			lots -= L
			qdel(L)
	if(!lots.len)
		var/list/holdings = portfolios["[acc.account_id]"]
		holdings -= ticker

	var/gross = round(S.price * amount)
	var/fee = max(1, round(gross * fee_rate))
	var/tax = round(max(0, short_gain) * tax_rate)
	var/net = max(0, gross - fee - tax)

	acc.adjust_money(net, "Night Exchange: sold [amount] [S.ticker] (fee [fee], tax [tax])")

	var/garnish = 0
	if(acc.account_debt > 0 && net > 0)
		garnish = acc.pay_debt(min(round(net * STOCK_GARNISH), acc.account_debt)) || 0

	S.apply_trade_pressure(amount, FALSE)
	return list("shares" = amount, "gross" = gross, "fee" = fee, "tax" = tax, "net" = net, "garnish" = garnish)
