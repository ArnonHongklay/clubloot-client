'use strict'

express = require 'express'
controller = require './template.controller'

router = express.Router()

router.get '/', controller.index
router.get '/program', controller.findProgramActive
router.get '/:id', controller.show
router.get '/:id/questions', controller.findQuestionByTemplate

router.post '/', controller.create
router.post '/:id/questions', controller.createQuestion
router.put '/:id/questions/:q', controller.updateQuestion

module.exports = router
