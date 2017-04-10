'use strict'

angular.module 'clublootApp'
.controller 'ContestQuizCtrl', ($scope, $http, socket, $timeout, $cookieStore, Auth, $state, $stateParams) ->
  console.log $stateParams
  $scope.selectQues = null
  $scope.checkAnswer = false
  $scope.qaSelection = []

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
       
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  $.ajax(
    method: 'GET'
    url: "http://api.clubloot.com/v2/contests/template.json?template_id=#{$stateParams.template_id}"
    # url: "http://api.clubloot.com/v2/contests/template.json?template_id=#{$stateParams.template_id}"
    ).done (data) ->
      $scope.question = data.data
      console.log "question"
      console.log $scope.question
      $scope.$apply()

  $scope.selectInput = (q, a) ->
    e = "#ans_#{q}_#{a}"
    $scope.qaSelection[q] = $(e).val()

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
        'token': $scope.userToken,
        'contest_id': $stateParams.contest_id,
        'details': $scope.getAnswer()
      }
      url: "http://api.clubloot.com/v2/user/contest/quiz.json"
      ).done (data) ->
        $state.go('main')
        # console.log data
      # console.log data
    # console.log data
    # return

  $scope.justSubmit = (next) ->
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.userToken,
        'contest_id': $stateParams.contest_id,
        'details': $scope.getAnswer()
      }
      url: "http://api.clubloot.com/v2/user/contest/quiz.json"
      ).done (data) ->
        console.log "submitAnswer"
        console.log data
        window.location.href = next

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
          $scope.justSubmit(next)
        else
          event.preventDefault()
    return