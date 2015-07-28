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

  ## two center divs
  w.getCenterDiv(note, false)
  center = w.getCenterDiv(note, false)
  w.setNoteTitle(center.eq(0), values[0])
  w.setNoteTitle(center.eq(1), values[0])

  ## create two basic inputs
  knobGuid1 = w.getGuid()
  knobGuid2 = w.getGuid()
  center.eq(0).html(center.eq(0).html() + '<input type="text" id="knob-' + knobGuid1 + '">')
  center.eq(1).html(center.eq(1).html() + '<input type="text" id="knob-' + knobGuid2 + '">')

  ## calc size
  size = note.height() - center.eq(0).find('.note-title').height();

  ## knob-ify base
  $('#knob-' + knobGuid1).val(values[3]).knob({
    width: size,
    angleArc: 250,
    angleOffset: -125,
    fgColor: '#ffffff',
    bgColor: 'rgba(255, 255, 255, 0.3)',
    readOnly: true,
    format: (v) -> v + '%',
    min: values[1],
    max: values[2]
  })

  ## knob-ify overlay
  $('#knob-' + knobGuid2).val(values[4]).knob({
    width: size,
    angleArc: 250,
    angleOffset: -125,
    fgColor: note.css('background-color'),
    bgColor: 'transparent',
    readOnly: true,
    cursor: 3,
    thickness: 0.4,
    displayInput: false,
    min: values[1],
    max: values[2]
  })

  ## move second center div over the first one
  center.eq(1).css({
    float: 'right',
    position: 'relative',
    'margin-top': '-' + center.eq(0).height() + 'px',
    'z-index': 1000
  });