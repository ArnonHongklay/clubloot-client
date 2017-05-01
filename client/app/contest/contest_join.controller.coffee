'use strict'

angular.module 'clublootApp'
.controller 'ContestJoinCtrl', ($scope, $http, socket, $rootScope, $timeout, $cookieStore, Auth, $state, $stateParams) ->
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
      $timeout ->
        $('.question-title')[0].click()
      , 200
      $scope.$apply()

  $scope.checkShowAns = (ans) ->
    if ans.name == "" && ans.attachment.indexOf("no-image") >= 0
      return false
    else
      return true

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


  $scope.checkedAns = (i) ->
    return if $scope.question.questions.length-1 == parseInt(i)
    console.log "checkedAns"
    index = parseInt(i) + 1
    $rootScope.selectQues = index
    $scope.openAns(index)


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

      # $http.post("/api/contest/#{$scope.contest.id}/destroy", {}).success (data, status, headers, config) ->

  $scope.$on '$locationChangeStart', (event, next, current) ->
    return if next.indexOf("join") >=0
    return if current.indexOf("contest/new") >=0
    return if $scope.createNewStep == '1'
    unless $scope.checkAnswer
      event.preventDefault()

      swal {
        title: 'Are you sure?'
        text: 'you will not be join this contest'
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
          # window.location.href = next
        else
          event.preventDefault()
    return