angular.module 'clublootApp'
.controller 'AdminDashboardCtrl', ($scope, $http, socket, player, tournament, contests, rich) ->
  $scope.player     = player.data.player
  $scope.tournament = tournament.data.tournament
  $scope.contests   = contests.data
  $scope.rich       = rich.data
  console.log $scope.rich

  # $('#ex2').bootstrapSlider()
