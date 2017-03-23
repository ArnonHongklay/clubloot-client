
angular.module 'clublootApp'
.controller 'AdminSystemPrizesCtrl', ($scope, $http, $state, prize, $modal, Upload, $timeout) ->
  $scope.prizes = prize.data

  $scope.uploadPic = (file) ->
    swal {
      title: 'Are you sure?'
      type: 'warning'
      showCancelButton: true
    }, (isConfirm) ->
      if isConfirm
        # console.log file
        file.upload = Upload.upload(
          url: '/api/prize'
          data:
            prize: $scope.prize
            file: file)
        file.upload.then ((response) ->
          $timeout ->
            file.result = response.data

          $http.get('/api/prize').success((data) ->
            swal("added!")
            $scope.prizes = data
            $scope.prize = ""
          )
        ), ((response) ->
          if response.status > 0
            $scope.errorMsg = response.status + ': ' + response.data
        ), (evt) ->
          file.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total))

  $scope.edit = (id) ->
    for prize in $scope.prizes
      if prize._id == id
        $scope.prizeEdit = prize

    $modal.open(
      templateUrl: 'myModal.html'
      controller: 'PrizeEditController'
      resolve:
        prizes: ($http, $stateParams) ->
          return $scope.prizeEdit
    ).result.then (->

      return
    ), ->

      return
    return

  $scope.remove = (id) ->
    swal {
      title: 'Are you sure?'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Continue anyway'
    }, (isConfirm) ->
      if isConfirm
        $http.delete("/api/prize/#{id}").success((data) ->
          $scope.reload()
        ).error((data) ->
          swal("remove error! #{data}")
        )

  $scope.reload = ->
    $http.get("/api/prize").success((data) ->
      $scope.prizes = data
    )

  $scope.showDetail = (prize_data)->
    $modal.open(
      templateUrl: 'test.html'
      controller: 'ShowDetailController'
      resolve:
        prize: ($http, $stateParams) ->
          return prize_data
    )

.controller 'ShowDetailController', ($scope, prize) ->
  $scope.prize = prize

.controller 'PrizeEditController', ($scope, $modalInstance, prizes, $http, Upload, $timeout) ->
  $scope.prizeEdit = prizes
  $scope.ok = (file)->
    if $scope.prizeEditPicture
      file.upload = Upload.upload(
        url: "/api/prize/#{$scope.prizeEdit._id}"
        method: 'PUT'
        data:
          prize: $scope.prizeEdit
          file: file
        )

      file.upload.then (response) ->
        $timeout ->
          file.result = response.data

        $modalInstance.close()
    else
      $http.put("/api/prize/#{$scope.prizeEdit._id}",
        prize: $scope.prizeEdit
      ).success (data) ->
        $modalInstance.close()
    return
  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
    return
