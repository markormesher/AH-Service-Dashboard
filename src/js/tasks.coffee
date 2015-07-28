###################
## DATA HANDLING ##
###################

window._DATA = {}
window._SOURCES = {}

# receive data
window.onmessage = (e) ->
  return if e?.data?.sender != 'self'
  window._DATA[e.data.source] = e.data.data
  for name, waiting of window._SOURCES
    if e.data.source == name then initNotes(i) for i in waiting

# reload the iframe
reloadDataIframe = () ->
  $('#js-iframe').attr('src', 'js.html');
  setTimeout(reloadDataIframe, 5000);
setTimeout(reloadDataIframe, 1000);

guidCount = 1;
getGuid = () -> return guidCount++;

# callback for a loaded information source
window.sourceLoaded = (s) ->
  waiting = window._SOURCES[s]
  if ($.isArray(waiting))
    initNotes(n) for n in waiting

# read the clean lines from an input source
readCleanLines = (source) ->
  raw = window._DATA[source].split("\n")
  return (r.trim() for r in raw when r.trim().length > 0 && r.substr(0, 2) != '--')

######################
## USEFUL FUNCTIONS ##
######################

# note getter
getNote = (i) -> $ 'div#note-' + i

# creates a background div in a note
getBackgroundDiv = (note) ->
  note.html('<div class="note-extra-bg"></div>')
  return note.find('.note-extra-bg')

# creates a centered div in a note
getCenterDiv = (note, full = true) ->
  note.addClass('note-center-outer' + (if full then '-full' else ''))
  note.html(note.html() + '<div class="note-center-inner"></div>')
  return note.find('.note-center-inner')

# adds a title to a note
setNoteTitle = (note, title) ->
  note.html(note.html() + '<p class="note-title">' + title + '</p>')

###########
## NOTES ##
###########

# define notes
notes = [
  {
    id: 0, job: 'ticker', data: 'news-ticker'
  },
  {
    id: 1, job: 'clock', data: null
  },
  {
    id: 2, job: 'feedback', data: 'feedback'
  },
  {
    id: 3, job: 'tweets', data: 'tweets'
  },
  {
    id: 4, job: 'dial', data: 'dial-1'
  },
  {
    id: 5, job: 'dial', data: 'dial-2'
  },
  {
    id: 6, job: 'identify', data: null
  },
  {
    id: 7, job: 'identify', data: null
  },
  {
    id: 8, job: 'identify', data: null
  },
  {
    id: 9, job: 'identify', data: null
  },
  {
    id: 10, job: 'identify', data: null
  },
  {
    id: 11, job: 'identify', data: null
  }
]

# start tasks
$(document).ready ->
  initNotes()

# note initialisation
initNotes = (n = -1) ->
# init a specific note
  if (n >= 0)
    loadNote(notes[n].id, notes[n].job, notes[n]?.data)
    return

  # init all notes
  i = 0;
  loop
    data = notes[i]?.data
    if (data == null)
      loadNote(notes[i].id, notes[i].job, null)
    else
      if ($.isArray(window._SOURCES[data]))
        window._SOURCES[data][window._SOURCES[data].length] = i
      else
        window._SOURCES[data] = [i]
    ++i;
    break if (i == notes.length)

# note loader
loadNote = (id, role, data) ->
  switch role
    when 'clock' then load_clock(id)
    when 'dial' then load_dial(id, data)
    when 'feedback' then load_feedback(id)
    when 'identify' then load_identify(id)
    when 'ticker' then load_ticker()
    when 'tweets' then load_tweets(id)

##################
## NOTE JOB: ID ##
##################

# identification note
load_identify = (id) ->
  note = getNote(id)
  center = getCenterDiv(note)
  center.html(id)

#####################
## NOTE JOB: CLOCK ##
#####################

# clock note
load_clock = (id) ->
  note = getNote(id)
  bg = getBackgroundDiv(note)
  bg.css('background-image', 'url("images/clock-bg.png")');
  bg.css('background-size', 'auto 85%');
  center = getCenterDiv(bg)
  center.html('<p class="clock-time"</p><p class="clock-date"></p>')
  clockCycle()

# cycles the clock
clockCycle = () ->
  now = new Date();

  # build time
  h = now.getHours();
  m = now.getMinutes();
  if h < 10 then h = '0' + h
  if m < 10 then m = '0' + m
  time = h + ':' + m

  # build date
  d = now.getDate()
  m = now.getMonth()
  date = d + getDateOrd(d) + " " + getMonthName(m)

  # set HTML and repeat
  $('.clock-time').html(time)
  $('.clock-date').html(date)
  setTimeout(clockCycle, 500)

getDateOrd = (n) ->
  ordinals = [false, 'st', 'nd', 'rd'];
  m = n % 100;
  if m > 10 && m < 14 then 'th' else ordinals[m % 10] || 'th';

getMonthName = (n) ->
  months = ['January', 'February', 'March',
            'April', 'May', 'June',
            'July', 'August', 'September',
            'October', 'November', 'December']
  return months[n]

####################
## NOTE JOB: DIAL ##
####################

load_dial = (id, data) ->
## read values
  values = readCleanLines(data)

  ## set up note
  note = getNote(id)
  note.html('')
  center = getCenterDiv(note, false)
  setNoteTitle(center, values[0])
  knobGuid = getGuid()
  center.html(center.html() + '<input type="text" id="knob-' + knobGuid + '">')

  ## knob-ify
  $('#knob-' + knobGuid).val(values[3]).knob({
    width: 110,
    angleArc: 250,
    angleOffset: -125,
    fgColor: '#ffffff',
    bgColor: 'rgba(255, 255, 255, 0.3)',
    readOnly: true,
    displayPrevious: true,
    min: values[1],
    max: values[2]
  })

######################
## NOTE JOB: TICKER ##
######################

# ticker info
tickerWidth = tickerWrapperWidth = tickerLeft = 0
tickerSeparator = '<span>&nbsp;&nbsp;&bull;&nbsp;&nbsp;</span>'

# ticker initialisation
tickerRunning = false;
load_ticker = () ->
  return if tickerRunning
  tickerRunning = true
  loadTickerText()
  getTickerWidths()
  tickerMove()

# gets ticker widths
getTickerWidths = () ->
  tickerWidth = $('.ticker-text').width()
  tickerWrapperWidth = $('.ticker').width()

# ticker text population
loadTickerText = () ->
  $('.ticker-text').html('');
  lines = readCleanLines('news-ticker')
  addToTicker(r, i) for r, i in lines

# add a string to the ticker
addToTicker = (r, i) ->
  tickerText = $('.ticker-text')
  if i > 0 then tickerText.html(tickerText.html() + tickerSeparator)
  tickerText.html(tickerText.html() + r)

# ticker mover
tickerMove = () ->
  if --tickerLeft < -tickerWidth
    loadTickerText()
    getTickerWidths()
    tickerLeft = tickerWrapperWidth
  $('.ticker-text').css('margin-left', tickerLeft + 'px')
  setTimeout(tickerMove, 16)

######################
## NOTE JOB: TWEETS ##
######################

tweetsRunning = false;
load_tweets = (id) ->
  loadTweetText()
  return if tweetsRunning
  tweetsRunning = true
  note = getNote(id)
  bg = getBackgroundDiv(note)
  bg.css('background-image', 'url("images/twitter-bg.png")');
  bg.css('background-size', 'auto 85%');
  center = getCenterDiv(bg)
  center.html('<p class="tweet-content"></p><p class="tweet-name"></p>')
  window._DATA['current-tweet'] = 0;
  tweetCycle()

tweetCycle = () ->
  ++window._DATA['current-tweet']
  window._DATA['current-tweet'] = 0 if (window._DATA['current-tweet'] >= window._DATA['tweet-text'].length)
  $('.tweet-name').html(window._DATA['tweet-text'][window._DATA['current-tweet']][0])
  $('.tweet-content').html("&quot;" + window._DATA['tweet-text'][window._DATA['current-tweet']][1] + "&quot;")
  setTimeout(tweetCycle, 15000)

loadTweetText = () ->
  lines = readCleanLines('tweets')
  window._DATA['tweet-text'] = [];
  i = 0
  loop
    window._DATA['tweet-text'][window._DATA['tweet-text'].length] = [lines[i], lines[i + 1]]
    i += 2
    break if i >= lines.length

########################
## NOTE JOB: FEEDBACK ##
########################

feedbackRunning = false;
load_feedback = (id) ->
  loadFeedbackText()
  return if feedbackRunning
  feedbackRunning = true
  note = getNote(id)
  bg = getBackgroundDiv(note)
  bg.css('background-image', 'url("images/feedback-bg.png")');
  bg.css('background-size', 'auto 85%');
  center = getCenterDiv(bg)
  center.html('<p class="feedback-agent"></p><p class="feedback-content"></p><p class="feedback-name"></p>')
  window._DATA['current-feedback'] = 0;
  feedbackCycle()

feedbackCycle = () ->
  ++window._DATA['current-feedback']
  window._DATA['current-feedback'] = 0 if (window._DATA['current-feedback'] >= window._DATA['feedback-text'].length)
  $('.feedback-agent').html(window._DATA['feedback-text'][window._DATA['current-feedback']][0])
  $('.feedback-content').html("&quot;" + window._DATA['feedback-text'][window._DATA['current-feedback']][1] + "&quot;")
  $('.feedback-name').html(window._DATA['feedback-text'][window._DATA['current-feedback']][2])
  setTimeout(feedbackCycle, 15000)

loadFeedbackText = () ->
  lines = readCleanLines('feedback')
  window._DATA['feedback-text'] = [];
  i = 0
  loop
    window._DATA['feedback-text'][window._DATA['feedback-text'].length] = [lines[i], lines[i + 1], lines[i + 2]]
    i += 3
    break if i >= lines.length