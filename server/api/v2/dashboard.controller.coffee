
'use strict'

_ = require 'lodash'
nodemailer  = require 'nodemailer'
Player      = require '../user/user.model'
Contest     = require '../contest/contest.model'
Conomy      = require '../conomy_log/conomy_log.model'
Program     = require '../program/program.model'
Ledger      = require '../ledger/ledger.model'
SigninLog   = require '../signin_log/signin_log.model'

exports.index = (req, res) ->
  Player.find (err, players) ->
    return handleError(res, err) if err
    res.status(200).json players

exports.player = (req, res) ->
  Player.count (err, players) ->
    return handleError(res, err) if err
    res.status(200).json { player: players }

exports.signincount = (req, res) ->
  SigninLog.count (err, signin_logs) ->
    return handleError(res, err) if err
    res.status(200).json { signincount: signin_logs }

exports.allplayer = (req, res) ->
  Player.find (err, players) ->
    return handleError(res, err)  if err
    res.status(200).json players

exports.allledger_by_date = (req, res) ->
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  Ledger.find({ created_at: {$gte: s, $lt: e} }).where('transaction.format').equals('prize').exec (err, ledgers) ->
    return handleError(res, err)  if err
    res.status(200).json ledgers

exports.allloot_by_date = (req, res) ->
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  Ledger.find({ created_at: {$gte: s, $lt: e} }).exec (err, ledgers) ->
    return handleError(res, err)  if err
    res.status(200).json ledgers

exports.allplayer_by_date = (req, res) ->
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  Player.find { created_at: {$gte: s, $lt: e} }, (err, players) ->
    return handleError(res, err)  if err
    res.status(200).json players

exports.conomy_by_date = (req, res) ->
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  Conomy.find { created_at: {$gte: s, $lt: e} }, (err, conomys) ->
    return handleError(res, err)  if err
    res.status(200).json conomys

exports.tournament = (req, res) ->
  Contest.count (err, tournaments) ->
    return handleError(res, err) if err
    res.status(200).json { tournament: tournaments }

exports.tournament_by_date = (req, res) ->
  start = new Date(req.body.fr)
  s = start.setHours(0,0,0,0)
  end = new Date(req.body.to)
  e = end.setHours(23,59,59,999)

  Contest.find { start_time: {$gte: s, $lt: e} }, (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

exports.rich = (req, res) ->
  Player.find().sort(coins: -1).exec (err, players) ->
    return handleError(res, err) if err
    res.status(200).json players

exports.upcoming_contest = (req, res) ->
  # Contest.find (err, contests) ->
  #   return handleError(res, err) if err
  #   res.status(200).json contests

  bucket = []
  program = Program.find({}).select('name -_id')
  current_time = new Date().getTime()

  temp = 0
  program.exec (err, programs) ->
    return next(err) if err

    for program in programs
      # contest = Contest.findOne({program: program.name})
      total_contest = 0
      total_coin = 0

      contest = Contest.find program: program.name, (err, contests) ->
        if contests
          for contest, i in contests
            #continue if contest.end_time == undefined
            e_time = contest.end_time.getTime()

            if true
              if i == 0
                temp = e_time
              else if temp > e_time
                temp = e_time

              total_contest += 1
              total_coin += contest.loot.prize

              if true
                # console.log total_contest
                # console.log total_coin
                  # console.log contests.length
                c = {
                  contest
                  total: {
                    total_contest: total_contest
                    total_coin: total_coin
                  }
                }

                bucket.push(c)

    setTimeout (->
      # console.log bucket
      render(res, bucket)
    ), 1000

handleError = (res, err) ->
  res.status(500).json err

render = (res, data) ->
  res.status(200).json data
