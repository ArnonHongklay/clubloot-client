'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

QuestionSchema = new Schema
  title: String
  templates:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Template'
  answers: [
    {
      title: String
      is_correct:
        type: Boolean
        default: false
    }
  ]
  answered: Boolean
module.exports = mongoose.model 'Question', QuestionSchema
