angular.module 'clublootApp'
.controller 'AdminSystemWinnerCtrl', ($scope, $http, socket, $state, winners) ->
  $scope.winners = winners.data
