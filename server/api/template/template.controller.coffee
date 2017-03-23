
'use strict'

_ = require 'lodash'
Template = require './template.model'
Question = require '../question/question.model'
Program = require '../program/program.model'

# Get list of templates
exports.index = (req, res) ->
  Template.find (err, templates) ->
    return handleError(res, err)  if err
    res.status(200).json templates

exports.create = (req, res) ->
  Template.create req.body, (err, template) ->
    return handleError(res, err)  if err
    res.status(201).json template

exports.show = (req, res) ->
  Template.findById req.params.id, (err, template) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless template
    res.json template

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Template.findById req.params.id, (err, template) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless template
    updated = _.merge(template, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json template

exports.createQuestion = (req, res) ->
  Template.findById req.params.id, (err, template) ->
    template.active = true
    template.save()
    Question.create req.body, (err, questions) ->
      # console.log questions
      for q in questions
        q.templates = template._id
        q.save()
      return handleError(res, err)  if err
      res.status(201).json template

exports.updateQuestion = (req, res) ->
  Question.findById req.params.q, (err, question) ->
    for ans, i in question.answers
      question.answers[i].is_correct = req.body.answers[i].is_correct
    question.answered = true
    question.save()
    exports.register = (socket) ->
      socket.emit 'question:update', doc

    res.status(200).json question

exports.findQuestionByTemplate = (req, res) ->
  query = Question.find({'templates': req.params.id})
  query.exec (err, templates) ->
    return handleError(res, err)  if err
    res.status(200).json templates

exports.findProgramActive = (req, res) ->
  bucket = []
  program = Program.find({}).select('name -_id')
  program.exec (err, programs) ->
    if err
      return next(err)

    for program in programs
      # console.log program
      template = Template.findOne({program: program.name})
      template.exec (err, temp) ->
        if temp
          bucket.push(temp)

    setTimeout (->
      render(res, bucket)
    ), 100

handleError = (res, err) ->
  res.status(500).json err

render = (res, data) ->
  res.status(200).json data
