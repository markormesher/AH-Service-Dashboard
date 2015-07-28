###########
## UTILS ##
###########

w = window

## globally unique IDs
guidCount = 1000;
w.getGuid = () -> return guidCount++;

## gets the outer div for a note
w.getNote = (i) -> $ 'div#note-' + i

## creates a background div in a note
w.getBackgroundDiv = (note) ->
  note.html('<div class="note-extra-bg"></div>')
  return note.find('.note-extra-bg')

## creates a centered div in a note
w.getCenterDiv = (note, full = true) ->
  note.addClass('note-center-outer' + (if full then '-full' else ''))
  note.html(note.html() + '<div class="note-center-inner"></div>')
  return note.find('.note-center-inner')

## adds a title to a note
w.setNoteTitle = (note, title) ->
  note.html(note.html() + '<p class="note-title">' + title + '</p>')

## gets the string ordinal for the given number
w.getOrdinal = (n) ->
  ordinals = [false, 'st', 'nd', 'rd'];
  m = n % 100;
  if m > 10 && m < 14 then 'th' else ordinals[m % 10] || 'th';
