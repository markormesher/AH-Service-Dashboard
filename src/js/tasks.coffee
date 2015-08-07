##############
## SETTINGS ##
##############

w = window

w.feedbackDelay = 0;
w.feedbackSpeed = 15000;
w.tweetsDelay = 5000;
w.tweetsSpeed = 15000;
w.slideShowDelay = 10000;
w.slideShowSpeed = 15000;

###########
## NOTES ##
###########

## define notes
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
    id: 6, job: 'leader-board', data: 'leader-board-1'
  },
  {
    id: 7, job: 'slide-show', data: 'slide-show'
  },
  {
    id: 8, job: 'leader-board', data: 'leader-board-2'
  },
  {
    id: 9, job: '', data: null
  },
  {
    id: 10, job: 'call-volumes', data: 'call-volumes'
  },
  {
    id: 11, job: '', data: null
  },
  {
    id: 12, job: '', data: null
  }
]

## start tasks
$(document).ready ->
  initNotes()

## note initialisation
window.initNotes = (n = -1) ->
  ## init a specific note
  if (n >= 0)
    loadNote(notes[n].id, notes[n].job, notes[n]?.data)
    return

  ## init all notes
  i = 0;
  loop
    data = notes[i]?.data
    if (data == null)
      loadNote(notes[i].id, notes[i].job, null)
    else
      if ($.isArray(w._HOOKS[data]))
        w._HOOKS[data][w._HOOKS[data].length] = i
      else
        w._HOOKS[data] = [i]
    ++i;
    break if (i == notes.length)

## note loader
loadNote = (id, role, data) ->
  w = window
  switch role
    when 'call-volumes' then w.load_call_volumes(id, data)
    when 'clock' then w.load_clock(id)
    when 'dial' then w.load_dial(id, data)
    when 'feedback' then w.load_feedback(id)
    when 'leader-board' then w.load_leader_board(id, data)
    when 'identify' then w.load_identify(id)
    when 'slide-show' then w.load_slide_show(id)
    when 'ticker' then w.load_ticker()
    when 'tweets' then w.load_tweets(id)