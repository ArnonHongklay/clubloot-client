User = require '../api/template/template.model'
schedule = require('node-schedule')
rule = new schedule.RecurrenceRule()

rule.minute = 59
rule.hour = 23

return

j = schedule.scheduleJob(rule, ->
  currentdate = new Date()

  # console.log "Can get more free coins"
  Tempalte.find (err, templates) ->
    templates.forEach (template) ->
      end_time = new Date(template.end_time)

      if end_time < currentdate
        user.active = true
      else
        user.active = false

      user.save()
      return
    return
)
