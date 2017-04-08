'use strict'

angular.module 'clublootApp'
.controller 'ScoreCtrl', ($scope, $location, Auth, $http, $cookieStore, $rootScope, $timeout, socket) ->
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
       
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  
