'use strict'

angular.module 'clublootApp'
.controller 'MainCtrl', ($scope, $http, socket, $rootScope, Auth, contests, $window, broadcasts, $timeout) ->
  $scope.socket = socket.socket
  $rootScope.openMessage = "k"
  if $window.location.host == 'clubloot.com'
    $window.location.replace('http://clubloot.com/landing.html')

  $timeout ->
    $('#anoucebox').collapsible 'accordion-open', contentOpen: 1

  , 200

  $scope.broadcasts = broadcasts.data
  $scope.contests = contests.data

  console.log $scope.contests
  $scope.id_logs = []

  $scope.gemMatrix = {
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

  socket.syncUpdates 'contest', $scope.contests

  $scope.socket.on 'message', (data) ->
    $rootScope.currentUser.messages.unshift data
    return

  $scope.deleteMessage = (index) ->
  # console.log index
    $rootScope.currentUser.messages.splice(index, 1)
  # console.log $rootScope.currentUser.messages
    $http.put("/api/users/#{$rootScope.currentUser._id}/deletemessage",
      $rootScope.currentUser.messages
    ).success((ok) ->
    # console.log ok
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )

  $('#anoucebox').collapsible 'accordion-open', contentOpen: 1


  $scope.openMessage = (index) ->
  # console.log index
    return $rootScope.openMessage = "k" if $rootScope.openMessage == index
    $rootScope.openMessage = index

  $scope.ordinal_suffix_of = (i) ->
    j = i % 10
    k = i % 100
    if j == 1 and k != 11
      return i + 'st'
    if j == 2 and k != 12
      return i + 'nd'
    if j == 3 and k != 13
      return i + 'rd'
    i + 'th'

  $scope.checkPosition = (contest) ->
    score = []
    cur_user = 0
    for p, k in contest.player
      if p.uid == $rootScope.currentUser._id
        cur_user = k
      score.push p.score
    index_score = score.sort().reverse()
    user_score = contest.player[cur_user].score
    rank = index_score.indexOf(user_score) + 1
  # console.log index_score
  # console.log "user_score:"+user_score
  # console.log rank + 1
    return $scope.ordinal_suffix_of(rank)




  # $scope.currentUser = Auth.getCurrentUser()
  $('body').css({background: '#fff'})

  $http.get("/api/users/#{Auth.getCurrentUser()._id}").success (data) ->
    $rootScope.currentUser = data

  $scope.awesomeThings = []

  # $http.get('/api/templates').success (awesomeThings) ->
  #   $scope.awesomeTemplates = awesomeTemplates
  #   # socket.syncUpdates 'thing', $scope.awesomeThings

  $http.get('/api/things').success (awesomeThings) ->
    $scope.awesomeThings = awesomeThings
    socket.syncUpdates 'thing', $scope.awesomeThings


  $scope.checkJoin = (contest) ->
    alreadyJoin = false
    for p in contest.player
      if Auth.getCurrentUser()._id == p.uid
        alreadyJoin = true
    alreadyJoin

  $scope.addThing = ->
    return if $scope.newThing is ''
    $http.post '/api/things',
      name: $scope.newThing

    $scope.newThing = ''

  $scope.deleteThing = (thing) ->
    $http.delete '/api/things/' + thing._id

  $scope.$on '$destroy', ->
    socket.unsyncUpdates 'thing'

  $scope.setFilter = (value) ->
    switch value
      when 'live'
        $scope.live = true
        $scope.upcoming = false
        $scope.past = false
      when 'upcoming'
        $scope.live = false
        $scope.upcoming = true
        $scope.past = false
      when 'past'
        $scope.live = false
        $scope.upcoming = false
        $scope.past = true

  $scope.setFilter('live')

  $scope.calGem = (fee, player) ->
    # console.log player
    prize = parseInt(fee) * parseInt(player)
    # console.log prize
    gemIndex = $scope.gemMatrix.list[parseInt(player)-2].fee.indexOf(fee)
    return $scope.gemMatrix.gem[gemIndex] || $scope.gemMatrix.gem[0]

  $scope.gemColor = (gemType) ->
    if gemType == "DIAMOND"
      gemColor = "color: #dedede;"
    if gemType == "RUBY"
      gemColor = "color: red;"
    if gemType == "SAPPHIRE"
      gemColor = "color: blue;"
    if gemType == "EMERALD"
      gemColor = "color: green;"
    return gemColor

  $scope.gemRepeat = (fee, player) ->
    prize = parseInt(fee) * parseInt(player)
    gemIndex = $scope.gemMatrix.list[parseInt(player)-2].fee.indexOf(parseInt(fee))
    $scope.gemMatrix.gem[gemIndex]

  $scope.goContest = (contest) ->
    window.location.href = "/question/#{contest._id}/"

  $scope.goLive = (contest) ->
    window.location.href = "/contest/#{contest.template_id}/"



angular.module 'clublootApp'
.directive 'gemRepeat', ($timeout, $state, $stateParams) ->
  link: (scope, element, attrs, state) ->
    theGem = scope.gemRepeat(attrs.fee, attrs.player)
    color = scope.gemColor(theGem.type)
    gem = "<i class='fa fa-diamond' style='"+color+"'></i>"
    tmp = ""
    for i in [1..theGem.count]
      tmp += gem
    element.html tmp
