'use strict'

express = require 'express'
controller = require './user.controller'
config = require '../../config/environment'
auth = require '../../auth/auth.service'

router = express.Router()

router.get '/', controller.index
# router.get '/', auth.hasRole('admin'), controller.index
router.get '/all', auth.isAuthenticated(), controller.index
router.get '/all_user', auth.isAuthenticated(), controller.allUser
router.get '/all_admin', auth.isAuthenticated(), controller.adminIndex
router.get '/all_master', auth.isAuthenticated(), controller.masterIndex
router.post '/:id/edit_role', auth.isAuthenticated(), controller.editRole
router.delete '/:id', auth.hasRole('admin'), controller.destroy
router.get '/me', auth.isAuthenticated(), controller.me
router.put '/:id/deletemessage', auth.isAuthenticated(), controller.deleteMessage
router.put '/:id/password', auth.isAuthenticated(), controller.changePassword
router.get '/:id', auth.isAuthenticated(), controller.show
router.post '/:id/update_gem',      auth.isAuthenticated(), controller.updateGem

router.get '/:id/contests/:status', auth.isAuthenticated(), controller.showContests
router.get '/:id/transactions',     auth.isAuthenticated(), controller.showTransactions
router.get '/:id/prizes',           auth.isAuthenticated(), controller.showPrizes
router.get '/:id/notes',            auth.isAuthenticated(), controller.notes
router.get '/:id/accounting',       auth.isAuthenticated(), controller.accounting


router.post '/', controller.create
router.put '/:id/profile', auth.isAuthenticated(), controller.updateProfile
router.put '/:id', auth.isAuthenticated(), controller.update

module.exports = router
