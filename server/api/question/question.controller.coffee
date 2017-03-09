
'use strict'

_ = require 'lodash'
Question = require './question.model'

exports.index = (req, res) ->
  Question.find (err, que) ->
    # console.log que
    return handleError(res, err)  if err
    res.status(200).json que


handleError = (res, err) ->
  res.status(500).json err
