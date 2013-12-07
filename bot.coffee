fs = require('fs');
Twit = require("twit")
express = require("express")
_ = require("underscore")
T = new Twit(require("./config.js"))
config = require("./config.js")
request = require('request')


chunks = []
request.get(config.art_url, (err, data) ->
    if err
        console.log "error reading file", err
        return

    broken = breakUp(data.body)
    broken.reverse()
    
    postOne(broken)
    setInterval( ->
        postOne(broken)
    , (1000 * 60))
)

breakUp = (data) ->
    tweets = []
    cursor = 0

    getNextWord = ->
        tweetStart = cursor

        while true
            if cursor > data.length - 1
                tweets.push data.substr tweetStart
                return

            if data[cursor + 1] is '◯' or cursor - tweetStart >= 140
                for backTrack in [0..139]
                    if cursor - backTrack <= 0 or data[cursor - backTrack] is '\n'
                        cursor = cursor - backTrack + 1
                        tweets.push data.substr tweetStart, cursor - tweetStart
                        getNextWord()
                        return

            cursor += 1

    getNextWord()
    return tweets

offset = 0
startTime = 1386384911051
getIndex = ->
    Math.floor((new Date().getTime() - startTime) / 60000)


postOne = (lines) ->
    line = lines[getIndex() % lines.length]
    T.post('statuses/update', { status: line }, (err, reply) ->
        if err
            console.log "error posting status", err
            return
        console.log "posted status", reply
    )

