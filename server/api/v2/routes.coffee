'use strict'

express = require 'express'

dashboardController = require './dashboard.controller'

programController   = require './program.controller'
templateController  = require './template.controller'
questionController  = require './question.controller'
answerController    = require './answer.controller'

# contestController   = require './contest.controller'

router = express.Router()

router.get  '/dashboard',                     dashboardController.index
router.get  '/dashboard/allplayer',           dashboardController.allplayer
router.get  '/dashboard/player',              dashboardController.player
router.get  '/dashboard/signincount',         dashboardController.signincount
router.get  '/dashboard/tournament',          dashboardController.tournament
router.get  '/dashboard/contests',            dashboardController.upcoming_contest
router.get  '/dashboard/rich',                dashboardController.rich
router.post '/dashboard/allplayer_by_date',   dashboardController.allplayer_by_date
router.post '/dashboard/allledger_by_date',   dashboardController.allledger_by_date
router.post '/dashboard/allloot_by_date',     dashboardController.allloot_by_date
router.post '/dashboard/conomy_by_date',      dashboardController.conomy_by_date
router.post '/dashboard/tournament_by_date',  dashboardController.tournament_by_date


router.get    '/program',       programController.index
router.get    '/program/:id',   programController.show
router.post   '/program',       programController.create
router.put    '/program/:id',   programController.update
router.patch  '/program/:id',   programController.update
router.delete '/program/:id',   programController.destroy


router.get    '/template',       templateController.index
router.get    '/template/:id',   templateController.show
router.post   '/template',       templateController.create
router.put    '/template/:id',   templateController.update
router.patch  '/template/:id',   templateController.update
router.delete '/template/:id',   templateController.destroy

router.get    '/template/:id/question',             questionController.index
router.get    '/template/:id/question/:question',   questionController.show
router.post   '/template/:id/question',             questionController.create
router.put    '/template/:id/question/:question',   questionController.update
router.patch  '/template/:id/question/:question',   questionController.update
router.delete '/template/:id/question/:question',   questionController.destroy

router.get    '/template/:id/question/:question/answer',
              answerController.index
router.get    '/template/:id/question/:question/answer/:answer',
              answerController.show
router.post   '/template/:id/question/:question/answer',
              answerController.create
router.put    '/template/:id/question/:question/answer/:answer',
              answerController.update
router.patch  '/template/:id/question/:question/answer/:answer',
              answerController.update
router.delete '/template/:id/question/:question/answer/:answer',
              answerController.destroy


# router.get    '/template/:id/contest',       contestController.index
# router.get    '/template/:id/contest/:id',   contestController.show
# router.post   '/template/:id/contest',       contestController.create
# router.put    '/template/:id/contest/:id',   contestController.update
# router.patch  '/template/:id/contest/:id',   contestController.update
# router.delete '/template/:id/contest/:id',   contestController.destroy

# router.get    '/',      controller.index
# router.get    '/:id',   controller.show
# router.post   '/',      controller.create
# router.put    '/:id',   controller.update
# router.patch  '/:id',   controller.update
# router.delete '/:id',   controller.destroy



module.exports = router
