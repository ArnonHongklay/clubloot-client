'use strict'

angular.module 'clublootApp'
.controller 'ContestEditCtrl', ($scope, $http, socket, $timeout, $cookieStore, Auth, $state, $stateParams) ->
  $scope.selectQues = null
  $scope.checkAnswer = false
  $scope.qaSelection = []

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
        $.ajax(
          method: 'GET'
          url: "#{window.apiLink}/v2/contests/template.json?template_id=#{$stateParams.template_id}"
          ).done (data) ->
            $scope.question = data.data
            $scope.$apply()

            $.ajax(
              method: 'POST'
              url: "#{window.apiLink}/v2/user/contest/edit.json?token=#{$scope.userToken}&contest_id=#{$stateParams.contest_id}"
              ).done (data) ->
              answer = data.data
              console.log answer
              console.log "answer"
              for a in answer.quizes
                console.log '#ans_'+a.answer_id
                $('#ans_'+a.answer_id).click()
                $('#ans_'+a.answer_id).click()

              $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  $scope.checkShowAns = (ans) ->
    console.log ans
    if ans.name == "" && ans.attachment.indexOf("no-image") >= 0
      return false
    else
      return true
  
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
      url: "#{window.apiLink}/v2/user/contest/edit_quiz.json"
      ).done (data) ->
      
        $state.go('main')

  $scope.justSubmit = (next) ->
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.userToken,
        'contest_id': $stateParams.contest_id,
        'details': $scope.getAnswer()
      }
      url: "#{window.apiLink}/v2/user/contest/quiz.json"
      ).done (data) ->
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
