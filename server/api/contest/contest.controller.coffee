
'use strict'

_ = require 'lodash'
Contest  = require './contest.model'
Program  = require '../program/program.model'
Template = require '../template/template.model'
Question = require '../question/question.model'
WinnerLog = require '../winner_log/winner_log.model'
Tax       = require '../tax/tax.model'
User     = require '../user/user.model'
Ledger = require '../ledger/ledger.model'

schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()


# 1 (110c)
# 2 (220c)
# 3 (330c)
# 4 (440c)
# SAPPHIRE
# 1 (550c)
# 2 (1100c)
# 3 (1650c)
# 4 (2200c)
# EMERALD
# 1 (2750c)
# 2 (5500c)
# 3 (8250c)
# 4 (11000c)
# DIAMOND
# 1 (13750c)

prizeList = [110, 220, 330, 440, 550, 1100, 1650, 2200, 2750, 5500, 8250, 11000]

#50C 34C 25C 20C 17C 15C 13C 12C 10C

refundList = [
  [
    [{type: 'coin', value: 50}],
    [{type: 'coin', value: 34}],
    [{type: 'coin', value: 25}],
    [{type: 'coin', value: 20}],
    [{type: 'coin', value: 17}],
    [{type: 'coin', value: 15}],
    [{type: 'coin', value: 13}],
    [{type: 'coin', value: 12}],
    [{type: 'coin', value: 10}]
  ],
  #1R 67C 50C 40C 34C 29C 25C 23C 20C
  [
    [{type: 'ruby', value: 1}],
    [{type: 'coin', value: 67}],
    [{type: 'coin', value: 50}],
    [{type: 'coin', value: 40}],
    [{type: 'coin', value: 34}],
    [{type: 'coin', value: 29}],
    [{type: 'coin', value: 25}],
    [{type: 'coin', value: 23}],
    [{type: 'coin', value: 20}]
  ],
  #1R 50C 1R  75C 60C 50C 43C 38C 34C 30C
  [
    [{type: 'ruby', value: 1}, {type: 'coin', value: 50}],
    [{type: 'ruby', value: 1}],
    [{type: 'coin', value: 75}],
    [{type: 'coin', value: 60}],
    [{type: 'coin', value: 50}],
    [{type: 'coin', value: 43}],
    [{type: 'coin', value: 38}],
    [{type: 'coin', value: 34}],
    [{type: 'coin', value: 30}]
  ],
  #2R 1R 34C  1R  80C 67C 58C 50C 45C 40C
  [
    [{type: 'ruby', value: 2}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 34}],
    [{type: 'ruby', value: 1}],
    [{type: 'coin', value: 80}],
    [{type: 'coin', value: 67}],
    [{type: 'coin', value: 58}],
    [{type: 'coin', value: 50}],
    [{type: 'coin', value: 45}],
    [{type: 'coin', value: 40}]
  ],
  #2R 50C 1R 67C  1R 25C  1R  84C 72C 63C 56C 50C
  [
    [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 67}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 25}],
    [{type: 'ruby', value: 1}],
    [{type: 'coin', value: 84}],
    [{type: 'coin', value: 72}],
    [{type: 'coin', value: 63}],
    [{type: 'coin', value: 56}],
    [{type: 'coin', value: 50}]
  ],
  #1S 3R 34C  2R 50C  2R  1R 67C  1R 43C  1R 25C  1R 12C  1R
  [
    [{type: 'sapphire', value: 1}],
    [{type: 'ruby', value: 3}, {type: 'coin', value: 34}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'ruby', value: 2}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 67}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 43}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 25}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 12}],
    [{type: 'ruby', value: 1}]
  ],
  #1S 2R 50C  1S  3R 75C  3R  2R 50C  2R 15C  1R 88C  1R 67C  1R 50C
  [
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'sapphire', value: 1}],
    [{type: 'ruby', value: 3}, {type: 'coin', value: 75}],
    [{type: 'ruby', value: 3}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 15}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 88}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 67}],
    [{type: 'ruby', value: 1}, {type: 'coin', value: 50}]
  ],
  #2S 1S 1R 67C 1S  4R  3R 34C  2R 86C  2R 50C  2R 23C  2R
  [
    [{type: 'sapphire', value: 2}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
    [{type: 'sapphire', value: 1}],
    [{type: 'ruby', value: 4}],
    [{type: 'ruby', value: 3}, {type: 'coin', value: 34}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 86}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 23}],
    [{type: 'ruby', value: 2}]
  ],
  #2S 2R 50C  1S 3R 34C 1S 1R 25C 1S  4R 17C  3R 58C  3R 13C  2R 78C  2R 50C
  [
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 1}, {type: 'coin', value: 25}],
    [{type: 'sapphire', value: 1}],
    [{type: 'ruby', value: 4}, {type: 'coin', value: 17}],
    [{type: 'ruby', value: 3}, {type: 'coin', value: 58}],
    [{type: 'ruby', value: 3}, {type: 'coin', value: 13}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 78}],
    [{type: 'ruby', value: 2}, {type: 'coin', value: 50}]
  ],
  # 1E  3S 1R 67C 2S 2R 50C 2S  1S 3R 34C 1S 2R 15C 1S 25C  1S 56C  1S
  [
    [{type: 'emerald', value: 1}],
    [{type: 'sapphire', value: 3}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'sapphire', value: 2}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 2}, {type: 'coin', value: 15}],
    [{type: 'sapphire', value: 1}, {type: 'coin', value: 56}],
    [{type: 'sapphire', value: 1}, {type: 'coin', value: 25}],
    [{type: 'sapphire', value: 1}]
  ],
  # 1E 2S 2R 50C  1E  3S 3R 75C 3S  2S 2R 50C 2S 72C  1S 4R 38C 1S 3R 34C 1S 2R 50C
  [
    [{type: 'emerald', value: 1}, {type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'emerald', value: 1}],
    [{type: 'sapphire', value: 3}, {type: 'ruby', value: 3}, {type: 'coin', value: 75}],
    [{type: 'sapphire', value: 3}],
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'sapphire', value: 2}, {type: 'coin', value: 72}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 4}, {type: 'coin', value: 38}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
    [{type: 'sapphire', value: 1}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}]
  ],
  #2E 1E 1S 3R 34C  1E  4S  3S 1R 67C 2S 4R 29C 2S 2R 50C 2S 1R 12C 2S
  [
    [{type: 'emerald', value: 2}],
    [{type: 'emerald', value: 1}, {type: 'sapphire', value: 1}, {type: 'ruby', value: 3}, {type: 'coin', value: 34}],
    [{type: 'emerald', value: 1}],
    [{type: 'sapphire', value: 4}],
    [{type: 'sapphire', value: 3}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 4}, {type: 'coin', value: 29}],
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 1}, {type: 'coin', value: 12}],
    [{type: 'sapphire', value: 2}]
  ],
  #2E 2S 2R 50C 1E 3S 1R 67C  1E 1S 1R 25C  1E  4S 84C  3S 2R 86C 3S 63C  2S 3R 89C 2S 2R 50C
  [
    [{type: 'emerald', value: 2}, {type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}],
    [{type: 'emerald', value: 1}, {type: 'sapphire', value: 3}, {type: 'ruby', value: 1}, {type: 'coin', value: 67}],
    [{type: 'emerald', value: 1}, {type: 'sapphire', value: 1}, {type: 'ruby', value: 1}, {type: 'coin', value: 25}],
    [{type: 'emerald', value: 1}],
    [{type: 'sapphire', value: 4}, {type: 'coin', value: 84}],
    [{type: 'sapphire', value: 3}, {type: 'ruby', value: 2}, {type: 'coin', value: 86}],
    [{type: 'sapphire', value: 3}, {type: 'coin', value: 63}],
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 3}, {type: 'coin', value: 89}],
    [{type: 'sapphire', value: 2}, {type: 'ruby', value: 2}, {type: 'coin', value: 50}]
  ]

]

gemMatrix = {
  list:[
    { player: 2  , fee: [55, 110, 165, 220, 275, 550, 825, 1100, 1375, 2750, 4125, 5500, 6875] },
    { player: 3  , fee: [37, 74, 110, 147, 184, 367, 550, 734, 917, 1834, 2750, 3667, 4584] },
    { player: 4  , fee: [28, 55, 83, 110, 138, 275, 413, 550, 688, 1375, 2063, 2750, 3438] },
    { player: 5  , fee: [22, 44, 66, 88, 110, 220, 330, 440, 550, 1100, 1650, 2200, 2750] },
    { player: 6  , fee: [19, 37, 55, 74, 92, 184, 275, 367, 459, 917, 1375, 1834, 2292] },
    { player: 7  , fee: [16, 32, 48, 63, 79, 158, 236, 315, 393, 786, 1179, 1572, 1965] },
    { player: 8  , fee: [14, 28, 42, 55, 69, 138, 207, 275, 344, 688, 1032, 1375, 1719] },
    { player: 9  , fee: [13, 25, 37, 49, 62, 123, 184, 245, 306, 612, 917, 1223, 1528] },
    { player: 10 , fee: [11, 22, 33, 44, 55, 110, 165, 220, 275, 550, 825, 1100, 1375] },
    { player: 11 , fee: [10, 20, 30, 40, 50, 100, 150, 200, 250, 500, 750, 1000, 1250] },
    { player: 12 , fee: [10, 19, 28, 37, 46, 92, 138, 184, 230, 459, 688, 917, 1146] },
    { player: 13 , fee: [9, 17, 26, 34, 43, 85, 127, 170, 212, 424, 635, 847, 1058] },
    { player: 14 , fee: [8, 16, 24, 32, 40, 79, 118, 158, 197, 393, 590, 786, 983] },
    { player: 15 , fee: [8, 15, 22, 30, 37, 74, 110, 147, 184, 367, 550, 734, 917] },
    { player: 16 , fee: [7, 14, 21, 28, 35, 69, 104, 138, 172, 344, 516, 688, 860] },
    { player: 17 , fee: [7, 13, 20, 26, 33, 65, 98, 130, 162, 324, 486, 648, 809] },
    { player: 18 , fee: [7, 13, 19, 25, 31, 62, 92, 123, 153, 306, 459, 612, 764] },
    { player: 19 , fee: [6, 12, 18, 24, 29, 58, 87, 116, 145, 290, 435, 597, 724] },
    { player: 20 , fee: [6, 11, 17, 22, 28, 55, 83, 110, 138, 275, 413, 550, 688] }
  ]
  gem: [
    { type: 'RUBY', count: 1 },
    { type: 'RUBY', count: 2 },
    { type: 'RUBY', count: 3 },
    { type: 'RUBY', count: 4 },

    { type: 'SAPPHIRE', count: 1 },
    { type: 'SAPPHIRE', count: 2 },
    { type: 'SAPPHIRE', count: 3 },
    { type: 'SAPPHIRE', count: 4 },

    { type: 'EMERALD', count: 1 },
    { type: 'EMERALD', count: 2 },
    { type: 'EMERALD', count: 3 },
    { type: 'EMERALD', count: 4 },

    { type: 'DIAMOND', count: 1 }
  ]

}

getFefund = (user_id, refund) ->
  # console.log "&&&&&&&&&&&&&&&&&&&&&&&&&&&"
  # console.log refund
  # console.log user_id
  User.findById user_id, (err, user) ->
    for i in refund
      if i.type == 'coin'
        user.coins = user.coins + i.value
      if i.type == 'ruby'
        user.rubies = user.rubies + i.value
      if i.type == 'sapphire'
        user.sapphires = user.sapphires + i.value
      if i.type == 'emerald'
        user.emeralds = user.emeralds + i.value
      if i.type == 'diamond'
        user.diamonds = user.diamonds + i.value
    # console.log "ddddd"
    # console.log refund
    user.save()




getQuestions = (tem_id) ->
  query = Question.find({'templates': tem_id})
  query.exec (err, templates) ->
    return templates

checkScore = (player, questions) ->
  score = 0
  num = 0
  for uAnswer in player.answers
    if questions[num].answers[uAnswer].is_correct
      score = score + 1
    num = num + 1
  player.score = score
  score

myContest =
  start: (contest) ->
    s_time = ''
    e_time = ''
    Template.findById contest.template_id, (err, template) ->
      s_time = template.start_time
      e_time = template.end_time
      program_image = template.program_image

      Contest.findById contest._id, (err, contest) ->
        current_time = new Date().getTime()
        contest.start_time = s_time.getTime()
        contest.end_time   = e_time.getTime()
        contest.program_image = template.program_image

        if current_time > s_time.getTime()
          contest.status = "upcoming"
          contest.stage = "upcoming"
          contest.save()
            # console.log "contest Start #{contest.status} #{contest._id}"
          return

      n_date = schedule.scheduleJob(e_time, ->
        Contest.findById contest._id, (err, contest) ->
          contest.start_time = s_time.getTime()
          contest.end_time   = e_time.getTime()
          contest.program_image = template.program_image

          if contest.participant.length < contest.max_player
            for user in contest.participant
              User.findById user._id, (err, user) ->
                user.coins = user.coins + contest.fee

                Ledger.create {
                  status: 'completed'
                  format: 'contest'
                  user: {
                    id:       user._id,
                    username: user.username
                    name:     "#{user.first_name} #{user.last_name}",
                    email:    user.email
                  }
                  balance: {
                    coins:      user.coins
                    diamonds:   user.diamonds
                    emeralds:   user.emeralds
                    sapphires:  user.sapphires
                    rubies:     user.rubies
                  }
                  transaction: [
                    {
                      action:       'plus'
                      description:  'Refund'
                      from:         'system'
                      to:           'refund'
                      unit:         'coins'
                      amount:       contest.fee
                      tax:          0
                      ref: {
                        format: null
                        id: null
                      }
                    }
                  ]
                }

                user.save()
            contest.status = "cancel"
            contest.stage = "cancel"
            contest.save()
          else
            contest.status = "live"
            contest.stage = "live"
            contest.save()
        return
      )

      s_date = schedule.scheduleJob(s_time, ->
        Contest.findById contest._id, (err, contest) ->
          contest.program_image = template.program_image
          contest.start_time = s_time.getTime()
          contest.end_time   = e_time.getTime()
          contest.status = "upcoming"
          contest.stage = "upcoming"
          contest.save()
        return
      )

# Get list of contests
exports.index = (req, res) ->
  Contest.find (err, contests) ->
    return handleError(res, err)  if err
    res.status(200).json contests

# Get a single contest
exports.show = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    res.json contest

# Creates a new contest in the DB.
exports.create = (req, res) ->
  Contest.create req.body, (err, contest) ->
    return handleError(res, err)  if err
      # console.log contest
    myContest.start(contest)

      # console.log req.body
    User.findById req.body.user_id, (err, user) ->
      user.coins = user.coins - contest.fee
      # user.joinedContest = [ contest ]
      tax = (contest.fee * 10) / 100

      Tax.create {
        tax_type: 'contestFee'
        contest_id: contest._id,
        coin: tax
        user_id: user._id
        created_at: new Date()
      }, (err, tax) ->

      Ledger.create {
        status: 'completed'
        format: 'contest'
        user: {
          id:       user._id,
          username: user.username
          name:     "#{user.first_name} #{user.last_name}",
          email:    user.email
        }
        balance: {
          coins:      user.coins
          diamonds:   user.diamonds
          emeralds:   user.emeralds
          sapphires:  user.sapphires
          rubies:     user.rubies
        }
        transaction: [
          {
            action:       'minus'
            description:  'Create contest'
            from:         'coins'
            to:           'contest creating'
            unit:         'coins'
            amount:       contest.fee
            tax:          (contest.fee * 10) / 100
            ref: {
              format: null
              id: null
            }
          }
        ]
      }

      user.save()

    res.status(201).json contest

exports.joinContest = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    if contest.player.length == contest.max_player
      return res.status(500).send({ message: "Contest is full" })
    # console.log "joinContest==========================="
    User.findById req.body._id, (err, user) ->
      # console.log "user==========================="
      user.coins = user.coins - contest.fee
      # user.joinedContest = [ contest ]
      user.save()
      tax = (contest.fee * 10) / 100

      Tax.create {
        tax_type: 'contestFee'
        contest_id: contest._id,
        coin: tax
        user_id: user._id
        created_at: new Date()
      }, (err, tax) ->
        console.log tax

      Ledger.create {
        status: 'completed'
        format: 'contest'
        user: {
          id:       user._id,
          username: user.username
          name:     "#{user.first_name} #{user.last_name}",
          email:    user.email
        }
        balance: {
          coins:      user.coins
          diamonds:   user.diamonds
          emeralds:   user.emeralds
          sapphires:  user.sapphires
          rubies:     user.rubies
        }
        transaction: [
          {
            action:       'minus'
            description:  'Joined contest'
            from:         'coins'
            to:           'contest joined'
            unit:         'coins'
            amount:       contest.fee
            tax:          (contest.fee * 10) / 100
            ref: {
              format: null
              id: null
            }
          }
        ]
      }

      contest.participant.push(req.body)
      contest.player.push({ uid: req.body._id, name: user.username, score: 10 })

      contest.save (err) ->
        return handleError(res, err)  if err
        res.status(200).json contest

exports.joinContestCreated = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    # User.findById req.body._id, (err, user) ->
    #   # user.joinedContest = [ contest ]
    #   user.save()
      #
      # contest.save (err) ->
      #   return handleError(res, err)  if err
      #   res.status(200).json contest

exports.updateQuestion = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    updated = _.merge(contest, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

exports.joinPlayer = (req, res) ->
  player = req.body.player
  Contest.findById req.params.id, (err, contest) ->
    pre = contest
    for p in pre.player
      if p.uid == player.uid
        p.answers = player.answers
    contest = pre
    contest.save()
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest

    contest.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json contest

exports.findAllProgram = (req, res) ->
  Contest.find (err, contests) ->
    bucket = []
    for contest in contests
      if contest.program == req.params.name
        bucket.push(contest)

    setTimeout (->
      render(res, bucket)
    ), 100

exports.findByTemplates = (req, res) ->

  Template.findById req.params.id, (err, template) ->
    template.active = false
    template.save()

  Contest.update { template_id: req.params.id }, { status: 'close', stage: 'close' }, { multi: true }, (err, num) ->
      # console.log num

    # console.log "xxx 1"
  Contest.find { template_id: req.params.id }, (err, contests) ->
      # console.log "xxx 2"
    for contest in contests
        # console.log "xxx 3"
      Contest.findById contest._id, (err, c) ->
        playerSet = {}
        for m, i in gemMatrix.list
          if m.player == c.max_player
            playerSet = m
            break
        gemIndex = playerSet.fee.indexOf(c.fee)
        gemPrize = gemMatrix.gem[gemIndex]
          # console.log gemPrize

        max_score = 0
        winner = []
        # q = Question.find({})
        # qq = q.where('templates', req.params.id )
        query = Question.find({'templates': req.params.id})

        query.exec (err, templates) ->

          for p in c.player
            score = checkScore(p, templates)
            p.score = score
            if score == max_score
              winner.push {uid: p.uid}
            if score > max_score
              winner = []
              winner.push {uid: p.uid}
              max_score = score

            c.save()

            User.findById p.uid, (err, user) ->
              if user.joinedContest.length == 0
                user.joinedContest.push contest
                user.save()
              else
                jcs = []
                for jc in user.joinedContest
                  jcs.push(String(jc._id))

                console.log jcs
                console.log contest._id
                if jcs.indexOf(String(contest._id)) < 0
                  user.joinedContest.push contest
                  user.save()

          if winner.length == c.max_player
            for py, k in contest.player
              contest.player[k].isWin = false
              contest.player[k].winPrize = { value: c.fee, type: "coin" }
            contest.save()
            for s_winner in winner
              User.findById s_winner.uid, (err, user) ->
                user.coins = user.coins + c.fee
                s_contest = contest
                s_contest.loot.prize = c.fee
                user.wonContest.push s_contest


                Ledger.create {
                  status: 'completed'
                  format: 'contest'
                  user: {
                    id:       user._id,
                    username: user.username
                    name:     "#{user.first_name} #{user.last_name}",
                    email:    user.email
                  }
                  balance: {
                    coins:      user.coins
                    diamonds:   user.diamonds
                    emeralds:   user.emeralds
                    sapphires:  user.sapphires
                    rubies:     user.rubies
                  }
                  transaction: [
                    {
                      action:       'plus'
                      description:  'Refund'
                      from:         'system'
                      to:           'refund'
                      unit:         'coins'
                      amount:       s_contest.loot.prize
                      tax:          0
                      ref: {
                        format: null
                        id: null
                      }
                    }
                  ]
                }

                user.save()
          else if winner.length > 1
            refund_index = c.loot.prize
            matchList = gemMatrix.list[0].fee
            # console.log matchList
            refund = refundList[prizeList.indexOf(c.loot.prize)][winner.length-2]

            for w in winner
              getFefund(w.uid, refund)
              for py, k in contest.player
                if py.uid == w.uid
                  contest.player[k].isWin = true
                  contest.player[k].winPrize = refund
              contest.save()
              User.findById w.uid, (err, user) ->
                # console.log "create won"
                if user.wonContest.length == 0
                  user.wonContest.push contest
                  user.save()
                else
                  # console.log "create won 2"
                  for won, i in user.wonContest
                    if i == user.wonContest.length - 1 && won._id != contest._id
                      user.wonContest.push contest
                      user.save()

              WinnerLog.create {
                user_id: w.uid,
                contest_id: c._id,
                template_id: req.params.id,
                contest_name: c.name,
                score: w.score,
                prize:  c.loot.prize
                created_at: new Date()
                }, (err, winnerlog) ->
                    # console.log "callback"
                    # log ledger
                  user = w
                  for re in refund

                    Ledger.create {
                      status: 'completed'
                      format: 'won'
                      user: {
                        id:       user._id,
                        username: user.username
                        name:     "#{user.first_name} #{user.last_name}",
                        email:    user.email
                      }
                      balance: {
                        coins:      user.coins
                        diamonds:   user.diamonds
                        emeralds:   user.emeralds
                        sapphires:  user.sapphires
                        rubies:     user.rubies
                      }
                      transaction: [
                        {
                          action:       'plus'
                          description:  'Winner contest'
                          from:         'contest'
                          to:           'winner'
                          unit:         re.type
                          amount:       re.value
                          tax:          0
                          ref: {
                            format: null
                            id: null
                          }
                        }
                      ]
                    }


          else if winner.length == 1
            console.log "won11111"
            User.findById winner[0].uid, (err, user) ->
              console.log user
              for py, k in contest.player
                contest.player[k].isWin = false
                contest.player[k].winPrize = []
                # console.log "000000=0=0=0=00=0=0="
                # console.log py.uid
                # console.log winner[0].uid
                # console.log "00000000000000000000"
                if py.uid == winner[0].uid
                  # console.log "wow winner"
                  contest.player[k].isWin = true
                  contest.player[k].winPrize = [{type: gemPrize.type.toLowerCase(), value: gemPrize.count }]
                  contest.save()
              if gemPrize.type == "RUBY"
                user.rubies = user.rubies + gemPrize.count
              else if  gemPrize.type == "SAPPHIRE"
                user.sapphires = user.sapphires + gemPrize.count
              else if  gemPrize.type == "EMERALD"
                user.emeralds = user.emeralds + gemPrize.count
              else if  gemPrize.type == "DIAMOND"
                user.diamonds = user.diamonds + gemPrize.count

              if user.wonContest.length == 0
                user.wonContest.push contest
              else
                wonList = []
                for won, i in user.wonContest
                  wonList.push String(won._id)
                unless wonList.indexOf(String(contest._id)) >=0
                  # console.log wonList.indexOf(String(contest._id))
                  # console.log wonList
                  # console.log contest._id
                  user.wonContest.push contest
              user.save()

            # User.update { _id: winner.uid }, { wonContest: [ contest ] }, { multi: true }, (err, data) ->
                # console.log data
            console.log "create winner log"
            WinnerLog.create {
              user_id: winner[0].uid,
              contest_id: c._id,
              template_id: req.params.id,
              contest_name: c.name,
              score: winner[0].score,
              prize:  c.loot.prize
              created_at: new Date()
              }, (err, winnerlog) ->
                  # console.log "callback"
                  # log ledger
                user = winner
                Ledger.create {
                  status: 'completed'
                  format: 'won'
                  user: {
                    id:       user._id,
                    username: user.username
                    name:     "#{user.first_name} #{user.last_name}",
                    email:    user.email
                  }
                  balance: {
                    coins:      user.coins
                    diamonds:   user.diamonds
                    emeralds:   user.emeralds
                    sapphires:  user.sapphires
                    rubies:     user.rubies
                  }
                  transaction: [
                    {
                      action:       'plus'
                      description:  'Winner contest'
                      from:         'contest'
                      to:           'winner'
                      unit:         'rubies'
                      amount:       c.loot.prize
                      tax:          (contest.fee * 10) / 100
                      ref: {
                        format: null
                        id: null
                      }
                    }
                  ]
                }

        # setTimeout (->
          # User.update { _id: winner.uid }, { wonContest: [ contest ] }, { multi: true }, (err, data) ->
              # console.log "Winner"
              # console.log data
          # User.findById winner.uid, (err, user) ->
          #     # console.log user
          #   if user.wonContest.length == 0
          #     user.wonContest.push contest
          #     user.save()
          #   else
          #     for won, i in user.wonContest
          #       if i == user.wonContest.length - 1 && won._id != contest._id
          #         user.wonContest.push contest
          #         user.save()


          # WinnerLog.create {
          #   user_id: winner.uid,
          #   contest_id: c._id,
          #   template_id: req.params.id,
          #   score: winner.score,
          #   prize:  c.loot.prize
          #   }, (err, winnerlog) ->
          #       # console.log "callback"
                # console.log winnerlog
          # return
        # ), 5000


    res.status(200).json {success: true}

exports.findProgramActive = (req, res) ->
  bucket = []
  current_time = new Date().getTime()
  temp = 0

  program = Program.find({}).select('name -_id')
  program.exec (err, programs) ->
    if err
      return next(err)

    for program in programs
      # contest = Contest.findOne({program: program.name})
      contest = Contest.where('program').equals(program.name)
        .where('end_time').gt(current_time)
        .exec (err, contests) ->
          if contests
            for contest, i in contests
              continue if contest.end_time == undefined
              e_time = contest.end_time.getTime()

              console.log e_time
              console.log current_time
              console.log current_time < e_time
              console.log contest
              if current_time < e_time
                if i == 0
                  temp = e_time
                  c = contest
                else if temp > e_time
                  temp = e_time
                  c = contest

                if i == contests.length - 1
                  bucket.push(c)

    setTimeout (->
      # console.log bucket
      render(res, bucket)
    ), 1000

handleError = (res, err) ->
  res.status(500).json err

render = (res, data) ->
  res.status(200).json data



exports.destroy = (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless contest
    contest.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()



exports.updateScore = (req, res) ->
  # console.log "update score"
  Template.findById req.params.id, (err, template) ->

  Contest.find { template_id: req.params.id }, (err, contests) ->
    for contest in contests
      Contest.findById contest._id, (err, c) ->
        query = Question.find({'templates': req.params.id})
        query.exec (err, templates) ->
          for p, k in c.player
            score = checkScore(p, templates)
            # console.log score
            # console.log "score-------"
            c.player[k].score = score
            c.save()

    res.status(200).json {success: true}
