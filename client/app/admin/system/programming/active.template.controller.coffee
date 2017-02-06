'use strict'

angular.module 'clublootApp'
.controller 'ActiveTemplateCtrl', ($scope, $http, Auth, User, moment) ->

  $scope.loadList = ->
    $http.get("/api/templates",
        null
      ).success((data, status, headers, config) ->
        $scope.activeTemplate = data
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )

  $scope.checkActive = (start, end) ->
    now = new Date().getTime()
    start = new Date(start).getTime()
    end = new Date(end).getTime()
    return now < end

  $scope.canNotclick = () ->
    return swal("You can not edit now")

  $scope.loadList()
