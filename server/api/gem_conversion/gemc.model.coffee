'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

GemcSchema = new Schema
  diamond:  { rate: Number, fee: Number},
  emerald:  { rate: Number, fee: Number },
  sapphire: { rate: Number, fee: Number },
  ruby:     { rate: Number, fee: Number }

module.exports = mongoose.model 'Gemc', GemcSchema
