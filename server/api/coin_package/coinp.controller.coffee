'use strict'

_ = require 'lodash'
Coinp = require './coinp.model'
User  = require '../user/user.model'

# Get list of contests
exports.index = (req, res) ->
  Coinp.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

# Get a single contest
exports.show = (req, res) ->
  Coinp.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    res.json contest

exports.set = (req, res) ->
  Coinp.remove {}, (err) ->
    # console.log 'collection removed'
    return gem = {
      diamond:  { rate: 5},
      emerald:  { rate: 5},
      sapphire: { rate: 5},
      ruby:     { rate: 100}
    }

  Coinp.create gem, (err, gems) ->
    if err
      return handleError(err)
    # saved!
    res.json gems

# Creates a new contest in the DB.
exports.create = (req, res) ->
  Coinp.create req.body, (err, contest) ->
    return handleError(res, err)  if err
    res.status(201).json contest

exports.addcoin = (req, res) ->
  Coinp.findById req.body._id, (err, coinp) ->
    addedCoin = coinp.coins + coinp.bonus
    User.findById req.params.user, (err, user) ->
      user.coins = user.coins + addedCoin
      user.save (err) ->
        res.json user

    # return handleError(res, err)  if err
    # return res.status(404).end()  unless user
    # updated = _.merge(user, req.body)
    # updated.save (err) ->
    #   return handleError(res, err)  if err

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Coinp.findById req.params.id, (err, coinp) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless coinp
    updated = _.merge(coinp, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json coinp

exports.destroy = (req, res) ->
  Coinp.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    contest.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
