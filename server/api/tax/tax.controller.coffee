
'use strict'

_ = require 'lodash'
Tax = require './tax.model'

# Get list of taxs
exports.index = (req, res) ->
  Tax.find (err, taxs) ->
    return handleError(res, err)  if err
    res.status(200).json taxs

# Get a single tax
exports.show = (req, res) ->
  Tax.findById req.params.id, (err, tax) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless tax
    res.json tax

exports.by_date = (req, res) ->
  console.log req.body
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  Tax.find { created_at: {$gte: s, $lt: e} }, (err, tags) ->
    return handleError(res, err)  if err
    res.status(200).json tags


# Creates a new tax in the DB.
exports.create = (req, res) ->

  Tax.create req.body, (err, tax) ->
    return handleError(res, err)  if err


    res.status(201).json tax

# Updates an existing tax in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Tax.findById req.params.id, (err, tax) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless tax
    updated = _.merge(tax, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json tax

# Deletes a tax from the DB.
exports.destroy = (req, res) ->
  Tax.findById req.params.id, (err, tax) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless tax
    tax.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
