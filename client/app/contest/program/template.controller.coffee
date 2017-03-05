'use strict'

angular.module 'clublootApp'
.controller 'ContestTemplateCtrl', ($scope, $http, Auth, $state, $stateParams, $rootScope) ->
  $scope.user = Auth.getCurrentUser()
  $.ajax(
    method: 'GET'
    url: "http://api.clubloot.com/contests/templates.json?program_id=#{$stateParams.program_id}"
    ).done (data) ->
    console.log data
    $scope.templates = data.data
    $scope.$apply()


  $.ajax(
    method: 'GET'
    url: 'http://api.clubloot.com/contests/programs.json'
    ).done (data) ->
    console.log data
    $scope.programList = data.data
    $scope.$apply()
    console.log $scope.programList

  $scope.selectTemplate = (program) ->
    $state.go('programTemplate.template', {program_id: program._id.$oid})


angular.module 'clublootApp'
.directive 'gemRepeat', ($timeout, $state, $stateParams) ->
  link: (scope, element, attrs, state) ->
    theGem = scope.gemRepeat(attrs.fee, attrs.player)
    color = scope.gemColor(theGem.type)
    gem = "<i class='fa fa-diamond' style='"+color+"'></i>"
    tmp = ""
    for i in [1..theGem.count]
      tmp += gem
    element.html tmp