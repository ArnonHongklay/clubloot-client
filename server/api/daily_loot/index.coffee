'use strict'

express = require 'express'
controller = require './daily.controller'

router = express.Router()

router.get '/', controller.index
router.put '/:id', controller.update
router.put '/:id/getfreeloot', controller.getFreeLoot

module.exports = router
