'use strict'

angular.module 'clublootApp'
.controller 'ScoreCtrl', ($scope, $location, Auth, $http, $rootScope, $timeout, socket) ->
  $scope.socket = socket.socket

