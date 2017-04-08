'use strict'

angular.module 'clublootApp'
.controller 'ContestEditCtrl', ($scope, $http, socket, $timeout, $cookieStore, Auth, $state, $stateParams) ->
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
        $.ajax(
          method: 'GET'
          url: "http://api.clubloot.com/v2/contests/template.json?template_id=#{$stateParams.template_id}"
          ).done (data) ->
            $scope.question = data.data
            $scope.$apply()

            $.ajax(
              method: 'POST'
              url: "http://api.clubloot.com/v2/user/contest/edit.json?token=#{$scope.user.token}&contest_id=#{$stateParams.contest_id}"
              ).done (data) ->

              answer = data.data

              for a in answer.quizes
                $('#ans_'+a.answer_id).click()
                $('#ans_'+a.answer_id).click()

              $scope.$apply()
              console.log $scope.qaSelection
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()
  
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
    # return
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.user.token,
        'contest_id': $stateParams.contest_id,
        'details': $scope.getAnswer()
      }
      url: "http://api.clubloot.com/v2/user/contest/edit_quiz.json"
      ).done (data) ->
        console.log "submitAnswer"
        console.log data
        $state.go('main')

  $scope.justSubmit = (next) ->
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.user.token,
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
