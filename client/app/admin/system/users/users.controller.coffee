angular.module 'clublootApp'
.controller 'AdminSystemUserCtrl', ($scope, $http, socket, user) ->
  $scope.users = user.data
