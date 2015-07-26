###########
## NOTES ##
###########

# define notes
notes = [
  {
    id: 1, job: 'clock'
  },
  {
    id: 2, job: 'identify'
  },
  {
    id: 3, job: 'identify'
  },
  {
    id: 4,
    job: 'dial',
    data: {
      title: 'Today\'s GOS'
    }
  },
  {
    id: 5,
    job: 'dial',
    data: {
      title: 'MTD GOD'
    }
  },
  {
    id: 6, job: 'identify'
  },
  {
    id: 7, job: 'identify'
  },
  {
    id: 8, job: 'identify'
  },
  {
    id: 9, job: 'identify'
  },
  {
    id: 10, job: 'identify'
  },
  {
    id: 11, job: 'identify'
  }
]

# note getter
getNote = (i) -> $ 'div#note-' + i

# creates a background div in a note
getBackgroundDiv = (note) ->
  note.html('<div class="note-extra-bg"></div>')
  return note.find('.note-extra-bg')

# creates a centered div in a note
getCenterDiv = (note) ->
  note.addClass('note-center-outer')
  note.html('<div class="note-center-inner"></div>')
  return note.find('.note-center-inner')

# adds a title to a note
setNoteTitle = (note, title) ->
  note.html(note.html() + '<p class="note-title">' + title + '</p>')

# start tasks
$(document).ready ->
  initNotes()
  initTicker()

# note initialisation
initNotes = -> loadNote(n.id, n.job, n?.data) for n in notes

# note loader
loadNote = (id, role, data) ->
  switch role
    when 'identify' then load_identify(id)
    when 'clock' then load_clock(id, data)
    when 'dial' then load_dial(id, data)

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
load_clock = (id, data) ->
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
  note = getNote(id)
  setNoteTitle(note, data.title)

############
## TICKER ##
############

# ticker info
tickerWidth = tickerWrapperWidth = tickerLeft = 0
tickerSeparator = '<span>&nbsp;&nbsp;&bull;&nbsp;&nbsp;</span>'

# ticker initialisation
initTicker = () ->
  loadTickerText()
  tickerWidth = $('.ticker-text').width()
  tickerWrapperWidth = $('.ticker').width()
  tickerMove()

# ticker text population
loadTickerText = () ->
  raw = newsTickerContent.split("\n")
  real = (r.trim() for r in raw when r.trim().length > 0 && r.substr(0, 2) != '--')
  addToTicker(r, i) for r, i in real

# add a string to the ticker
addToTicker = (r, i) ->
  tickerText = $('.ticker-text')
  if i > 0 then tickerText.html(tickerText.html() + tickerSeparator)
  tickerText.html(tickerText.html() + r)

# ticker mover
tickerMove = () ->
  if --tickerLeft < -tickerWidth
    tickerLeft = tickerWrapperWidth
  $('.ticker-text').css('margin-left', tickerLeft + 'px')
  setTimeout(tickerMove, 16)