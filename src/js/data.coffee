###################
## DATA HANDLING ##
###################

w = window

w._DATA = {}
w._HOOKS = {}

## receive data
w.onmessage = (e) ->
  ## refresh command?
  if (e.data.data == 'REFRESH')
    location.reload()
    return

  w._DATA[e.data.source] = e.data.data
  ## initialise any notes waiting for this data
  for name, waiting of w._HOOKS
    if e.data.source == name then window.initNotes(i) for i in waiting

## reload the data iframe
reloadDataIframe = () ->
  $('#js-iframe').attr('src', 'data.html');
  setTimeout(reloadDataIframe, 5000);
setTimeout(reloadDataIframe, 1000);


## read the clean lines from an input source
w.readCleanLines = (source) ->
  raw = w._DATA[source].split("\n")
  return (r.trim() for r in raw when r.trim().length > 0 && r.substr(0, 2) != '--')