'use strict'

angular.module 'clublootApp'
.controller 'ContestQuizCtrl', ($scope, $http, socket, $timeout, Auth, $state, $stateParams) ->
  console.log $stateParams
  $scope.user = Auth.getCurrentUser()
  $scope.selectQues = null
  $scope.checkAnswer = false
  $scope.qaSelection = []
  $.ajax(
    method: 'GET'
    url: "http://api.clubloot.com/contests/template.json?template_id=#{$stateParams.template_id}"
    ).done (data) ->
      $scope.question = data.data
      $scope.$apply()

  $scope.unlessEmpty = () ->
    return false unless $scope.question
    if $scope.question.questions.length == $scope.qaSelection.length
      return true
    else
      return false

  $scope.openAns = (index) ->
    $('html, body').animate { scrollTop: $("#ques_"+index).offset().top }, 'fast'
    return true

  $scope.submitAnswer = () ->
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.user.token,
        'contest_id': $stateParams.contest_id,
        'details': $scope.getAnswer()
      }
      url: "http://api.clubloot.com/user/contest/quiz.json"
      ).done (data) ->
        $state.go('main')
        # console.log data
      # console.log data
    # console.log data
    # return

  $scope.getAnswer = () ->
    answers = "["
    for q, i in $scope.qaSelection
      answers += q
      answers += "," if i != $scope.qaSelection.length-1
    answers+="]"
    return answers


  window.onbeforeunload = (e) ->
    unless $scope.checkAnswer
      e.preventDefault()
      # $http.post("/api/contest/#{$scope.contest.id}/destroy", {}).success (data, status, headers, config) ->

  $scope.$on '$locationChangeStart', (event, next, current) ->
    return if current.indexOf("contest/new") >=0
    return if $scope.createNewStep == '1'
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
          window.location.href = next
        else
          event.preventDefault()
    return