'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'Adminuser',
    url: '/admin/user/:user_id'
    templateUrl: 'app/admin/user/user.html'
    controller: 'AdminUserCtrl'
    resolve:
      user: ($http, $stateParams) ->
        $http.get "/api/users/#{$stateParams.user_id}"

  .state 'Adminuser.profile',
    url: '/profile'
    templateUrl: 'app/admin/user/profile.html'
    controller: 'AdminUserProfileCtrl'

  .state 'Adminuser.contests',
    url: '/contests'
    templateUrl: 'app/admin/user/contests.html'
    controller: 'AdminUserContestsCtrl'

  .state 'Adminuser.transactions',
    url: '/transactions'
    templateUrl: 'app/admin/user/transactions.html'
    controller: 'AdminUserTransactionsCtrl'
    resolve:
      transactions: ($http, $stateParams) ->
        $http.get "/api/users/#{$stateParams.user_id}/transactions"

  .state 'Adminuser.prizes',
    url: '/prizes'
    templateUrl: 'app/admin/user/prizes.html'
    controller: 'AdminUserPrizesCtrl'
    resolve:
      prizes: ($http, $stateParams) ->
        $http.get "/api/users/#{$stateParams.user_id}/prizes"

  .state 'Adminuser.notes',
    url: '/notes'
    templateUrl: 'app/admin/user/notes.html'
    controller: 'AdminUserNotesCtrl'

  .state 'Adminuser.accounting',
    url: '/accounting'
    templateUrl: 'app/admin/user/accounting.html'
    controller: 'AdminUserAccountingCtrl'
