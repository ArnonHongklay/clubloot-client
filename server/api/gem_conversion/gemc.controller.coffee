
'use strict'

_ = require 'lodash'
Gemc = require './gemc.model'

# Get list of contests
exports.index = (req, res) ->
  Gemc.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

# Get a single contest
exports.show = (req, res) ->
  Gemc.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    res.json contest

exports.set = (req, res) ->
  # console.log "dsdsdsdssdsdsdsdsdsds"
  Gemc.remove {}, (err) ->
      # console.log 'collection removed'
  gem = {
    diamond:  { rate: 5, fee: 30000},
    emerald:  { rate: 5, fee: 20000},
    sapphire: { rate: 5, fee: 10000},
    ruby:     { rate: 100}
  }

  Gemc.create gem, (err, gems) ->
    if err
      return handleError(err)
    # saved!
    res.json gems

# Creates a new contest in the DB.
exports.create = (req, res) ->
  Gemc.create req.body, (err, contest) ->
    return handleError(res, err)  if err
    res.status(201).json contest

# Updates an existing contest in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Gemc.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    updated = _.merge(contest, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

# Deletes a contest from the DB.
exports.destroy = (req, res) ->
  Gemc.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    contest.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
