'use strict'

express = require 'express'
controller = require './signin_log.controller'

router = express.Router()

router.get '/', controller.index
router.post '/by_date', controller.by_date
router.get '/today', controller.today
router.get '/:id', controller.show
router.post '/', controller.create




module.exports = router
