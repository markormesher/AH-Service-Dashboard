########################
## NOTE JOB: FEEDBACK ##
########################

w = window

## cycles feedback in the note
feedbackRunning = false;
w.load_feedback = (id) ->
  ## reload text
  loadFeedbackText()

  ## init only once
  return if feedbackRunning
  feedbackRunning = true

  ## set up HTML
  note = w.getNote(id)
  bg = w.getBackgroundDiv(note)
  bg.css('background-image', 'url("images/feedback-bg.png")');
  bg.css('background-size', 'auto 85%');
  center = w.getCenterDiv(bg)
  center.html('<p class="feedback-agent"></p><p class="feedback-content"></p><p class="feedback-name"></p>')

  ## start cycling
  w._DATA['current-feedback'] = 0;
  feedbackCycle()

## progresses to the next cycle
feedbackCycle = () ->
## increment pointer
  ++w._DATA['current-feedback']
  w._DATA['current-feedback'] = 0 if (w._DATA['current-feedback'] >= w._DATA['feedback-text'].length)

  ## hide first <p> for empty input
  if (w._DATA['feedback-text'][w._DATA['current-feedback']][0] == '#')
    $('.feedback-agent').hide()
  else
    $('.feedback-agent').show()

  ## populate HTML
  $('.feedback-agent').html(w._DATA['feedback-text'][w._DATA['current-feedback']][0])
  $('.feedback-content').html("&quot;" + w._DATA['feedback-text'][w._DATA['current-feedback']][1] + "&quot;")
  $('.feedback-name').html(w._DATA['feedback-text'][w._DATA['current-feedback']][2])

  ## repeat
  setTimeout(feedbackCycle, 15000)

## load text from file
loadFeedbackText = () ->
  lines = w.readCleanLines('feedback')
  w._DATA['feedback-text'] = [];
  i = 0
  loop
    w._DATA['feedback-text'][w._DATA['feedback-text'].length] = [lines[i], lines[i + 1], lines[i + 2]]
    i += 3
    break if i >= lines.length
