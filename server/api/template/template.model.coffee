'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TemplateSchema = new Schema
  name: String
  questions: [
    {
      title: String
      answers: [
        {
          title: String
          is_correct: Boolean
        }
      ]
    }
  ]
  number_answers: Number
  number_questions: Number
  program: String
  start_time: Date
  end_time: Date
  active: Boolean

module.exports = mongoose.model 'Template', TemplateSchema
