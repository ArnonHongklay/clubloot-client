'use strict'

angular.module 'clublootApp'
.controller 'ContestTemplateCtrl', ($scope, $http, Auth, $state, $stateParams) ->
  $scope.user = Auth.getCurrentUser()
  $.ajax(
    method: 'GET'
    url: "http://api.clubloot.com/contests/templates.json?program_id=#{$stateParams.program_id}"
    ).done (data) ->
    console.log data
    $scope.templates = data.data
    $scope.$apply()


  $scope.selectTemplate = (id) ->
    $state.go('programTemplate.template', {template_id: id})


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