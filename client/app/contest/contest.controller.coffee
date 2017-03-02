'use strict'

angular.module 'clublootApp'
.controller 'ContestCtrl', ($scope, $http, socket, contests) ->
  $.ajax(
    method: 'GET'
    url: 'http://api.clubloot.com/contests/programs.json'
    ).done (data) ->
    console.log data
    $scope.programList = data.data
    console.log $scope.programList

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
