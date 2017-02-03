'use strict'

angular.module 'clublootApp'
.controller 'ProgramListCtrl', ($scope, $http, Auth, User) ->

  $scope.loadList = ->
    $http.get("/api/program",
        null
      ).success((data, status, headers, config) ->
        $scope.programList = data
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.loadList()

  $scope.active = (list) ->
    $http.put("/api/program/#{list._id}",
      active: !list.active
    ).success((data, status, headers, config) ->
      $.each $scope.programList, (key, value) ->
        if value._id == list._id
          $scope.programList[key].active = data.active
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )
