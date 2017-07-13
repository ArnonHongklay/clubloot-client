'use strict'

angular.module 'clublootApp'
.controller 'ContestQuestionCtrl', ($timeout, $scope, $stateParams, $http, Auth, templates, contest) ->
  $scope.templates = templates.data
  $scope.contests = contest.data
  $scope.current_user = Auth.getCurrentUser()
  $scope.newPlayer = false
  $scope.qaSelection = []

  for player, i in $scope.contests.player

    if player.name == $scope.current_user.email
      break
    if i == $scope.contests.player.length-1
      if player.name != $scope.current_user.name
        $scope.newPlayer = true

  for player in $scope.contests.player
    $scope.currentPlayer = player if player.uid == $scope.current_user._id

  $scope.template_ids = []
  for template in $scope.templates
    if template.program == $scope.contests.program
      $scope.template_ids.push(template._id)

  $scope.template_id = $scope.template_ids[$scope.template_ids.length-2]

  $scope.template_id = $scope.contests.template_id

  $scope.contest = {}

  $scope.contest._id = $scope.contests._id
  $http.get("/api/templates/#{$scope.template_id}/questions",
      null
    ).success((ques) ->
      $scope.contest.ques = ques
      for q, i in $scope.contest.ques
        $scope.qaSelection[i] = "#{$scope.currentPlayer.answers[i]}"
    ).error((data, status, headers, config) ->
      swal("Not Active")
    )

  $scope.joinNewContest = () ->
    if $scope.qaSelection.length == 0
      swal 'You must answer at less 1 question'
      return

    if $scope.qaSelection.length < $scope.contest.ques.length
      swal {
        title: 'Are you sure?'
        text: 'You are not answer all questions yet'
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#DD6B55'
        confirmButtonText: 'Continue anyway'
        cancelButtonText: 'No'
        closeOnConfirm: false
        closeOnCancel: true
      }, (isConfirm) ->
        if isConfirm
          $http.put("/api/contest/#{$scope.contest._id}/join",
              Auth.getCurrentUser()
            ).success((ok) ->
              $scope.addScore()

            ).error((data, status, headers, config) ->
              swal {
                title: data.message
                text: ''
                type: 'warning'
                confirmButtonColor: '#DD6B55'
                confirmButtonText: 'ok'
                closeOnConfirm: true
              }, (isConfirm) ->
                window.location.href = "/"
            )
        else
    else
      $http.put("/api/contest/#{$scope.contest._id}/join",
        Auth.getCurrentUser()
      ).success((ok) ->
        $scope.addScore()

      ).error((data, status, headers, config) ->
        swal {
          title: data.message
          text: ''
          type: 'warning'
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'ok'
          closeOnConfirm: true
        }, (isConfirm) ->
          window.location.href = "/"
      )

  $scope.addScore = ->
    counter = 0
    for q,i in $scope.contest.ques
      for a in q.answers
        if a.title == $scope.qaSelection[i] && a.is_correct
          counter += 1

    $timeout ->
      $scope.contest.player = {
        uid: Auth.getCurrentUser()._id,
        name: Auth.getCurrentUser().email,
        score: counter,
        answers: $scope.qaSelection
      }

      $http.put("/api/contest/#{$scope.contest._id}/player",
        $scope.contest
      ).success (data) ->
        window.location.href = "/contest"
      $scope.createNewStep = '3'
    , 300

  $scope.unlessEmpty = () ->
    return false if $scope.qaSelection == undefined
    return false if $scope.contest == undefined
    return false if $scope.contest.ques == undefined

    if $scope.contest.ques.length == $scope.qaSelection.length
      console.log "Window"
      window.scrollTo 0, document.body.scrollHeight
      return true

  $scope.qaShowAns = []
  $scope.openAns = (index) ->
    $scope.qaShowAns[index] = true
