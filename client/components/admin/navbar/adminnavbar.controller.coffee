'use strict'

angular.module 'clublootApp'
.controller 'AdminNavbarCtrl', ($scope, $location, Auth, $timeout) ->
  $scope.menu = [
    {
      title: 'Dashboard'
      link: '/admin/dashboard'
    },
    {
      title: 'Services',
      link: '/admin/service'
    },
    {
      title: 'System',
      link: '/admin/system'
    }
  ]

  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser

  $timeout ->
    unless Auth.getCurrentUser()
      window.location.href = "/login"
    if Auth.getCurrentUser()
      console.log "user"
      if Auth.getCurrentUser().role != "admin"
        console.log "not admin"
        Auth.logout()
        window.location.href = "/admin_login"
  , 500

  $scope.logout = ->
    Auth.logout()
    $location.path '/login'

  $scope.isActive = (route) ->
    route is $location.path()
