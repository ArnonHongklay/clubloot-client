'use strict'

express = require 'express'
controller = require './program.controller'

path = require 'path'
config = require '../../config/environment'
multiparty = require 'connect-multiparty'
multipartyMiddleware = multiparty(uploadDir: path.join(config.root, 'client/assets/uploads/program/'))

router = express.Router()

router.get '/', controller.index
router.get '/:id', controller.show
router.post '/', multipartyMiddleware, controller.create
router.put '/:id', controller.update

module.exports = router
