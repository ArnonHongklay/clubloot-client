'use strict'

_ = require 'lodash'
Template = require '../template/template.model'

exports.index = (req, res) ->
  Template.find (err, things) ->
    return handleError(res, err)  if err
    res.status(200).json things

exports.show = (req, res) ->
  Template.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless thing
    res.json thing

exports.create = (req, res) ->
  Template.create req.body, (err, thing) ->
    return handleError(res, err)  if err
    res.status(201).json thing

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Template.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless thing
    updated = _.merge(thing, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json thing

exports.destroy = (req, res) ->
  Template.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless thing
    thing.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
