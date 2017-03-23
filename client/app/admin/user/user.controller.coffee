angular.module 'clublootApp'
.controller 'AdminUserCtrl', ($scope, $http, socket, user, $filter) ->
  $scope.menuActive = 'Profile'
  $scope.user = user.data
  $scope.user.name = if $scope.user.first_name and $scope.user.last_name
    "#{$scope.user.first_name}, #{$scope.user.last_name}"
  else
    $scope.user.username

  $scope.user.birthday = $filter('date')($scope.user.birthday, 'MM/dd/yyyy')
