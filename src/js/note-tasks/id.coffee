##################
## NOTE JOB: ID ##
##################

w = window

## show the note's ID number
w.load_identify = (id) ->
  note = w.getNote(id)
  center = w.getCenterDiv(note)
  center.html(id)