############################
## NOTE JOB: CALL VOLUMES ##
############################

w = window

w.load_call_volumes = (id, data) ->
  ## read values
  values = w.readCleanLines(data)

  ## set up the note HTML
  note = w.getNote(id)
  note.html("");
  bg = w.getBackgroundDiv(note)
  bg.css('background-image', 'url("images/phone-bg.png")');
  bg.css('background-size', 'auto 85%');
  center = w.getCenterDiv(bg)

  ## populate note
  i = 0
  loop
    value = values[i + 1];
    line = values[i];
    line = line.replace(/###/, "<span>#{value}</span>")
    center.html(center.html() + "<p class=\"call-volumes-line\">#{line}</p>")
    i += 2
    break if i >= values.length