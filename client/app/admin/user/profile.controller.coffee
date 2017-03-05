
angular.module 'clublootApp'
.controller 'AdminUserProfileCtrl', ($scope, $http, socket, $filter) ->
  $scope.menuActive = 'Profile'

  $scope.update = ->
    $http.put("/api/users/#{$scope.user._id}/profile",
      $scope.user
    ).success((data, status, headers, config) ->

    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )
