'use strict'


express = require 'express'
controller = require './prize.controller'

path = require 'path'
config = require '../../config/environment'
multiparty = require 'connect-multiparty'
multipartyMiddleware = multiparty(uploadDir: path.join(config.root, 'client/assets/uploads/prizes/'))

router = express.Router()

router.get    '/',    controller.index
router.get    '/:id', controller.show
router.post   '/', multipartyMiddleware, controller.create
router.put    '/:id/count', controller.putCountPrize
router.put    '/:id', multipartyMiddleware, controller.update
router.patch  '/:id', controller.update
router.delete '/:id', controller.destroy

# router.post '/uploads', multipartyMiddleware, controller.upload

module.exports = router
