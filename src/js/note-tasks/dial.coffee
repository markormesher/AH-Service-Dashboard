####################
## NOTE JOB: DIAL ##
####################

w = window

## displays a dial in the note
w.load_dial = (id, data) ->
  ## read values
  values = w.readCleanLines(data)

  ## set up note HTML
  note = w.getNote(id)
  note.html('')
  center = w.getCenterDiv(note, false)
  w.setNoteTitle(center, values[0])
  knobGuid = w.getGuid()
  center.html(center.html() + '<input type="text" id="knob-' + knobGuid + '">')

  ## knob-ify
  $('#knob-' + knobGuid).val(values[3]).knob({
    width: 110,
    angleArc: 250,
    angleOffset: -125,
    fgColor: '#ffffff',
    bgColor: 'rgba(255, 255, 255, 0.3)',
    readOnly: true,
    displayPrevious: true,
    min: values[1],
    max: values[2]
  })
