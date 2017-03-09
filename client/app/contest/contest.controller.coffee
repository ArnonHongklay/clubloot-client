'use strict'

angular.module 'clublootApp'
.controller 'ContestCtrl', ($scope, $http, socket, contests, $timeout) ->

  $scope.setData = () ->
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
        , 10000

  $scope.loopGetData = () ->
    console.log "looCAll"
    $timeout ->
      $scope.setData()
      $scope.loopGetData()
    , 30000

  $scope.setData()
  $scope.loopGetData()

  # $.ajax(
  #   method: 'GET'
  #   url: 'http://api.clubloot.com/contests/programs.json'
  #   ).done (data) ->
  #   console.log data
  #   $scope.programList = data.data
  #   $scope.$apply()
  #   console.log $scope.programList

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
