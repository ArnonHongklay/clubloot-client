'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ProgramSchema = new Schema
  name:
    type: String
    index:
      unique: true
  category: String
  image: String
  active: Boolean

module.exports = mongoose.model 'Program', ProgramSchema
