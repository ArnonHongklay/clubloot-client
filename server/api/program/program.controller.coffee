
'use strict'

_ = require 'lodash'
Program = require './program.model'

fs = require 'fs'
im = require 'imagemagick'
config = require '../../config/environment'

# Get list of programs
exports.index = (req, res) ->
  Program.find (err, programs) ->
    return handleError(res, err)  if err
    res.status(200).json programs

# Get a single program
exports.show = (req, res) ->
  Program.findById req.params.id, (err, program) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless program
    res.json program

# Creates a new program in the DB.
exports.create = (req, res) ->
  file = req.files.file
  body = req.body
  body.contest.image = file.path.replace(config.root + '/client', '')

  Program.create body.contest, (err, program) ->
    return handleError(res, err)  if err
    res.status(201).json program

# Updates an existing program in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Program.findById req.params.id, (err, program) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless program
    updated = _.merge(program, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json program

handleError = (res, err) ->
  res.status(500).json err
