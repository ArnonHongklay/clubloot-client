###*
Populate DB with sample data on server start
to disable, edit config/environment/index.js, and set `seedDB: false`
###

'use strict'

Thing   = require '../api/thing/thing.model'
User    = require '../api/user/user.model'
Program = require '../api/program/program.model'
Contest = require '../api/contest/contest.model'

userId = ''

User.remove().exec()
Contest.remove().exec()
Program.remove().exec()

User.create
  provider: 'local'
  name: 'non'
  email: 'non@non.com'
  password: 'non'
,
  provider: 'local'
  name: 'steven'
  email: 'steven@steven.com'
  password: 'steven'
,
  provider: 'local'
  name: 'pump'
  email: 'pump@pump.com'
  password: 'pump'
,
  provider: 'local'
  name: 'angerson'
  email: 'angerson@angerson.com'
  password: 'angerson'
,
  provider: 'local'
  name: 'godfather'
  email: 'godfather@godfather.com'
  password: 'godfather'
,
  provider: 'local'
  name: 'ronaldo'
  email: 'ronaldo@ronaldo.com'
  password: 'ronaldo'
,
  provider: 'local'
  name: 'panda'
  email: 'panda@panda.com'
  password: 'panda'
,
  provider: 'local'
  name: 'obama'
  email: 'obama@obama.com'
  password: 'obama'
,
  provider: 'local'
  name: 'assasin'
  email: 'assasin@assasin.com'
  password: 'assasin'
,
  provider: 'local'
  name: 'marse'
  email: 'marse@marse.com'
  password: 'marse'
,
  provider: 'local'
  name: 'machete'
  email: 'machete@gmail.com'
  password: 'machete'
  coins: 300000
  diamonds: 20
  rubies: 50
  emerald: 50
  saphires: 30
,
  provider: 'local'
  name: 'momotaro'
  email: 'momotaro@momotaro.com'
  password: 'momotaro'

userId = ''
User.find { 'name': 'machete' }, (err, user) ->
  # console.log "==========================================="
  user.save
  userId = user._id
  return

allUser = []
User.find {}, (err, users) ->
  allUser = users

Program.find({}).remove ->
  Program.create
    name: 'Big-Brother'
    category: '1'
    image: 'https://upload.wikimedia.org/wikipedia/sl/8/89/Big_Brother-logo.png'
    active: true
  , (err, program) ->
    # console.log "program created"
    Contest.create
      name: 'Big-Brother-01'
      program: program._id
      max_player: 20
      owner: userId
      participant: allUser
      prize: 200
      loot: { prize: 6, category: 'ruby' }
      fee: 1000
      public: true
    , (err, contest) ->
      # console.log "contest created"

  Program.create
    name: 'The Voice'
    category: '1'
    image: 'https://upload.wikimedia.org/wikipedia/en/4/44/The_Voice_NBC_logo_blackwhite.png'
    active: true
  , (err, program) ->
    # console.log program
