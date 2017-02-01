'use strict'
angular.module 'clublootApp'
.directive 'countDown', ->
  link: (scope, element, attributes, ctrl) ->
    # console.log "directive ======"
    current = new Date()
    date = new Date(attributes.countDown)

    cc = date.getFullYear() + '/' +
        (date.getMonth() + 1) + '/' +
         date.getDate() + ' ' +
         date.getHours() + ':' +
         date.getMinutes() + ':' +
         date.getSeconds()

    element.countdown cc, (event) ->
      # $(this).text event.strftime('%H:%M:%S')
      $(this).text event.strftime('%H:%M:%S')

      if date > 72.hours().from_now()
        $(this).css('color', 'green')
      else if date > 24.hours().from_now()
        $(this).css('color', 'orange')
      else
        $(this).css('color', 'red')

      return

Number::seconds = ->
  this * 1000

Number::minutes = ->
  @seconds() * 60

Number::minute = Number::minutes

Number::hours = ->
  @minutes() * 60

Number::hour = Number::hours

Number::ago = ->
  new Date((new Date).valueOf() - this)

Number::from_now = ->
  new Date((new Date).valueOf() + this)
