#####################
## NOTE JOB: CLOCK ##
#####################

w = window

## shows a clock in the note
w.load_clock = (id) ->
  ## set up the note HTML
  note = w.getNote(id)
  bg = w.getBackgroundDiv(note)
  bg.css('background-image', 'url("images/clock-bg.png")');
  bg.css('background-size', 'auto 85%');
  center = w.getCenterDiv(bg)
  center.html('<p class="clock-time"</p><p class="clock-date"></p>')

  ## start the clock
  clockCycle()

## cycles the clock
clockCycle = () ->
  now = new Date();

  ## build time
  h = now.getHours();
  m = now.getMinutes();
  if h < 10 then h = '0' + h
  if m < 10 then m = '0' + m
  time = h + ':' + m

  ## build date
  d = now.getDate()
  m = now.getMonth()
  date = d + w.getOrdinal(d) + " " + getMonthName(m)

  ## set HTML and repeat
  $('.clock-time').html(time)
  $('.clock-date').html(date)
  setTimeout(clockCycle, 500)

## get the string name of a month
getMonthName = (n) ->
  months = ['January', 'February', 'March',
            'April', 'May', 'June',
            'July', 'August', 'September',
            'October', 'November', 'December']
  return months[n]
