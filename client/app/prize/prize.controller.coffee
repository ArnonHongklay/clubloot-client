'use strict'

angular.module 'clublootApp'
.controller 'PrizeCtrl', ($scope, $http, socket, prizes, $cookieStore, Auth, $modal, $timeout) ->
  $scope.prizes = prizes.data

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        console.log "-----user-----"
        console.log $scope.user
        $scope.$apply()
       
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  $scope.alphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

  $scope.$watch 'prize_select.selected.length', ->
    $('[class*="defaultItem"]').removeClass('hide-display')
    $('[class*="hoverItem"]').removeClass('show-display')
    for s in $scope.prize_select.selected
      $(".defaultItem-#{s._id}").addClass('hide-display')
      $(".hoverItem-#{s._id}").addClass('show-display')

  $scope.setData = () ->
    $.ajax
      url: "#{window.apiLink}/v2/prizes.json"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.prizes = data.data
        $scope.$apply()
        for prize in $scope.prizes
          if prize.price >= 0 && prize.price <= 10
            prize.tier = 1
          else if prize.price >= 11 && prize.price <= 25
            prize.tier = 2
          else if prize.price >= 26 && prize.price <= 50
            prize.tier = 3
          else if prize.price >= 51 && prize.price <= 100
            prize.tier = 4
          else
            prize.tier = 5

          $scope.prize_select = selected: { prize_id: false }
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return

  $scope.setData()


  $scope.clickPrize = (prize) ->


  $scope.defaultItem = true
  $scope.hoverIn = () ->
    this.hoverItem = true
    this.defaultItem = false
  $scope.hoverOut = () ->
    this.hoverItem = false
    this.defaultItem = true

  $scope.checkPrize = (selected) ->
    sum = 0
    for prize in selected
      sum += parseInt(prize.price)
    sum

  $scope.getMyPrize = ->

    unless $scope.agree
      swal("Please agree to the terms before get prize")
      return
    for prize in $scope.prize_select.selected
      console.log prize
      $.ajax
        url: "#{window.apiLink}/v2/user/prize.json"
        type: 'POST'
        data: {
          token: $scope.userToken
          prize_id: prize.id.$oid
        }
        datatype: 'json'
        success: (data) ->
          if data.status == "failure"
            swal(data.data)
          else
            swal("success")
            $scope.getUserProfile()
            $scope.currentTab = 'myPrize'
            $scope.prize_select.selected = []
            $scope.$apply()


  $scope.goDashboard = () ->
    window.location.href = "/dashboard"

  $scope.showMyPrize = (prize) ->
    console.log $scope.currentTab
    console.log prize
    $modal.open(
      templateUrl: 'ModalUserPrizes.html'
      controller: 'ModalUserPrizes'
      resolve:
        prize: ($http, $stateParams) ->
          return {prize: prize.prize, currentTab: $scope.currentTab, tracking_code: prize.tracking_code, shipped_at: prize.shipped_at}
    )
  $scope.showPrize = (prize)->
    console.log prize
    console.log $scope.currentTab
    $modal.open(
      templateUrl: 'ModalUserPrizes.html'
      controller: 'ModalUserPrizes'
      resolve:
        prize: ($http, $stateParams) ->
          return {prize: prize, currentTab: $scope.currentTab}
    )

.controller 'ModalUserPrizes', ($scope, prize) ->
  $scope.prize = prize
