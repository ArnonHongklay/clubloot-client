'use strict'
angular.module 'clublootApp'
.directive 'countDown', ->
  link: (scope, element, attributes, ctrl) ->
    current = new Date()
    date = new Date(attributes.countDown)

    cc = date.getFullYear() + '/' +
        (date.getMonth() + 1) + '/' +
         date.getDate() + ' ' +
         date.getHours() + ':' +
         date.getMinutes() + ':' +
         date.getSeconds()

    element.countdown cc, (event) ->
      d = parseInt(event.strftime('%D')) * 24
      h = parseInt(event.strftime('%H')) + d
      m = parseInt(event.strftime('%M'))
      s = parseInt(event.strftime('%S'))
      
      # $(this).text event.strftime('%d Days %H:%M:%S')
      $(this).text "#{h}:#{m}:#{s}"

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
