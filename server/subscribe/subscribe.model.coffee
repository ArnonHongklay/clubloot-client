'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

SubscribeSchema = new Schema
  name: String
  email: String

module.exports = mongoose.model 'Subscribe', SubscribeSchema
