angular.module 'clublootApp'
.controller 'AdminSystemGemCtrl', ($scope, $http, socket, $state, gems, buckets) ->
  $scope.buckets = buckets.data
  $scope.taxMenu = 'gem'
  $scope.update = () ->
    $http.put("/api/gem_conversion/#{$scope.gems._id}",
      $scope.gems
    ).success((data, status, headers, config) ->

    ).error((data, status, headers, config) ->

    )

  $scope.addNewBucket = () ->
    $http.post("/api/coin_package",
      $scope.newBucket
    ).success((data, status, headers, config) ->
      $scope.buckets.push data
      $scope.newBucket = {bucket: '', coins: '', bonus: '', price: ''}
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.saveEditBucket = (bucket) ->
    $http.put("/api/coin_package/#{bucket._id}",
      bucket
    ).success((data, status, headers, config) ->

    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.removeBucket = (id, index) ->
    $http.delete("/api/coin_package/#{id}",
      ""
    ).success((data, status, headers, config) ->
      $scope.buckets.splice(index, 1)
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.set = () ->
    $http.post("/api/gem_conversion/set",
      'code': ''
    ).success((data, status, headers, config) ->
      $scope.gems = data
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  if gems.data.length < 1
    $scope.set()

  $scope.gems = gems.data[0]
