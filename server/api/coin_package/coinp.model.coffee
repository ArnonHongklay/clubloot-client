'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

CoinpSchema = new Schema
  bucket: String,
  coins:  Number
  bonus:  Number,
  price:  Number

module.exports = mongoose.model 'Coinp', CoinpSchema
