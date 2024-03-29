'use strict'

angular.module 'clublootApp'
.controller 'MainCtrl', ($scope, $http, socket, $rootScope, $state, Auth, $cable, $cookieStore, contests, $window, broadcasts, $timeout) ->
  $scope.socket = socket.socket
  $scope.userToken = $cookieStore.get 'token'  
  $rootScope.openMessage = "k"
  unless $scope.userToken
    window.location.href = '/login'

  if $window.location.host == 'clubloot.com'
    $window.location.replace('http://clubloot.com/landing.html')

  $timeout ->
    $('#anoucebox').collapsible 'accordion-open', contentOpen: 1
  , 200

  $scope.broadcasts = broadcasts.data
  $scope.contests = contests.data

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

  $scope.getAllContest = () ->
    console.log "dsdsds"
    $.ajax
      url: "#{window.apiLink}/v2/user/contests.json?token=#{$scope.userToken}&state=all"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.allContests = data.data
        console.log $scope.allContests
        console.log "12345"
        $scope.upcomingCount = 0
        $scope.liveCount = 0
        for c in $scope.allContests
          if c.state == 'upcoming'
            $scope.upcomingCount += 1
          if c.state == 'live'
            $scope.liveCount += 1
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getAllContest()
        , 2000

  $scope.getUserProfile = () ->
    token = $cookieStore.get 'token'
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.userProfile = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  $scope.getUpcoming = () ->

    $.ajax
      url: "#{window.apiLink}/v2/user/contests.json?token=#{$scope.user.token}&state=upcoming"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.upcomingContests = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUpcoming()
        , 10000

  $scope.getlive = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/contests.json?token=#{$scope.user.token}&state=live"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.liveContests = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getlive()
        , 10000

  $scope.getCancel = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/contests.json?token=#{$scope.user.token}&state=cancel"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.cancelContests = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getCancel()
        , 10000

  $scope.getEnd = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/contests.json?token=#{$scope.user.token}&state=past"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.endContests = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getEnd()
        , 10000

  $scope.getWin = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/contests.json?token=#{$scope.user.token}&state=winners"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.wonContests = data.data
        $rootScope.wonContests = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getWin()
        , 2000

  $scope.liveCount = () ->
    $('.live-contest-el').length

  $scope.upcomingCount = () ->
    $('.upcoming-contest-el').length

  socket.syncUpdates 'contest', $scope.contests

  $scope.socket.on 'message', (data) ->
    $rootScope.currentUser.messages.unshift data
    return

  $scope.deleteMessage = (index) ->
    $rootScope.currentUser.messages.splice(index, 1)
    $http.put("/api/users/#{$rootScope.currentUser._id}/deletemessage",
      $rootScope.currentUser.messages
    ).success((ok) ->

    ).error((data, status, headers, config) ->
      swal("Not Active")
    )

  $('#anoucebox').collapsible 'accordion-open', contentOpen: 1


  $scope.openMessage = (index) ->
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
    for p, k in contest.leaders
      if p.id.$oid == $scope.user.id.$oid
        cur_user = p
    return $scope.ordinal_suffix_of(cur_user.position)


  $scope.$on '$locationChangeStart', (event, next, current) ->
    if current.indexOf('quiz') >= 0 || current.indexOf('edit') >= 0 || current.indexOf('join') >= 0
      $scope.setFilter('upcoming')

  $('body').css({background: '#fff'})

  $scope.checkJoin = (contest) ->
    for p in contest.players
      if p._id.$oid == $scope.user.id.$oid
        return true
    return false

  $scope.checkHost = (contest) ->
    contest.host._id.$oid == $scope.user.id.$oid

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
    prize = parseInt(fee) * parseInt(player)
    gemIndex = $scope.gemMatrix.list[parseInt(player)-2].fee.indexOf(fee)
    return $scope.gemMatrix.gem[gemIndex] || $scope.gemMatrix.gem[0]

  $scope.gemColor = (gemType) ->
    if gemType.toUpperCase() == "DIAMOND"
      gemColor = "color: #dedede;"
    if gemType.toUpperCase() == "RUBY"
      gemColor = "color: red;"
    if gemType.toUpperCase() == "SAPPHIRE"
      gemColor = "color: blue;"
    if gemType.toUpperCase() == "EMERALD"
      gemColor = "color: green;"
    return gemColor

  $scope.checkGemColor = (gemType) ->
    if gemType.toUpperCase() == "DIAMOND"
      gemColor = "color: #dedede;"
    if gemType.toUpperCase() == "RUBY"
      gemColor = "color: red;"
    if gemType.toUpperCase() == "SAPPHIRE"
      gemColor = "color: blue;"
    if gemType.toUpperCase() == "EMERALD"
      gemColor = "color: green;"
    return gemColor

  $scope.gemRepeat = (fee, player) ->
    prize = parseInt(fee) * parseInt(player)
    gemIndex = $scope.gemMatrix.list[parseInt(player)-2].fee.indexOf(parseInt(fee))
    $scope.gemMatrix.gem[gemIndex]

  $scope.goContest = (contest) ->
    return
    window.location.href = "/question/#{contest._id}/"

  $scope.goLive = (contest) ->
    window.location.href = "/contest/#{contest.template_id}/"


  $scope.getUserProfile = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
        $scope.cable = $cable(window.socketLink)

        $scope.channel = $scope.cable.subscribe('ContestChannel', received: (data) ->
          if typeof(data) == "undefined"
            $scope.getAllContest()
            $scope.getWin()
            return
          if data.page == "dashboard" || data.page == "contest_details"
            $scope.getAllContest()
            $scope.getWin()
            return
          
          return
        )
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

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
