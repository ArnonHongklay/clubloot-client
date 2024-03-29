'use strict'

express = require 'express'
passport = require 'passport'
config = require '../config/environment'
User = require '../api/user/user.model'

# Passport Configuration
require('./local/passport').setup User, config
require('./facebook/passport').setup User, config

router = express.Router()

router.use '/local', require './local'
router.use '/facebook', require './facebook'

module.exports = router