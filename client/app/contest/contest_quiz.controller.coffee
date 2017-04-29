'use strict'

angular.module 'clublootApp'
.controller 'ContestQuizCtrl', ($scope, $http, socket, $timeout, $cookieStore, Auth, $state, $stateParams) ->
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
       
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  $.ajax(
    method: 'GET'
    url: "#{window.apiLink}/v2/contests/template.json?template_id=#{$stateParams.template_id}"
    ).done (data) ->
      $scope.question = data.data
      $scope.$apply()

  $scope.checkShowAns = (ans) ->
    console.log ans
    if ans.name == "" && ans.attachment.indexOf("no-image") >= 0
      return false
    else
      return true
  $scope.selectInput = (q, a) ->
    e = "#ans_#{q}_#{a}"
    $scope.qaSelection[q] = $(e).val()

  $scope.unlessEmpty = () ->
    for i in $scope.qaSelection
      return false if i == undefined
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
      url: "#{window.apiLink}/v2/user/contest/quiz.json"
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
          console.log "comf"
          $scope.justSubmit(next)
        else
          event.preventDefault()
    return