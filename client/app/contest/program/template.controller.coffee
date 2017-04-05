'use strict'

angular.module 'clublootApp'
.controller 'ContestTemplateCtrl', ($scope, $http, Auth, $state, $stateParams, $rootScope, $timeout) ->
  $scope.user = Auth.getCurrentUser()
  console.log "ContestTemplateCtrl"

  $scope.setData = () ->
    $.ajax
      url: "http://api.clubloot.com/contests/templates.json?program_id=#{$stateParams.program_id}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        console.log data
        $scope.templates = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return

    $.ajax
      url: 'http://api.clubloot.com/contests/programs.json'
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        console.log data
        $scope.programList = data.data
        $scope.$apply()
        console.log $scope.programList
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return

  $scope.selectTemplate = (program) ->
    $state.go('programTemplate.template', {program_id: program._id.$oid})


  $scope.loopGetData = () ->
    console.log "looCAll"
    $timeout ->
      $scope.setData()
      $scope.loopGetData()
    , 30000

  $scope.setData()
