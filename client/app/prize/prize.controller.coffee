'use strict'

angular.module 'clublootApp'
.controller 'PrizeCtrl', ($scope, $http, socket, prizes, Auth, $modal) ->
  $scope.prizes = prizes.data

  $scope.alphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

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

  $scope.$watch 'prize_select.selected.length', ->
    $('[class*="defaultItem"]').removeClass('hide-display')
    $('[class*="hoverItem"]').removeClass('show-display')
    for s in $scope.prize_select.selected
      $(".defaultItem-#{s._id}").addClass('hide-display')
      $(".hoverItem-#{s._id}").addClass('show-display')


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
    if $scope.prize_select.selected.length == 0 or $scope.prize_select.selected.length == undefined
      swal('Please select one')
      return
    unless $scope.agree
      swal('Please confirm')
      return

    sumOfPrize = $scope.checkPrize($scope.prize_select.selected)
    if Auth.getCurrentUser().diamonds < sumOfPrize
      swal('Sorry, you do not have enough gems for the prize.')
      return
    else
      Auth.getCurrentUser().diamonds = Auth.getCurrentUser().diamonds - sumOfPrize
      $http.put("/api/users/#{Auth.getCurrentUser()._id}", Auth.getCurrentUser()).success (data) ->
        ref = []
        for prize, i in $scope.prize_select.selected
          ref.push({format: 'prize', id: prize._id})

        $http.post("/api/ledgers",
          {
            action: 'plus'
            user: Auth.getCurrentUser()
            transaction: {
              format: 'prize'
              status: 'pending'
              ref: ref
              from: 'diamond'
              to: 'prize'
              amount: sumOfPrize
              tax: null
            }
          }
        ).success((data, status, headers, config) ->
          for prize, i in $scope.prize_select.selected
            $http.put("/api/prize/#{prize._id}/count").success (data) ->

          $scope.getPrice = true
        ).error((data, status, headers, config) ->
          swal("Not found!!")
        )

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
