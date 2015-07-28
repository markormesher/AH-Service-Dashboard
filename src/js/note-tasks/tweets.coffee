######################
## NOTE JOB: TWEETS ##
######################

w = window

## cycles tweets in the note
tweetsRunning = false;
w.load_tweets = (id) ->
  ## reload text
  loadTweetText()

  ## init only once
  return if tweetsRunning
  tweetsRunning = true

  ## set up HTML
  note = w.getNote(id)
  bg = w.getBackgroundDiv(note)
  bg.css('background-image', 'url("images/twitter-bg.png")');
  bg.css('background-size', 'auto 85%');
  center = w.getCenterDiv(bg)
  center.html('<p class="tweet-content"></p><p class="tweet-name"></p>')

  ## start cycling
  w._DATA['current-tweet'] = 0;
  tweetCycle()

## progresses to the next cycle
tweetCycle = () ->
  ## increment pointer
  ++w._DATA['current-tweet']
  w._DATA['current-tweet'] = 0 if (w._DATA['current-tweet'] >= w._DATA['tweet-text'].length)

  ## populate HTML
  $('.tweet-name').html(w._DATA['tweet-text'][w._DATA['current-tweet']][0])
  $('.tweet-content').html("&quot;" + w._DATA['tweet-text'][w._DATA['current-tweet']][1] + "&quot;")

  ## repeat
  setTimeout(tweetCycle, 15000)

## load text from file
loadTweetText = () ->
  lines = w.readCleanLines('tweets')
  w._DATA['tweet-text'] = [];
  i = 0
  loop
    w._DATA['tweet-text'][w._DATA['tweet-text'].length] = [lines[i], lines[i + 1]]
    i += 2
    break if i >= lines.length
