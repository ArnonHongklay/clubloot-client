'use strict'

angular.module 'clublootApp'
.controller 'ExpiredTemplateCtrl', ($scope, $http, Auth, User, moment) ->

  $scope.loadList = ->
    $http.get("/api/templates",
        null
      ).success((data, status, headers, config) ->
        $scope.expiredTemplate = data
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.checkActive = (start, end) ->
    now = new Date().getTime()
    start = new Date(start).getTime()
    end = new Date(end).getTime()
    return now > end

  $scope.loadList()
