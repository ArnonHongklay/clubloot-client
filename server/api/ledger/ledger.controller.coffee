'use strict'

_ = require 'lodash'
Prize  = require '../prize/prize.model'
Ledger = require './ledger.model'


handleError = (res, err) ->
  res.status(500).json err

exports.index = (req, res) ->
  Ledger.find().sort(created_at: -1).exec (err, ledgers) ->
    return handleError(res, err) if err
    res.status(200).json ledgers

exports.create = (req, res) ->
  params = req.body
  user = params['user']
  amount = params['transaction'].amount
  ref = params['transaction'].ref

  Ledger.create {
    status: 'pending'
    format: 'prize'
    user: {
      id:       user._id,
      username: user.username
      name:     "#{user.first_name} #{user.last_name}",
      email:    user.email
    }
    balance: {
      coins:      user.coins
      diamonds:   user.diamonds
      emeralds:   user.emeralds
      sapphires:  user.sapphires
      rubies:     user.rubies
    }
    transaction: [
      {
        action:       'minus'
        description:  'Prize'
        from:         'diamonds'
        to:           'prize'
        unit:         'diamonds'
        amount:       amount
        tax:          0
        ref:          ref
      }
    ]
  }, (err, ledger) ->
    return handleError(res, err) if err
    res.status(201).json ledger

exports.show = (req, res) ->
  Ledger.findById req.params.id, (err, ledgers) ->
    return handleError(res, err) if err
    return res.status(404).end() unless ledgers
    res.json ledgers

exports.complete = (req, res) ->
  Ledger.findById req.params.id, (err, prize) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless prize
    prize.status          = 'completed'
    prize.details.tracking_number = req.body.tracking_number
    prize.details.carrier         = req.body.carrier
    prize.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json prize

exports.byDate = (req, res) ->
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  Ledger.find({ created_at: {$gte: s, $lt: e} }).exec (err, ledgers) ->
    return handleError(res, err)  if err
    res.status(200).json ledgers
