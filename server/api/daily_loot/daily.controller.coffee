
'use strict'

_ = require 'lodash'
User  = require '../user/user.model'
Daily = require './daily.model'

Ledger = require '../ledger/ledger.model'

DateDiff =
  inDays: (d1, d2) ->
    t2 = d2.getTime()
    t1 = d1.getTime()
    parseInt (t2 - t1) / (24 * 3600 * 1000)
  inWeeks: (d1, d2) ->
    t2 = d2.getTime()
    t1 = d1.getTime()
    parseInt (t2 - t1) / (24 * 3600 * 1000 * 7)
  inMonths: (d1, d2) ->
    d1Y = d1.getFullYear()
    d2Y = d2.getFullYear()
    d1M = d1.getMonth()
    d2M = d2.getMonth()
    d2M + 12 * d2Y - (d1M + 12 * d1Y)
  inYears: (d1, d2) ->
    d2.getFullYear() - d1.getFullYear()

Daily.find (err, daily) ->
  if daily.length < 1
    Daily.create {
      base: 2000,
      minConsecutive: 5,
      maxConsecutive: 10,
      moreCoin: 100
    }, (err, daily) ->
      console.log daily

exports.index = (req, res) ->
  Daily.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Daily.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    updated = _.merge(contest, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

exports.getFreeLoot = (req, res, next) ->
  dailyConfig = {}

  Daily.find (err, daily) ->
    dailyConfig = daily[0]

  User.findById req.params.id, (err, user) ->
    user.free_loot = false
    counter = 0
    bonus = 0
    baseCoins = dailyConfig.base
    min  = dailyConfig.minConsecutive
    max  = dailyConfig.maxConsecutive
    more = dailyConfig.moreCoin
    previousDay = 0
    for day, index in user.free_loot_log
      if index > 0
        if day.date.getDate() - previousDay == 1 && previousDay != 0
          counter = counter + 1
        else
          counter = 1
        previousDay = day.date.getDate()

    user.free_loot_log.push { date: new Date() }
    counter = max if counter > max
    bonus = counter * more if counter >= min
    user.coins = user.coins + baseCoins + bonus
    user.save

    Ledger.create {
      status: 'completed'
      format: 'loot'
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
          action:       'plus'
          description:  'Daily loot'
          from:         'systems'
          to:           'coins'
          unit:         'coins'
          amount:       baseCoins + bonus
          tax:          0
          ref: {
            format: null
            id: null
          }
        }
      ]
    }

    user.save (err) ->
      data = { user: user, freeCoins: baseCoins + bonus }
      res.json data


handleError = (res, err) ->
  res.status(500).json err
