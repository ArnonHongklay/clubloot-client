'use strict'

_ = require 'lodash'
Prize  = require './prize.model'
Ledger = require '../ledger/ledger.model'
config = require '../../config/environment'

# Get list of prizes
exports.index = (req, res) ->
  Prize.find (err, prizes) ->
    return handleError(res, err)  if err
    res.status(200).json prizes

# Get a single prize
exports.show = (req, res) ->
  Prize.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize
    res.json prize

# Creates a new prize in the DB.
exports.create = (req, res) ->
  file = req.files.file
  body = req.body
  body.prize.picture = file.path.replace(config.root + '/client', '')

  Prize.create body.prize, (err, prize) ->
    return handleError(res, err)  if err
    res.status(201).json prize

# Updates an existing prize in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id

  Prize.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize

    body = req.body
    if req.files
      file = req.files.file
      body.prize.picture = file.path.replace(config.root + '/client', '')

    updated = _.merge(prize, body.prize)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json prize

# Deletes a prize from the DB.
exports.destroy = (req, res) ->
  Prize.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize
    prize.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

exports.putCountPrize = (req, res) ->
  total = 0
  Ledger.where('transaction.format').equals('prize')
        .where('transaction.ref.id').equals(req.params.id)
        .count()
        .exec (err, ledger) ->
    total = ledger
    Prize.findById req.params.id, (err, prize) ->
      updated = _.merge(prize, {count: total})
      updated.save (err) ->
        return handleError(res, err)  if err
        res.status(200).json prize

handleError = (res, err) ->
  res.status(500).json err
