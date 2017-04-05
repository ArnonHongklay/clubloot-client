'use strict'

angular.module 'clublootApp'
.controller 'ContestVsCtrl', ($scope, $http, Auth, $state, $cable, $stateParams, $rootScope, $timeout) ->
  $scope.user = Auth.getCurrentUser()
  console.log "ContestVsCtrl"
  console.log $stateParams
  $scope.ansList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"]
  # console.log $state.current.templateUrl
  # return if  $state.current.templateUrl != "app/contest/program/contest_vs.html"
  

  $scope.setData = () ->
    $.ajax
      url: "http://api.clubloot.com/v1/contests/program/#{$stateParams.program_id}.json"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        contest = null
        if data.status != 'failure'
          for d in data.data
            if d.id.$oid == $stateParams.contest_id
              contest = d
              $scope.contest = d

        unless contest
          # console.log '0000000000000099999999999999999999'
          # console.log $stateParams.contest_id
          $.ajax
            url: "http://api.clubloot.com/v1/user/contest/#{$stateParams.contest_id}.json?token=#{$scope.user.token}"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              #console.log '812937812731289372189372189279'
              $scope.contest = data.data
              #console.log $scope.contest
              $scope.$apply()
              $scope.template_id = $scope.contest.template._id.$oid
              $rootScope.template_id = $scope.template_id
              $.ajax
                url: "http://api.clubloot.com/v1/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
                type: 'GET'
                datatype: 'json'
                success: (data) ->
                  $scope.contest = data.data
                  #console.log "$scope.contest"
                  #console.log $scope.contest
                  for player in $scope.contest.leaders
                    if player.id.$oid == $scope.user._id
                      $scope.playerMe = player
                    if player.id.$oid == $stateParams.user_id
                      $scope.playerVs = player

                  $scope.$apply()
                  return
                error: (jqXHR, textStatus, errorThrown) ->
                  $timeout ->
                    $scope.setData()
                  , 2000
                  return
            error: (jqXHR, textStatus, errorThrown) ->
              $timeout ->
                $scope.setData()
              , 2000
              return
        else
          $scope.$apply()
          $scope.template_id = $scope.contest.template._id.$oid
          $rootScope.template_id = $scope.template_id
          $.ajax
            url: "http://api.clubloot.com/v1/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              $scope.contest = data.data
              #console.log "$scope.contest"
              #console.log $scope.contest
              for player in $scope.contest.leaders
                if player.id.$oid == $scope.user._id
                  $scope.playerMe = player
                if player.id.$oid == $stateParams.user_id
                  $scope.playerVs = player

              $scope.$apply()
              return
            error: (jqXHR, textStatus, errorThrown) ->
              $timeout ->
                $scope.setData()
              , 2000
              return
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return


  $scope.loopGetData = () ->
    console.log "looCAll"
    $timeout ->
      $scope.setData()
      # $scope.loopGetData()
    , 30000

  # $scope.setData()
  # $scope.loopGetData()

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

  $scope.cable = $cable('ws://api.clubloot.com/cable')
  $scope.channel = $scope.cable.subscribe('ContestChannel', received: (data) ->
    console.log "SOcket in contest_vs"
    if typeof(data) == "undefined"
      $scope.setData()
      return
    if data.page == "contest_details"
      $scope.setData()
      return
    
    return
  )
