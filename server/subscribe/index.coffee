'use strict'

express = require 'express'
controller = require './subscribe.controller'

router = express.Router()

router.get '/',  controller.index
router.post '/', controller.create

module.exports = router
