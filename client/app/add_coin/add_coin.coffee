'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'addCoin',
    url: '/add_coin'
    templateUrl: 'app/add_coin/add_coin.html'
    controller: 'AddCoinCtrl'
