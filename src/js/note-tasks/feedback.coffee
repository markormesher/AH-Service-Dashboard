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
  center.html('<p class="feedback feedback-agent"></p><p class="feedback feedback-content"></p><p class="feedback feedback-name"></p>')

  ## start cycling
  w._DATA['current-feedback'] = 0
  setTimeout(feedbackCycle, w.feedbackDelay)

## progresses to the next cycle
feedbackCycle = () ->
## increment pointer
  ++w._DATA['current-feedback']
  w._DATA['current-feedback'] = 0 if (w._DATA['current-feedback'] >= w._DATA['feedback-text'].length)

  ## populate HTML
  $('.feedback').fadeOut(
    400,
    () ->
      $('.feedback-agent').html(w._DATA['feedback-text'][w._DATA['current-feedback']][0])
      $('.feedback-content').html("&quot;" + w._DATA['feedback-text'][w._DATA['current-feedback']][1] + "&quot;")
      $('.feedback-name').html(w._DATA['feedback-text'][w._DATA['current-feedback']][2])
      $('.feedback').fadeIn(400)
  )

  ## repeat
  setTimeout(feedbackCycle, w.feedbackSpeed)

## load text from file
loadFeedbackText = () ->
  lines = w.readCleanLines('feedback')
  w._DATA['feedback-text'] = [];
  i = 0
  loop
    w._DATA['feedback-text'][w._DATA['feedback-text'].length] = [
      (if lines[i] == '#' then '' else lines[i]),
      lines[i + 1],
      lines[i + 2]
    ]
    i += 3
    break if i >= lines.length
