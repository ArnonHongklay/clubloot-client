'use strict'

angular.module 'clublootApp'
.controller 'ContestVsCtrl', ($scope, $http, Auth, $state, $stateParams, $rootScope) ->
  $scope.user = Auth.getCurrentUser()
  console.log "ContestVsCtrl"
  console.log $stateParams
  $scope.ansList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"]
  # $.ajax(
  #   method: 'GET'
  #   url: "http://api.clubloot.com/contests/templates.json?program_id=#{$stateParams.program_id}"
  #   ).done (data) ->
  #   console.log data
  #   $scope.templates = data.data
  #   $scope.$apply()

  $.ajax(
    method: 'GET'
    url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}.json"
    ).done (data) ->
    console.log "--------------"
    console.log data.data
    for d in data.data
      if d.id.$oid == $stateParams.contest_id
        $scope.contest = d
        console.log "----------------=-=-=-=-="
        console.log d

    $scope.$apply()
    $scope.template_id = $scope.contest.template._id.$oid
    $rootScope.template_id = $scope.template_id
    $.ajax(
      method: 'GET'
      url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
      ).done (data) ->
      $scope.contest = data.data
      console.log "$scope.contest"
      console.log $scope.contest
      for player in $scope.contest.leaders
        if player.id.$oid == $scope.user._id
          $scope.playerMe = player
        if player.id.$oid == $stateParams.user_id
          $scope.playerVs = player

      # if $scope.currentPlayer._id == player._id
      #   index = parseInt(index)+1
      # $scope.selectedCompair = {
      #   user: [],
      #   vs: [],
      #   player: $scope.playerVs,
      #   me: $scope.playerMe
      # }

      # for ans, i in $scope.contest.quizes
      #     # console.log ans
      #   $scope.selectedCompair.user.push {
      #     ans: $scope.ansChoice[$scope.currentPlayer.answers[i]],
      #     p: $scope.currentPlayer.answers[i]
      #   }
      #   $scope.selectedCompair.vs.push {
      #     ans: $scope.ansChoice[$scope.contestSelection.player[index].answers[i]],
      #     p: $scope.contestSelection.player[index].answers[i]
      #   }



      $scope.$apply()

    return

  $scope.checkIndex = (index, user) ->
    answers = $scope.contest.template.questions[index].answers
    if user == 'me'
      return "" unless $scope.playerMe
      return "" if $scope.playerMe.quizes.length == 0
      return "" unless $scope.playerMe.quizes[index]
      ans_id = $scope.playerMe.quizes[index].answer_id
    if user == 'vs'
      return "" unless $scope.playerVs
      return "" if $scope.playerVs.quizes.length == 0
      return "" unless $scope.playerVs.quizes[index]
      ans_id = $scope.playerVs.quizes[index].answer_id
    for ans, i in answers
      if ans._id.$oid == ans_id
        return $scope.ansList[i]


  $scope.cancelVs = () ->
    $state.go('^')
