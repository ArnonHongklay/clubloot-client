'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

WinnerLogSchema = new Schema
  user_id: String,
  contest_id:  String,
  template_id:  String,
  score: Number,
  created_at: Date,
  contest_name: String,
  prize:  Number

module.exports = mongoose.model 'WinnerLog', WinnerLogSchema
