############################
## NOTE JOB: LEADER BOARD ##
############################

w = window

## shows a leaderboard in the note
w.load_leader_board = (id, data) ->
  ## read values
  values = w.readCleanLines(data)

  ## set up note HTML
  note = w.getNote(id)
  bg = w.getBackgroundDiv(note)
  bg.css('background-image', 'url("images/leader-board-bg.png")');
  bg.css('background-size', 'auto 85%');
  bg.html('')
  w.setNoteTitle(bg, values[0])

  ## enter names
  i = 1
  output = ''
  loop
    output += '<p class="leader-board-entry"><span>' + i + '<sup>' + w.getOrdinal(i) + '</sup></span> ' + values[i] + '</p>'
    ++i
    break if i >= values.length
  bg.html(bg.html() + output)