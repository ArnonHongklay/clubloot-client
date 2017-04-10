###*
Broadcast updates to client when the model changes
###
'use strict'

question = require './question.model'

exports.register = (socket) ->
  # console.log "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
  # console.log question
  question.schema.post 'save', (doc) ->
    onSave socket, doc

onSave = (socket, doc, cb) ->
  socket.emit 'question:save', doc
