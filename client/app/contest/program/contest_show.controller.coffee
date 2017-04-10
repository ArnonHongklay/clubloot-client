'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, Auth, $state, $cable, $cookieStore, $stateParams, $rootScope, $timeout) ->
  console.log "ContestShowCtrl"
  # $scope.user = Auth.getCurrentUser()
  $scope.alreadyJoin = false
  $scope.oldScore = 0
  # return if  $state.current.templateUrl != "app/contest/program/contest_show.html"

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

  $scope.compairPlayer = (player, index) ->
    $state.go('programTemplate.template.contest.vs', {user_id: player.id.$oid})

  $scope.goBack = () ->
    $state.go('^')

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

  $scope.renderGem = (fee, player) ->
    theGem = $scope.gemRepeat(fee, player)
    color = $scope.gemColor(theGem.type)
    gem = "<i class='fa fa-diamond' style='"+color+"'></i>"
    tmp = ""
    for i in [1..theGem.count]
      tmp += gem
      $('#currentPrize').html tmp
    return tmp

  $scope.joinContest = () ->
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.userToken,
        'contest_id': $stateParams.contest_id,
      }
      url: "http://api.clubloot.com/v2/user/contest/join.json"
      ).done (data) ->
        $state.go('contestQuizJoin', {contest_id: $stateParams.contest_id, template_id: $scope.template_id})

  $scope.checkSameScore = (score) ->
    if $scope.oldScore == score
      return 1
    else
      $scope.oldScore = score
      return 0

  $scope.setData = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/contests/program/#{$stateParams.program_id}/all_contests.json"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.contests = []
        for templates in data.data
          for contest in templates.contests
            $scope.contests.push(contest)
        contest = null
        if data.status != 'failure'
          for d in $scope.contests
            if d.id.$oid == $stateParams.contest_id
              contest = d
        unless contest
          $.ajax
            url: "http://api.clubloot.com/v2/user/contest/#{$stateParams.contest_id}.json?token=#{$scope.userToken}"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              $scope.contest = data.data
              $scope.contestPrize = data.data
              $scope.$apply()
              $scope.template_id = $scope.contest.template._id.$oid
              $rootScope.template_id = $scope.template_id
              $.ajax
                url: "http://api.clubloot.com/v2/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
                type: 'GET'
                datatype: 'json'
                success: (data) ->
                  $scope.contest = data.data
                  for player in $scope.contest.leaders
                    if player.id.$oid == $scope.user.id.$oid
                      $scope.alreadyJoin = true
                  $scope.$apply()
                error: (jqXHR, textStatus, errorThrown) ->
                  $timeout ->
                    $scope.setData()
                  , 2000
                  return
        else
          $scope.$apply()
          $scope.template_id = contest.template._id.$oid
          $rootScope.template_id = $scope.template_id
          $.ajax
            url: "http://api.clubloot.com/v2/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              $scope.contest = data.data
              for player in $scope.contest.leaders
                if player.id.$oid == $scope.user.id.$oid
                  $scope.alreadyJoin = true
              $scope.$apply()
            error: (jqXHR, textStatus, errorThrown) ->
              $timeout ->
                $scope.setData()
              , 2000
              return
          $.ajax
            url: "http://api.clubloot.com/v2/user/contest/#{$stateParams.contest_id}.json?token=#{$scope.userToken}"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              $scope.contestPrize = data.data
              $scope.$apply()


      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return

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

  $scope.checkWin = (player, contest) ->
    return unless contest
    a = 1
    return unless contest.winners
    for w in contest.winners
      if w._id.$oid == player.id.$oid
        a = 0
        return a
    return a

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
        $scope.cable = $cable('ws://api.clubloot.com/cable')
        $scope.channel = $scope.cable.subscribe('ContestChannel', received: (data) ->
          if typeof(data) == "undefined"
            $scope.setData()
            return
          if data.page == "contest_details" || data.page == "all_contest"
            $scope.setData()
            return
          
          return
        )
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()
