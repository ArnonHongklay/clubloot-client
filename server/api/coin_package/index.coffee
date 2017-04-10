'use strict'

express = require 'express'
controller = require './coinp.controller'

router = express.Router()

router.get '/', controller.index
router.get '/:id', controller.show
router.post '/', controller.create
router.post '/set', controller.set
router.put '/:id', controller.update
router.delete '/:id', controller.destroy
router.put '/:user/addcoin', controller.addcoin


module.exports = router
