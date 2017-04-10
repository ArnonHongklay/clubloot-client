'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TaxSchema = new Schema
  tax_type: String
  coin: Number
  user_id: String
  created_at: Date
  contest_id: String

module.exports = mongoose.model 'Tax', TaxSchema
