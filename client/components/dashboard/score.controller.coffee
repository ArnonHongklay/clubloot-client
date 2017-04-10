'use strict'

angular.module 'clublootApp'
.controller 'ScoreCtrl', ($scope, $location, Auth, $http, $cable, $cookieStore, $rootScope, $timeout, socket) ->
  $scope.socket = socket.socket

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
          console.log "SOcket in dashboard"
          if typeof(data) == "undefined"
            # $scope.getAllContest()
            # $scope.getWin()
            $scope.getUserProfile()
            return
          if data.page == "dashboard" || data.page == "contest_details"
            # $scope.getAllContest()
            # $scope.getWin()
            $scope.getUserProfile()
            return
          
          return
        )
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  
