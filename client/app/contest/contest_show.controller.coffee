'use strict'

angular.module 'clublootApp'
.controller 'ContestShowCtrl', ($scope, $http, socket, $stateParams) ->
  $scope.menu = $stateParams.contest
  $scope.$apend

  $scope.stepBack = () ->
    window.location.href = '/contest'
