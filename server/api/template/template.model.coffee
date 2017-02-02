'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TemplateSchema = new Schema
  # name: String
  number_answers: Number
  number_questions: Number
  program: String
  program_image: String
  # start_time: Date
  # end_time: Date
  # active:
  #   type: Boolean
  #   default: true


  # new template
  name: String
  program_id: String
  questions: [
    {
      is_correct: Number
      answers: [
        { name: String }
      ]
    }
  ]
  contest: [
    name: String
    stage: String
    owner: {
      user_id: String
      user_name: String
      user_fullname: String
      user_email: String
    }
    max_player: Number
    players: [
      {
        user: {
          user_id: String
          user_name: String
          user_fullname: String
          user_email: String
        }
        score: String
        is_win: Boolean
        question_id: String
        answers: [
          {
            answer_id: String
          }
        ]
      }
    ]
    loot: {
      prize: Number
      category: String
    }
    fee: Number
    public: Boolean
  ]
  active: { type: Boolean, default: true }
  start_time: Date
  end_time: Date

module.exports = mongoose.model 'Template', TemplateSchema
