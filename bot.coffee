fs = require('fs');
Twit = require("twit")
express = require("express")
_ = require("underscore")
T = new Twit(require("./config.js"))
request = require('request')


lines = []
fs.readFile('shapes.txt', 'utf8', (err, data) ->
    if err
        console.log "error reading file", err
        return
    console.log "data", data
)


offset = 0
startTime = 1386384911051
getIndex = ->
    Math.floor((new Date().getTime() - startTime) / 60000)
console.log "Index is", getIndex()


postOne = (lines) ->
    line = lines[getIndex()]
    T.post('statuses/update', { status: line }, (err, reply) ->
        if err
            console.log "error posting status", err
            return
        console.log "posted status", reply
    )

postOne()

setInterval postOne, (1000 * 60)
