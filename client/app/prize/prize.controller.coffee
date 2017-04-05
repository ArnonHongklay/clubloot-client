'use strict'

angular.module 'clublootApp'
.controller 'PrizeCtrl', ($scope, $http, socket, prizes, Auth, $modal, $timeout) ->
  $scope.prizes = prizes.data
  $scope.user = Auth.getCurrentUser()

  $scope.alphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

  

  $scope.$watch 'prize_select.selected.length', ->
    $('[class*="defaultItem"]').removeClass('hide-display')
    $('[class*="hoverItem"]').removeClass('show-display')
    for s in $scope.prize_select.selected
      $(".defaultItem-#{s._id}").addClass('hide-display')
      $(".hoverItem-#{s._id}").addClass('show-display')

  $scope.setData = () ->
    $.ajax
      url: "http://api.clubloot.com/v2/prizes.json"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        console.log data
        $scope.prizes = data.data
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
    for prize in $scope.prize_select.selected
      $.ajax
        url: "http://api.clubloot.com/v2/user/prize.json"
        type: 'POST'
        data: {
          token: $scope.user.token
          prize_id: prize.id.$oid
        }
        datatype: 'json'
        success: (data) ->
          console.log data
          if data.status == "failure"
            swal(data.data)
          else
            swal("success")


  $scope.goDashboard = () ->
    window.location.href = "/dashboard"

  $scope.showPrize = (prize)->
    $modal.open(
      templateUrl: 'ModalUserPrizes.html'
      controller: 'ModalUserPrizes'
      resolve:
        prize: ($http, $stateParams) ->
          return prize
    )

.controller 'ModalUserPrizes', ($scope, prize) ->
  $scope.prize = prize
