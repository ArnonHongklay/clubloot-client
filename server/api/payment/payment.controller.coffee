
'use strict'

_ = require 'lodash'
Payment = require './payment.model'

# Get list of payments
exports.index = (req, res) ->
  Payment.find (err, payments) ->
    return handleError(res, err)  if err
    res.status(200).json payments


# Get a single payment
exports.show = (req, res) ->
  Payment.findById req.params.id, (err, payment) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless payment
    res.json payment

# Creates a new payment in the DB.
exports.create = (req, res) ->
  Payment.create req.body, (err, payment) ->
    return handleError(res, err)  if err
    res.status(201).json payment

# Updates an existing payment in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Payment.findById req.params.id, (err, payment) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless payment
    updated = _.merge(payment, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json payment

# Deletes a payment from the DB.
exports.destroy = (req, res) ->
  Payment.findById req.params.id, (err, payment) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless payment
    payment.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
