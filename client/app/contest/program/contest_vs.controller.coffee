'use strict'

angular.module 'clublootApp'
.controller 'ContestVsCtrl', ($scope, $http, Auth, $state, $cable, $stateParams, $rootScope, $timeout, $cookieStore) ->
  console.log "ContestVsCtrl"
  $scope.ansList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"]  

  $scope.setData = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/contests/program/#{$stateParams.program_id}.json"
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
          $.ajax
            url: "http://api.clubloot.com/v2/user/contest/#{$stateParams.contest_id}.json?token=#{$scope.userToken}"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              $scope.contest = data.data
              $scope.$apply()
              console.log "=-=-=--=000"
              console.log $scope.contest
              $scope.template_id = $scope.contest.template._id.$oid
              $rootScope.template_id = $scope.template_id
              $.ajax
                url: "http://api.clubloot.com/v2/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
                type: 'GET'
                datatype: 'json'
                success: (data) ->
                  $scope.contest = data.data
                  for player in $scope.contest.leaders
                    if player.id.$oid == $scope.user.id.$oid
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
          $scope.template_id = $scope.contest.template.id.$oid
          $rootScope.template_id = $scope.template_id
          $.ajax
            url: "http://api.clubloot.com/v2/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              $scope.contest = data.data
              for player in $scope.contest.leaders
                if player.id.$oid == $scope.user.id.$oid
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
    $timeout ->
      $scope.setData()
      # $scope.loopGetData()
    , 30000

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

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
        $scope.cable = $cable('ws://api.clubloot.com/cable')
        $scope.channel = $scope.cable.subscribe('ContestChannel', received: (data) ->
          if typeof(data) == "undefined"
            $scope.setData()
            return
          if data.page == "contest_details"
            $scope.setData()
            return
          
          return
        )
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  
