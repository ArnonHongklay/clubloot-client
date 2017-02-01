'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $filter, $http, socket, $state, Auth, $stateParams, contest, program, templates, $timeout) ->
  $scope.programs = program.data
  # console.log $scope.programs
  $scope.contest = contest.data
  $scope.menu = $stateParams.contest
  $scope.$apend
  $scope.templates = templates.data
  $scope.questions = []
  $scope.template_ids = []
  $scope.ansChoice = ["A", "B", "C", "D", "E", "F", "G"]
  $scope.currentPlayer
  $scope.currentTemplate = ''
  $scope.selectedContestStatus = ''
  $scope.oldScore = 0

  console.log $scope.templates

  $http.get("/api/users").success (data) ->
    $scope.users = data

  $scope.checkSameScore = (score) ->
    if $scope.oldScore == score
      return 1
    else
      $scope.oldScore = score
      return 0

  $scope.username = (email) ->
    for user in $scope.users
      if email == user.email
        return user.username

  $scope.checkJoin = (contest) ->
    alreadyJoin = false
    for p in contest.player
      if Auth.getCurrentUser()._id == p.uid
        alreadyJoin = true
    alreadyJoin

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

  $scope.checkActive = (contest) ->
    status = contest.stage
    if contest.stage != "close"
      return true
    else
      return false

  $scope.stepBack = () ->
    window.location.href = '/contest'

  $http.get("/api/contest/program/#{$scope.contest.program}/all",
      null
    ).success((ok) ->
      $scope.allContest = ok
      for contest in $scope.allContest
        $http.get("/api/templates/#{contest.template_id}",
          null
        ).success((template) ->

        )

    ).error((data, status, headers, config) ->
      swal("Not Active")
    )

  $scope.checkGemColor = (type) ->
    return "color:red;!important"     if type == "ruby"
    return "color:blue;!important"    if type == "sapphire"
    return "color:green;!important"   if type == "emerald"
    return "color:grey;!important" if type == "diamond"

  $scope.checkScore = (player, index) ->
    score = 0
    return 0 if player.answers.length == 0
    for uAnswer, i in player.answers
      if uAnswer
        if $scope.questions[i].answers[uAnswer].is_correct == true
          score = score + 1

    player.score = score
    score

  $scope.checkstatus = (status) ->
    return status


  $scope.compairPlayer = (player) ->
    console.log $scope.contestSelection
    console.log "-=-=--=="
    $scope.selectedCompair = {
      user: [],
      vs: [],
      player: player,
      me: $scope.currentPlayer
    }

    $scope.selectedCompair.name = player.name || "enemy"
    return unless $scope.currentPlayer.answers
    for ans, i in $scope.questions
        # console.log ans
      $scope.selectedCompair.user.push {
        ans: $scope.ansChoice[$scope.currentPlayer.answers[i]],
        p: $scope.currentPlayer.answers[i]
      }
      $scope.selectedCompair.vs.push {
        ans: $scope.ansChoice[player.answers[i]],
        p: player.answers[i]
      }

  $scope.checkAns = (ans, index) ->
    return "fa-times" unless $scope.questions[index].answers[ans]
    return "fa-check" if $scope.questions[index].answers[ans].is_correct == true

    for i, k in $scope.questions[index].answers
      if i.is_correct == false && k >= $scope.questions[index].answers.length
        return ""

    return "fa-times"


  socket.syncUpdates 'question', $scope.questions, (event, item, object) ->
    for question in $scope.questions
      if question._id == item._id
        $.extend $scope.questions, item
        question.answers = item.answers
        $scope.$apply()


  socket.syncUpdates 'contest', [], (event, item, object) ->
    if item._id == $scope.contestSelection._id
      $scope.contestSelection = item
      $scope.$apply()

    if $scope.contest.program == item.program && event == "created"
      i = 0
      for c in $scope.allContest
        if c._id != item._id
          i = i + 1
        else
      if i == $scope.allContest.length
        $scope.allContest.unshift(item)
        $scope.$apply()
        return

    for contest in $scope.allContest
      if contest._id == item._id
        contest.stage = item.stage
        contest.player = item.player
        contest.status = item.status
        $scope.$apply()
        return
    if $scope.contestSelection._id == item._id
      $scope.contestSelection = item


  socket.syncUpdates 'contest', $scope.templates

  $scope.orderContest = (contest) ->
    $scope.students = $filter('orderBy')(contest, ->
        # console.log contest
    )
    return

  $scope.showContestDetail = false
  $scope.showContestDetails = (contest) ->
      # console.log contest
    $scope.alreadyJoin = false
    $scope.contestSelection = contest
    for p in $scope.contestSelection.player
      if Auth.getCurrentUser()._id == p.uid
          # console.log "alreadyJoin"
        $scope.alreadyJoin = true
    cd_time = ''
    $http.get("/api/templates/#{contest.template_id}/questions",
      null
    ).success((ques) ->
      $scope.questions = ques
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )
    $scope.showContestDetail = true

    $http.get("/api/templates/#{contest.template_id}",
      null
    ).success((template) ->
      date = new Date(template.start_time)
      cc = date.getFullYear() + '/' +
           date.getMonth() + '/' +
           date.getDate() + ' ' +
           date.getHours() + ':' +
           date.getMinutes() + ':' +
           date.getSeconds()
      cd_time = cc
    )
    for i in contest.player
      if i.uid == Auth.getCurrentUser()._id
        $scope.currentPlayer = i

  $scope.getNumber = (num) ->
      # console.log num
    if (typeof(num) != "undefined")
      num = num / 500
      new Array(parseInt(num))
    else
      new Array()

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

  $scope.renderGem = (fee, player) ->
    theGem = $scope.gemRepeat(fee, player)
    color = $scope.gemColor(theGem.type)
    gem = "<i class='fa fa-diamond' style='"+color+"'></i>"
    tmp = ""
    for i in [1..theGem.count]
      tmp += gem
      $('#currentPrize').html tmp
    return tmp


  $scope.joinedDisabled = false
  $scope.joinContest = (con) ->
    if $scope.joinedDisabled
      return false

    $scope.joinedDisabled = true

      # console.log "1"
    if Auth.getCurrentUser().coins < con.fee
      swal("you need more coin to join")
      return false

    for play, i in con.player
        # console.log con.player
      if Auth.getCurrentUser()._id == play.uid
        return false

      if i == con.player.length - 1
        if con.player.length <= con.max_player
          $state.go("question", { contest: con._id })
        else
          swal("Full contest")
          return false

    for p in con.participant
      if p.uid == Auth.getCurrentUser()._id
        return false

  if $stateParams.liveDashboard
    $scope.showContestDetails($scope.contest)

    if $stateParams.viewPlayer
      setTimeout (->
        $('#tablePlayers tr:first-child').click()
        return
      ), 1000


  $scope.goContest = (contest) ->
    if $scope.checkJoin(contest) == true
      window.location.href = "/question/#{contest._id}/"

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
