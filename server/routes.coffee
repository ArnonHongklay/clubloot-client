###*
Main application routes
###

'use strict'

errors = require './components/errors'
path = require 'path'

module.exports = (app) ->

  # Insert routes below
  app.use '/api/things',          require './api/thing'
  app.use '/api/ledgers',         require './api/ledger'
  app.use '/api/program',         require './api/program'
  app.use '/api/templates',       require './api/template'
  app.use '/api/questions',       require './api/question'
  app.use '/api/contest',         require './api/contest'
  app.use '/api/tax',             require './api/tax'
  app.use '/api/users',           require './api/user'
  app.use '/api/gem_conversion',  require './api/gem_conversion'
  app.use '/api/coin_package',    require './api/coin_package'
  app.use '/api/daily_loot',      require './api/daily_loot'
  app.use '/api/signin_log',      require './api/signin_log'
  app.use '/api/prize',           require './api/prize'
  app.use '/api/winner_log',      require './api/winner_log'
  app.use '/api/conomy_log',      require './api/conomy_log'
  app.use '/api/broadcast',       require './api/broadcast'
  app.use '/auth',                require './auth'

  app.use '/subscribe',           require './subscribe'
  app.use '/api/v2',              require './api/v2/routes'

  # All undefined asset or api routes should return a 404
  app.route('/:url(api|auth|components|app|bower_components|assets)/*').get errors[404]

  # All other routes should redirect to the index.html
  app.route('/*').get (req, res) ->
    res.sendFile path.resolve(app.get('appPath') + '/index.html')
