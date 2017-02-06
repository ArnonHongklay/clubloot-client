'use strict'

angular.module 'clublootApp'
.controller 'QuestionCtrl', ($scope, $stateParams, $http, $timeout, $window, Auth, User, id, socket) ->
  $scope.questions = id.data

  $scope.check = ->
    $(".check-true").checked = true

  $scope.setAns = (q_id, a_id) ->
    for que in $scope.questions
      if que._id == q_id
        for ans in que.answers
          if ans._id == a_id
            ans.is_correct = true
          else
            ans.is_correct = false


  socket.syncUpdates 'question', $scope.questions


  $scope.chooseQuestion = (q_id) ->
    all = $scope.questions.length
    count = 0
    for que in $scope.questions
      for ans in que.answers
        if ans.is_correct == true
          count = count + 1

      $http.put("/api/templates/#{$stateParams.id}/questions/#{que._id}",
          que
        ).success((data, status, headers, config) ->

          swal("updated")
        ).error((data, status, headers, config) ->
          swal("Not found!!")
        )
      $http.get("/api/contest/template/#{$stateParams.id}/score").success((data, status, headers, config) ->
        # console.log data
        )

  $scope.closeContest = () ->
    swal {
      title: 'Are you sure?'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55 '
      confirmButtonText: 'Yes'
      cancelButtonText: 'No'
      closeOnConfirm: false
      closeOnCancel: false
      }, (isConfirm) ->
        if isConfirm
          $http.get("/api/contest/template/#{$stateParams.id}").success((data, status, headers, config) ->
            swal("Update successfully")
          ).error((data) ->

          )
        else
          swal 'Cancelled', 'Your imaginary file is safe :)', 'error'
