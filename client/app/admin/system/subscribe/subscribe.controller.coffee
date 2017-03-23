angular.module 'clublootApp'
.controller 'AdminSystemSubscribeCtrl', ($scope, $http, socket, $state, subscribe) ->
  $scope.subscribe = subscribe.data
