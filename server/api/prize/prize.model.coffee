'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

PrizeSchema = new Schema
  name: String
  price: Number
  quantity: Number
  picture: String
  description: String
  active: Boolean
  count: Number

module.exports = mongoose.model 'Prize', PrizeSchema
