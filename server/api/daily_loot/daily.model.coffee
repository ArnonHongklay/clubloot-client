'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

DailySchema = new Schema
  base: Number
  minConsecutive: Number
  maxConsecutive: Number
  moreCoin: Number

module.exports = mongoose.model 'Daily', DailySchema
