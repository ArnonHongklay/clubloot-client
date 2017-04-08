'use strict'

angular.module 'clublootApp'
.controller 'ContestTemplateCtrl', ($scope, $http, Auth, $state, $stateParams, $cookieStore, $rootScope, $timeout) ->
  # $scope.user = Auth.getCurrentUser()
  console.log "ContestTemplateCtrl"

  $scope.setData = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/contests/templates.json?program_id=#{$stateParams.program_id}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.templates = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return

    $.ajax
      url: 'http://api.clubloot.com/v2/contests/programs.json'
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.programList = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return

  $scope.selectTemplate = (program) ->
    $state.go('programTemplate.template', {program_id: program._id.$oid})


  $scope.loopGetData = () ->
    $timeout ->
      $scope.setData()
      $scope.loopGetData()
    , 30000

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
        $scope.setData()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()
