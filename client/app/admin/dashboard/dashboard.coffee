'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'Admindashboard',
    url: '/admin/dashboard'
    templateUrl: 'app/admin/dashboard/dashboard.html'
    controller: 'AdminDashboardCtrl'
    resolve:
      player: ($http, $stateParams, $state) ->
        $http.get "/api/v2/dashboard/player"
      allplayer: ($http, $stateParams, $state) ->
        $http.get "/api/v2/dashboard/allplayer"
      signinCount: ($http, $stateParams, $state) ->
        $http.get "/api/signin_log/today"
      tournament: ($http, $stateParams, $state) ->
        $http.get "/api/v2/dashboard/tournament"
      contests: ($http, $stateParams, $state) ->
        $http.get "/api/v2/dashboard/contests"
      rich: ($http, $stateParams, $state) ->
        $http.get "/api/v2/dashboard/rich"
      tax: ($http, $stateParams, $state) ->
        $http.get "/api/tax"
      winnerLogs: ($http, $stateParams) ->
        $http.get "/api/winner_log/today"
