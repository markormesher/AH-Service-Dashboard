######################
## NOTE JOB: TICKER ##
######################

w = window

## ticker info
tickerWidth = tickerWrapperWidth = tickerLeft = 0
tickerSeparator = '<span>&nbsp;&nbsp;&bull;&nbsp;&nbsp;</span>'

## ticker initialisation
tickerRunning = false;
w.load_ticker = () ->
  return if tickerRunning
  tickerRunning = true
  loadTickerText()
  getTickerWidths()
  tickerMove()

## gets ticker widths
getTickerWidths = () ->
  tickerWidth = $('.ticker-text').width()
  tickerWrapperWidth = $('.ticker').width()

## ticker text population
loadTickerText = () ->
  $('.ticker-text').html('');
  lines = w.readCleanLines('news-ticker')
  addToTicker(r, i) for r, i in lines

## add a string to the ticker
addToTicker = (r, i) ->
  tickerText = $('.ticker-text')
  if i > 0 then tickerText.html(tickerText.html() + tickerSeparator)
  tickerText.html(tickerText.html() + r)

## ticker mover
tickerMove = () ->
  if --tickerLeft < -tickerWidth
    loadTickerText()
    getTickerWidths()
    tickerLeft = tickerWrapperWidth
  $('.ticker-text').css('margin-left', tickerLeft + 'px')
  setTimeout(tickerMove, 15)