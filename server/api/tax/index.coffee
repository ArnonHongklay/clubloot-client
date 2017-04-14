'use strict'

express = require 'express'
controller = require './tax.controller'

router = express.Router()

router.get '/', controller.index
router.post '/by_date', controller.by_date
router.get '/:id', controller.show
router.post '/', controller.create
router.put '/:id', controller.update
router.delete '/:id', controller.destroy

module.exports = router