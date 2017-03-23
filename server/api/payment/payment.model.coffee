'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

PaymentSchema = new Schema
  name: String
  description: String
  info: String
  active: Boolean

module.exports = mongoose.model 'Payment', PaymentSchema
