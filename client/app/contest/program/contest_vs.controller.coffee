'use strict'

angular.module 'clublootApp'
.controller 'ContestVsCtrl', ($scope, $http, Auth, $state, $stateParams, $rootScope, $timeout) ->
  $scope.user = Auth.getCurrentUser()
  console.log "ContestVsCtrl"
  console.log $stateParams
  $scope.ansList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"]
  # $.ajax(
  #   method: 'GET'
  #   url: "http://api.clubloot.com/contests/templates.json?program_id=#{$stateParams.program_id}"
  #   ).done (data) ->
  #   console.log data
  #   $scope.templates = data.data
  #   $scope.$apply()

  $scope.setData = () ->
    $.ajax
      url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}.json"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.contest = null
        if data.status != 'failure'
          for d in data.data
            if d.id.$oid == $stateParams.contest_id
              $scope.contest = d

        unless $scope.contest
          console.log '0000000000000099999999999999999999'
          console.log $stateParams.contest_id
          $.ajax
            url: "http://api.clubloot.com/user/contest/#{$stateParams.contest_id}.json?token=#{$scope.user.token}"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              console.log '812937812731289372189372189279'
              $scope.contest = data.data
              $scope.$apply()
              $scope.template_id = $scope.contest.template._id.$oid
              $rootScope.template_id = $scope.template_id
              $.ajax
                url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
                type: 'GET'
                datatype: 'json'
                success: (data) ->
                  $scope.contest = data.data
                  console.log "$scope.contest"
                  console.log $scope.contest
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
                  , 10000
                  return
        else
          $scope.$apply()
          $scope.template_id = $scope.contest.template._id.$oid
          $rootScope.template_id = $scope.template_id
          $.ajax
            url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              $scope.contest = data.data
              console.log "$scope.contest"
              console.log $scope.contest
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
              , 10000
              return
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 10000
        return






    # $.ajax(
    #   method: 'GET'
    #   url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}.json"
    #   ).done (data) ->
    #   console.log "--------------"
    #   console.log data.data
    #   for d in data.data
    #     if d.id.$oid == $stateParams.contest_id
    #       $scope.contest = d
    #       console.log "----------------=-=-=-=-="
    #       console.log d

    #   $scope.$apply()
    #   $scope.template_id = $scope.contest.template._id.$oid
    #   $rootScope.template_id = $scope.template_id
    #   $.ajax(
    #     method: 'GET'
    #     url: "http://api.clubloot.com/contests/program/#{$stateParams.program_id}/template/#{$scope.template_id}/contest/#{$stateParams.contest_id}.json"
    #     ).done (data) ->
    #     $scope.contest = data.data
    #     console.log "$scope.contest"
    #     console.log $scope.contest
    #     for player in $scope.contest.leaders
    #       if player.id.$oid == $scope.user._id
    #         $scope.playerMe = player
    #       if player.id.$oid == $stateParams.user_id
    #         $scope.playerVs = player

    #     $scope.$apply()

    #   return

  $scope.loopGetData = () ->
    console.log "looCAll"
    $timeout ->
      $scope.setData()
      $scope.loopGetData()
    , 30000

  $scope.setData()
  $scope.loopGetData()

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
