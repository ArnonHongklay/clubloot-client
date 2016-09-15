
'use strict'

_ = require 'lodash'
Contest = require './contest.model'
Program = require '../program/program.model'

# Get list of contests
exports.index = (req, res) ->
  Contest.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

# Get a single contest
exports.show = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    res.json contest

# Creates a new contest in the DB.
exports.create = (req, res) ->
  Contest.create req.body, (err, contest) ->
    return handleError(res, err)  if err
    res.status(201).json contest

exports.findProgramActive = (req, res) ->
  bucket = []
  program = Program.find({}).select('name -_id')
  program.exec (err, programs) ->
    if err
      return next(err)

    for program in programs
      console.log program
      contest = Contest.findOne({program: program.name})
      contest.exec (err, temp) ->
        console.log temp
        if temp
          bucket.push(temp)

    setTimeout (->
      console.log bucket
      render(res, bucket)
    ), 100

handleError = (res, err) ->
  res.status(500).json err

render = (res, data) ->
  res.status(200).json data
