
'use strict'

_ = require 'lodash'
Broadcast = require './broadcast.model'

schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()

User     = require '../user/user.model'

c_socket = ""

exports.register = (socket) ->
  c_socket = socket

# Get list of broadcasts
exports.index = (req, res) ->
  Broadcast.find (err, broadcasts) ->
    return handleError(res, err)  if err
    res.status(200).json broadcasts

# Get a single broadcast
exports.show = (req, res) ->
  Broadcast.findById req.params.id, (err, broadcast) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless broadcast
    res.json broadcast


# Creates a new broadcast in the DB.
exports.create = (req, res) ->
  # console.log "--------------------"
  # console.log req.body
  Broadcast.create req.body, (err, broadcast) ->
    return handleError(res, err)  if err

    schedule.scheduleJob(broadcast.publish_time, ->
      # console.log "999999999999999999999990000000000000000000000000"
      # console.log broadcast
      User.update {}, { $push: {messages: broadcast} }, { upsert: true, multi: true }, (err) ->
        # console.log "9999"
        # console.log broadcast
        c_socket.emit 'message', broadcast if c_socket != ""
    )


    res.status(201).json broadcast

# Updates an existing broadcast in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Broadcast.findById req.params.id, (err, broadcast) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless broadcast
    updated = _.merge(broadcast, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json broadcast

# Deletes a broadcast from the DB.
exports.destroy = (req, res) ->
  Broadcast.findById req.params.id, (err, broadcast) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless broadcast
    broadcast.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
