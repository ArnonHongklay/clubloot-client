'use strict'

angular.module 'clublootApp'
.controller 'ContestTemplateShowCtrl', ($scope, $http, Auth, $state, $stateParams, $rootScope) ->
  $scope.user = Auth.getCurrentUser()
  console.log 'ContestTemplateShowCtrl'
  console.log $stateParams

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

  $.ajax(
    method: 'GET'
    url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}.json"
    ).done (data) ->
    $scope.contests = data.data
    console.log $scope.contests
    $scope.$apply()
    return

  # $.ajax(
  #   method: 'GET'
  #   url: 'http://api.clubloot.com/contests/programs.json'
  #   ).done (data) ->
  #   console.log "=-=-=-=-=-=-=-="
  #   for d in data.data
  #     console.log d._id.$oid
  #     console.log $stateParams.program_id
  #     if d._id.$oid == $stateParams.program_id
  #       console.log "same"
  #       console.log d
  #       $rootScope.program = d
  #   $scope.$apply()
  #   console.log $rootScope.program

  $.ajax(
    method: 'GET'
    url: "http://api.clubloot.com/program/#{$stateParams.program_id}.json"
    ).done (data) ->
    console.log $stateParams
    console.log "---------------ssssssssssssss--"

    $rootScope.currentProgram = data.data
    console.log $rootScope.currentProgram
    $scope.$apply()

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

  $scope.showContestDetails = (contest) ->
    console.log contest
    $state.go('programTemplate.template.contest', {contest_id: contest.id.$oid})

  $scope.gemRepeat = (fee, player) ->
    console.log "player:"+player
    console.log "fee:#{fee}"
    prize = parseInt(fee) * parseInt(player)
    gemIndex = $scope.gemMatrix.list[parseInt(player)-2].fee.indexOf(parseInt(fee))
    $scope.gemMatrix.gem[gemIndex]

  $scope.calGem = (fee, player) ->
    prize = parseInt(fee) * parseInt(player)
    gemIndex = $scope.gemMatrix.list[parseInt(player)-2].fee.indexOf(fee)
    return $scope.gemMatrix.gem[gemIndex] || $scope.gemMatrix.gem[0]