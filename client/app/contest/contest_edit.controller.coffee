'use strict'

angular.module 'clublootApp'
.controller 'ContestEditCtrl', ($scope, $http, socket, $timeout, Auth, $state, $stateParams) ->
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
      console.log "--------zzzzzzzzz-------"
      $scope.$apply()

      $.ajax(
        method: 'POST'
        url: "http://api.clubloot.com/user/contest/edit.json?token=#{$scope.user.token}&contest_id=#{$stateParams.contest_id}"
        ).done (data) ->
        console.log "-------5555555555555555-------"
        console.log data.data
        console.log $scope.question.questions
        answer = data.data
        console.log "answer"

        console.log answer

        # for q, i in $scope.question.questions
        #   ans = answer.quizes[i].answer_id
        #   $scope.qaSelection[i] = "{'question_id':'#{q._id.$oid}','answer_id':'#{ans}'}"

        for a in answer.quizes
          $('#ans_'+a.answer_id).click()
          $('#ans_'+a.answer_id).click()

        $scope.$apply()
        console.log $scope.qaSelection
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
    console.log $scope.qaSelection
    console.log $scope.user.token
    console.log $stateParams.contest_id
    console.log $scope.getAnswer()
    # return
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.user.token,
        'contest_id': $stateParams.contest_id,
        'details': $scope.getAnswer()
      }
      url: "http://api.clubloot.com/user/contest/edit_quiz.json"
      ).done (data) ->
        console.log "submitAnswer"
        console.log data
        $state.go('main')
        # console.log data
      # console.log data
    # console.log data
    # return

  $scope.justSubmit = (next) ->
    $.ajax(
      method: 'POST'
      data: {
        'token': $scope.user.token,
        'contest_id': $stateParams.contest_id,
        'details': $scope.getAnswer()
      }
      url: "http://api.clubloot.com/user/contest/quiz.json"
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

  # $scope.$on '$locationChangeStart', (event, next, current) ->
  #   console.log "location change"
  #   console.log current
  #   console.log next
  #   return if next.indexOf("edit") >=0
  #   return if current.indexOf("contest/new") >=0
  #   return if $scope.createNewStep == '1'
  #   unless $scope.checkAnswer
  #     event.preventDefault()

  #     swal {
  #       title: 'Are you sure?'
  #       text: 'Contest will not be create'
  #       type: 'warning'
  #       showCancelButton: true
  #       confirmButtonColor: '#DD6B55'
  #       confirmButtonText: 'yes'
  #       cancelButtonText: 'No'
  #       closeOnConfirm: false
  #       closeOnCancel: true
  #     }, (isConfirm) ->
  #       if isConfirm
  #         $scope.justSubmit(next)
  #         # window.location.href = next
  #       else
  #         event.preventDefault()
  #   return