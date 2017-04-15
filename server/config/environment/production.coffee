'use strict'

# Production specific configuration
# =================================
module.exports =

  # Server IP
  ip: process.env.OPENSHIFT_NODEJS_IP or process.env.IP or undefined

  # Server port
  port: process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 8080

  # MongoDB connection options
  mongo:
    uri:  process.env.MONGOLAB_URI or
          'mongodb://localhost/clubloot'

  DOMAIN: 'http://clubloot.com'
  SESSION_SECRET:   'clubloot-secret'

  FACEBOOK_ID:      'app-id'
  FACEBOOK_SECRET:  'secret'
