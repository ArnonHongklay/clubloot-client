
angular.module 'clublootApp'
.controller 'AdminUserContestsActiveCtrl', ($scope, $http, socket, $state, $stateParams) ->
  $scope.menuContests = 'active'
  $scope.menuActive = 'Contests'

angular.module 'clublootApp'
.controller 'AdminUserContestsCompletedCtrl', ($scope, $http, socket, $state, $stateParams) ->
  $scope.menuContests = 'completed'
  $scope.menuActive = 'Contests'

angular.module 'clublootApp'
.controller 'AdminUserContestsWonCtrl', ($scope, $http, socket, $state, $stateParams) ->
  $scope.menuContests = 'won'
  $scope.menuActive = 'Contests'
