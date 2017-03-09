'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

SigninLogSchema = new Schema
  user_id: String
  created_at: Date

module.exports = mongoose.model 'SigninLog', SigninLogSchema
