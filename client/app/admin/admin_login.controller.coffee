'use strict'

angular.module 'clublootApp'
.controller 'AdminLoginCtrl', ($scope, Auth, $location, $window, $http, $timeout) ->
  $('body').css({background: '#50ACC4'})
  $scope.user = {}
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.login
        email: $scope.user.email
        password: $scope.user.password

      .then ->
        console.log Auth.getCurrentUser()
        console.log Auth.getCurrentUser().role
        console.log Auth.getCurrentUser()._id
        $timeout ->
          if Auth.getCurrentUser().role == "admin"
            window.location.href =  '/admin'
            console.log "admin"
          else
            console.log "Not admin"
            $location.path '/'
        , 500

      .catch (err) ->
        $scope.errors.other = err.message
    #location.reload()


  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
