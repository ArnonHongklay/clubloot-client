'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'AdminService',
    url: '/admin/service'
    templateUrl: 'app/admin/service/service.html'
    controller: 'AdminServiceCtrl'
