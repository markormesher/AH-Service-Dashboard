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
  bg1 = w.getBackgroundDiv(note)
  bg1.addClass('slide-show-target')
  bg2 = w.getBackgroundDiv(bg1)
  bg2.css('background-image', 'url("images/note-point.png")');
  bg2.css('background-position', 'bottom right');
  bg2.css('background-repeat', 'no-repeat');

  ## start cycling
  w._DATA['current-slide-show'] = 0
  setTimeout(slideShowCycle, w.slideShowDelay)

## progresses to the next cycle
slideShowCycle = () ->
## increment pointer
  ++w._DATA['current-slide-show']
  w._DATA['current-slide-show'] = 0 if (w._DATA['current-slide-show'] >= w._DATA['slide-show-names'].length)

  ## change BG
  $('.slide-show-target').fadeOut(
    400,
    () ->
      $('.slide-show-target').css(
        'background-image',
        'url("data/slide-show/' + w._DATA['slide-show-names'][w._DATA['current-slide-show']] + '")'
      )
      $('.slide-show-target').fadeIn(400)
  )

  ## repeat
  setTimeout(slideShowCycle, w.slideShowSpeed)

## load names from file
loadSlideShowNames = () ->
  w._DATA['slide-show-names'] = w.readCleanLines('slide-show')
