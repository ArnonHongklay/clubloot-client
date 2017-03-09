'use strict'

express = require 'express'
controller = require './contest.controller'

router = express.Router()

router.get '/', 								controller.index
router.get '/program', 					controller.findProgramActive
router.get '/program/:id', 			controller.show
router.get '/program/:name/all', controller.findAllProgram
router.get '/template/:id/score', controller.updateScore
router.get '/template/:id', controller.findByTemplates
router.get '/:id', 							controller.show
router.post '/:id/destroy',     controller.destroy

router.post '/', controller.create
router.put  '/:id', controller.updateQuestion
router.put '/:id/join', controller.joinContest
router.put '/:id/join_created', controller.joinContestCreated
router.put '/:id/player', controller.joinPlayer


module.exports = router
