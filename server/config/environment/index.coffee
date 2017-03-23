'use strict'

path = require 'path'
_ = require 'lodash'

requiredProcessEnv = (name) ->
  throw new Error('You must set the ' + name + ' environment variable')  unless process.env[name]
  process.env[name]

# All configurations will extend these options
# ============================================
all =
  env: process.env.NODE_ENV

  # Root path of server
  root: path.normalize(__dirname + '/../../..')

  # Server port
  port: process.env.PORT or 9000

  # Should we populate the DB with sample data?
  seedDB: false

  # Secret for session, you will want to change this and make it an environment variable
  secrets:
    session: 'clubloot-secret'

  # List of user roles
  userRoles: [
    'guest'
    'user'
    'admin'
  ]

  # MongoDB connection options
  mongo:
    options:
      db:
        safe: true


  facebook:
    clientID: process.env.FACEBOOK_ID or '1725131707746453'
    clientSecret: process.env.FACEBOOK_SECRET or '2e57915f8ef7d2241267f00ac72b9ac2'
    callbackURL: (process.env.DOMAIN or '') + '/auth/facebook/callback'


console.log all

# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.merge(all, require('./' + process.env.NODE_ENV) or {})
