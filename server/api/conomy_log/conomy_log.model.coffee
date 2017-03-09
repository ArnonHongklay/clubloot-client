'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ConomyLogSchema = new Schema
  created_at: Date,
  coins:  Number

module.exports = mongoose.model 'ConomyLog', ConomyLogSchema
