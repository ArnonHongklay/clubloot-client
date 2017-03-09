angular.module 'clublootApp'
.controller 'AdminSystemFreeLootCtrl', ($scope, $http, $state, freeLoot) ->
  $scope.freeLoot = freeLoot.data[0]
  $scope.updateFreeLoot = () ->
    # console.log $scope.freeLoot
    $http.put("/api/daily_loot/#{$scope.freeLoot._id}",
      $scope.freeLoot
    ).success((data, status, headers, config) ->
      return swal("Free Loot updated")
    ).error((data, status, headers, config) ->

    )
