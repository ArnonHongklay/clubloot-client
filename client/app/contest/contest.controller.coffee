'use strict'

angular.module 'clublootApp'
.controller 'ContestCtrl', ($scope, $http, socket) ->
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