###*
Broadcast updates to client when the model changes
###
'use strict'

contest = require './contest.model'

exports.register = (socket) ->
  # console.log "exports--"
  # console.log contest.schema.post
  # console.log "========="
  contest.schema.post 'save', (doc) ->
    # console.log doc
    # console.log "doc save====================----"
    onSave socket, doc
onSave = (socket, doc, cb) ->
  socket.emit 'contest:save', doc
