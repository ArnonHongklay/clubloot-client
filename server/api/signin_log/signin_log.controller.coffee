
'use strict'

_ = require 'lodash'
SigninLog = require './signin_log.model'

# Get list of templates
exports.index = (req, res) ->
  SigninLog.find (err, SigninLogs) ->
    return handleError(res, err)  if err
    res.status(200).json SigninLogs

exports.create = (req, res) ->
  # console.log "-------------------"
  # console.log req.body
  SigninLog.create req.body, (err, SigninLog) ->
    return handleError(res, err)  if err
    res.status(201).json SigninLog

exports.by_date = (req, res) ->
  console.log req.body
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  SigninLog.find { created_at: {$gte: s, $lt: e} }, (err, signinLogs) ->
    return handleError(res, err)  if err
    res.status(200).json signinLogs


exports.index = (req, res) ->
  SigninLog.find (err, SigninLogs) ->
    return handleError(res, err)  if err
    res.status(200).json SigninLogs

exports.today = (req, res) ->
  start = new Date()
  s = start.setHours(0,0,0,0)
  end = new Date()
  e = end.setHours(23,59,59,999)

  SigninLog.find { created_at: {$gte: s, $lt: e} }, (err, SigninLogs) ->
    return handleError(res, err)  if err
    res.status(200).json SigninLogs



exports.show = (req, res) ->
  SigninLog.findById req.params.id, (err, SigninLog) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless SigninLog
    res.json SigninLog

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  SigninLog.findById req.params.id, (err, SigninLog) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless SigninLog
    updated = _.merge(SigninLog, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json SigninLog
