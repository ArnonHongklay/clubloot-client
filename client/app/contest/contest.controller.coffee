'use strict'

angular.module 'clublootApp'
.controller 'ContestCtrl', ($scope, $http, socket, contests, $timeout) ->
  $scope.setData = () ->
    $.ajax
      url: "#{window.apiLink}/v2/contests/programs.json"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.programList = data.data
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000

  $scope.setData()

  $('.item-show').css 'display', 'none'
  $('.item-hover').css 'display', 'block'

  $scope.hoverIn = (elm) ->
    $('.show-' + elm + '> .item-show').css 'display', 'block'
    $('.show-' + elm + '> .item-hover').css 'display', 'none'
    return

  $scope.hoverOut = (elm) ->
    $('.show-' + elm + '> .item-show').css 'display', 'none'
    $('.show-' + elm + '> .item-hover').css 'display', 'block'
    return
