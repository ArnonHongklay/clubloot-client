'use strict'

angular.module 'clublootApp'
.controller 'NewContestCtrl', ($scope, $http, socket, $timeout, Auth, programs, templates, questions) ->
  $scope.programList = programs.data
  $scope.templates = templates.data
  $scope.questions = questions.data
  $scope.contests = {loot:{prize:'',category:''},fee:''}
  # console.log $scope.templates
  $scope.gemIndex = null
  $scope.currentPrize = 0
  $scope.qaSelection = []
  $scope.checkAnswer = false

  $scope.allPrize = [110, 220, 330, 440, 550, 1100, 1650, 2200, 2750, 5500, 8250, 11000]

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


  # console.log $scope.gemMatrix

  $scope.checkActive = (start, end) ->
    now = new Date().getTime()
    start = new Date(start).getTime()
    end = new Date(end).getTime()
    # console.log moment(now).format('LLL')
    # console.log moment(end).format('LLL')
    # console.log "=============="
    return now < end

  $scope.landingContest = ->
    $scope.contests.owner = Auth.getCurrentUser().username
    $scope.contests.loot.category = "gem-red"
    $scope.contests.participant = []
    $scope.contests.participant.push(Auth.getCurrentUser())
    # $scope.contests.fee = $scope.addFeeTax($scope.contests.fee)

    $scope.contests.user_id = Auth.getCurrentUser()._id

    $http.post("/api/contest",
        $scope.contests
      ).success((data, status, headers, config) ->
        $scope.template_ids = []
        for template in $scope.templates
          if template.program == data.program #&& template.active == true
            $scope.template_ids.push(template._id)

        $scope.template_id = $scope.template_ids[$scope.template_ids.length-1]
        $scope.template_id = $scope.contests.template_id
        $scope.contest = {}
        $scope.contest.id = data._id
        $http.get("/api/templates/#{$scope.template_id}", null).success (d) ->
          $scope.contest.status = d.start_time

        $http.get("/api/templates/#{$scope.template_id}/questions",
            null
          ).success((ques) ->
            $scope.contest.challenge = ques.length
            $scope.contest.ques = ques
          ).error((data, status, headers, config) ->
            swal("Not Active")
          )

        $scope.createNewStep = '2'
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.numbers = [
    { title: 2 },
    { title: 3 },
    { title: 4 },
    { title: 5 },
    { title: 6 },
    { title: 7 },
    { title: 8 },
    { title: 9 },
    { title: 10 },
    { title: 11 },
    { title: 12 },
    { title: 13 },
    { title: 14 },
    { title: 15 },
    { title: 16 },
    { title: 17 },
    { title: 18 },
    { title: 19 },
    { title: 20 }
  ]

  $scope.fees = [
    { title: 100 },
    { title: 200 },
    { title: 300 },
    { title: 500 },
    { title: 1000 },
    { title: 1500 },
    { title: 2000 },
    { title: 2500 },
    { title: 3000 },
    { title: 4000 },
    { title: 5000 },
  ]

  # for fee in $scope.fees
  #   tax = (fee.title * 10) / 100
  #   fee.title = fee.title + tax

  $scope.prizes = [
    { title: 1, fee: 5000  },
    { title: 2, fee: 10000 },
    { title: 3, fee: 15000},
    { title: 4, fee: 20000 },
    { title: 5, fee: 30000 }
  ]

  $scope.newContestQuestion = [
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false}
  ]

  $scope.calPlayer = () ->
    $scope.contests.fee = ''

  $scope.addFeeTax = (fee) ->
    tax = (fee * 10) / 100
    parseInt(fee) + parseInt(tax)

  $scope.calPrize = (index) ->

    v = parseInt($('#contestFee').val())

    $scope.gemIndex = $scope.gemMatrix.list[$scope.contests.max_player-2].fee.indexOf(v)


    gemType = $scope.gemMatrix.gem[$scope.gemIndex].type

    if gemType == "DIAMOND"
      $scope.gemColor = "color: #dedede;"
    if gemType == "RUBY"
      $scope.gemColor = "color: red;"
    if gemType == "SAPPHIRE"
      $scope.gemColor = "color: blue;"
    if gemType == "EMERALD"
      $scope.gemColor = "color: green;"

    $scope.gemCounts = []
    for num in [1..parseInt($scope.gemMatrix.gem[$scope.gemIndex].count)]
      $scope.gemCounts.push {}

    tax = parseInt($scope.contests.fee) * parseInt($scope.contests.max_player) * 10 / 100

    # $scope.contests.loot.prize = parseInt(parseInt($scope.contests.fee) * parseInt($scope.contests.max_player))

    $scope.contests.loot.prize = $scope.allPrize[$scope.gemIndex]

  $scope.calGem = (val) ->
    # console.log val
    $scope.gemPrize = []
    prize = val
    # console.log "prize:"+prize
    diamond = 12500
    emerald = 2500
    saphire = 500
    ruby    = 100

    diamondCount = 0
    emeraldCount = 0
    saphireCount = 0
    rubyCount    = 0
    $scope.currentPrize = val
    $scope.gemList = []

    if diamond <= $scope.currentPrize
      diamondCount = parseInt($scope.currentPrize/diamond)
      $scope.currentPrize = $scope.currentPrize - (diamondCount * diamond)
      # console.log "---------------"
      # console.log diamond <= $scope.currentPrize
      # console.log "diamond:"+diamond
      # console.log "prize:"+$scope.currentPrize
      # console.log "diamondCount:"+diamondCount
      $scope.gemList.push {name: 'diamond', value: diamondCount}
      # console.log diamondCount * diamond
      # console.log "current:"+$scope.currentPrize
      # console.log $scope.gemList

    if emerald <= $scope.currentPrize
      emeraldCount = parseInt($scope.currentPrize/emerald)
      $scope.currentPrize = $scope.currentPrize - (emeraldCount * emerald)
      $scope.gemList.push {name: 'emerald', value: emeraldCount}
      # console.log "current:"+$scope.currentPrize
      # console.log $scope.gemList

    if saphire <= $scope.currentPrize
      saphireCount = parseInt($scope.currentPrize/saphire)
      $scope.currentPrize = $scope.currentPrize - (saphireCount * saphire)
      $scope.gemList.push {name: 'saphire', value: saphireCount}
      # console.log "current:"+$scope.currentPrize
      # console.log $scope.gemList

    if ruby <= $scope.currentPrize
      rubyCount = parseInt($scope.currentPrize/ruby)
      $scope.currentPrize = $scope.currentPrize - (rubyCount * ruby)
      $scope.gemList.push {name: 'ruby', value: rubyCount}
      # console.log "current:"+$scope.currentPrize
      # console.log $scope.gemList

    fullDiamond = prize/diamond
    fullEmerald = prize/emerald

    # console.log $scope.gemList

  $scope.finishNewContest = () ->
    window.location.href = '/dashboard'

  $scope.doneProcessing =  ->
    # console.log $scope.newContestQuestion

  $scope.unlessEmpty = () ->
    return false if $scope.qaSelection == undefined
    return false if $scope.contest == undefined
    return false if $scope.contest.ques == undefined

    # console.log $scope.contest.ques
    # console.log $scope.qaSelection
    if $scope.contest.ques.length == $scope.qaSelection.length
      # console.log "xxxxx"
      return true

  window.onbeforeunload = (e) ->
    unless $scope.checkAnswer
      e.preventDefault()
      $http.post("/api/contest/#{$scope.contest.id}/destroy", {}).success (data, status, headers, config) ->

  $scope.$on '$locationChangeStart', (event, next, current) ->
    return if $scope.createNewStep == '1'
  # $scope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    unless $scope.checkAnswer
      event.preventDefault()

      swal {
        title: 'Are you sure?'
        text: 'Contest will not be create'
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#DD6B55'
        confirmButtonText: 'yes'
        cancelButtonText: 'No'
        closeOnConfirm: false
        closeOnCancel: true
      }, (isConfirm) ->
        if isConfirm
          $http.post("/api/contest/#{$scope.contest.id}/destroy", {}).success (data, status, headers, config) ->
            window.location.href = next
        else
          event.preventDefault()


    return

  $scope.addScore = ->
    counter = 0
    $scope.checkAnswer = true
    for q,i in $scope.contest.ques
      for a in q.answers
        # console.log a
        # console.log a.is_correct
        # console.log $scope.qaSelection[i]
        if a.title == $scope.qaSelection[i] && a.is_correct
          # console.log "=============================================fuck"
          counter += 1

    $timeout ->
      # console.log counter
      $scope.contest.player = [{
        uid: Auth.getCurrentUser()._id,
        name: Auth.getCurrentUser().username,
        score: counter,
        answers: $scope.qaSelection
      }]

      $http.put("/api/contest/#{$scope.contest.id}",
        $scope.contest
      ).success (data) ->
        # console.log data

        $http.put("/api/contest/#{$scope.contest.id}/join_created",
          Auth.getCurrentUser()
        ).success((data) ->
          console.log data
        )
      $scope.createNewStep = '3'
    , 300

  $scope.qaShowAns = []
  $scope.openAns = (index) ->
    # console.log index
    $scope.qaShowAns[index] = true
