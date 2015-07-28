##########################
## NOTE JOB: SLIDE SHOW ##
##########################

w = window

## cycles slideshow images in the note
slideShowRunning = false;
w.load_slide_show = (id) ->
## reload text
  loadSlideShowNames()

  ## init only once
  return if slideShowRunning
  slideShowRunning = true

  ## set up HTML
  note = w.getNote(id)
  note.addClass('slide-show-target')
  bg = w.getBackgroundDiv(note)
  bg.css('background-image', 'url("images/note-point.png")');
  bg.css('background-position', 'bottom right');
  bg.css('background-repeat', 'no-repeat');

  ## start cycling
  w._DATA['current-slide-show'] = 0;
  slideShowCycle()

## progresses to the next cycle
slideShowCycle = () ->
## increment pointer
  ++w._DATA['current-slide-show']
  w._DATA['current-slide-show'] = 0 if (w._DATA['current-slide-show'] >= w._DATA['slide-show-names'].length)

  ## change BG
  $('.slide-show-target').css(
    'background-image',
    'url("data/slide-show/' + w._DATA['slide-show-names'][w._DATA['current-slide-show']] + '")'
  )

  ## repeat
  setTimeout(slideShowCycle, 15000)

## load names from file
loadSlideShowNames = () ->
  w._DATA['slide-show-names'] = w.readCleanLines('slide-show')
