'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

BroadcastSchema = new Schema
  postBy: String
  message: String
  publish_time: Date

module.exports = mongoose.model 'Broadcast', BroadcastSchema
