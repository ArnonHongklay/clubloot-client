'use strict'

angular.module 'clublootApp'
.controller 'AddCoinCtrl', ($scope, $http, socket, $rootScope, Auth) ->
  console.log "AddCoinCtrl"
