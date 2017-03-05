'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'admin',
    url: '/admin'
    templateUrl: 'app/admin/admin.html'
    controller: 'AdminCtrl'
  .state 'adminLogin',
    url: '/admin_login'
    templateUrl: 'app/admin/admin_login.html'
    controller: 'AdminLoginCtrl'
