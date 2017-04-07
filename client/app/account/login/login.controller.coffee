'use strict'

angular.module 'clublootApp'
.controller 'LoginCtrl', ($scope, Auth, $location, $window, $http) ->
  $('body').css({background: '#50ACC4'})
  $scope.user = {}
  $scope.errors = {}
  $scope.login = (form) ->
    $scope.submitted = true

    if form.$valid
      # Logged in, redirect to home
      Auth.signin
        email: $scope.user.email
        password: $scope.user.password

      .then ->
        $location.path '/'

      .catch (err) ->
        $scope.errors.other = err.message
    #location.reload()


  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
