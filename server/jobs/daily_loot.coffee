User = require '../api/user/user.model'
Conomy = require '../api/conomy_log/conomy_log.model'
Template = require '../api/template/template.model'
Contest  = require '../api/contest/contest.model'
Ledger = require '../api/ledger/ledger.model'
schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()

rule.second = 59
rule.hour = 23
rule.minute = 59
k = schedule.scheduleJob(rule, ->
  console.log "======================="
  console.log "Jobs Daily Loot"
  console.log rule
  economy = 0
  User.find {}, (err, players) ->
    for p in players
      c = p.coins
      r = p.rubies * 100
      s = p.sapphires * 500
      e = p.emeralds * 2500
      d = p.diamonds * 12500
      all = c+r+s+e+d

      console.log 'ALL'
      console.log all

      economy = economy + all

    console.log 'Economy'
    console.log economy

    Conomy.create {
      coins: economy
      created_at: new Date()
      }, (err, winnerlog) ->
        console.log 'Winner Log'
        console.log winnerlog
        console.log "======================="
  return
)



myContest =
  start: (contest) ->
    console.log "start function"
    s_time = ''
    e_time = ''
    Template.findById contest.template_id, (err, template) ->
      unless template
        Contest.findById contest._id, (err, contest) ->
          contest.remove (err) ->
            return
      else
        s_time = template.start_time
        e_time = template.end_time
        program_image = template.program_image
        console.log "22222222222"
        Contest.findById contest._id, (err, contest) ->
          console.log contest.status
          return if contest.status == "cancel" || contest.status == "live" || contest.status == "close"
          console.log "3333333333333"
          current_time = new Date().getTime()
          contest.start_time = s_time.getTime()
          contest.end_time   = e_time.getTime()
          contest.program_image = template.program_image
          console.log "current:#{current_time}"
          console.log "n:"

          if current_time > e_time.getTime()
            console.log "44444444444444444444"
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


rule2 = new schedule.RecurrenceRule()
rule2.minute = new (schedule.Range)(0, 59, 1)
j = schedule.scheduleJob(rule2, ->
  console.log new Date, 'The 30th second of the minute.'
  start = new Date()
  s = start.setHours(0,0,0,0)
  end = new Date()
  e = end.setHours(23,59,59,999)
  #  end_time: {$gte: s, $lt: e} }
  Contest.find({}).exec (err, contests) ->
    console.log "11111111"
    console.log "contest count:" + contests.length
    for contest in contests
      console.log "contest"
      myContest.start(contest)

  return
)
