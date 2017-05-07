'use strict'

angular.module 'clublootApp'
.controller 'SignupCtrl', ($scope, Auth, $location, $window) ->
  $('body').css({background: '#50ACC4'})
  $scope.user = {}
  $scope.errors = {}
  $scope.register = (form) ->
    console.log "#{window.apiLink}/v2/auth/sign_up.json"

    $.ajax
      url: "#{window.apiLink}/v2/auth/sign_up.json"
      type: 'POST'
      datatype: 'json'
      data: {
        email: $scope.user.email
        password: $scope.user.password
        confirm_password: $scope.user.confirm_password
        username: $scope.user.username
        date_of_birth: $scope.user.dob
        promo:  $scope.user.promocode
      }
      success: (data) ->
        console.log "success"
        if data.status == 'failure'
          swal "#{data.data}"
          return
        else
          Auth.signinFirst
            email: $scope.user.email
            password: $scope.user.password
          $location.path '/'
      error: (data) ->
        console.log "error"
        console.log data






    # console.log $scope.user
    # $.ajax(
    #   method: 'POST'
    #   url: "#{window.apiLink}/v2/auth/sign_up.json"
    #   data: {
    #     email: $scope.user.email
    #     password: $scope.user.password
    #     confirm_password: $scope.user.confirm_password
    #     username: $scope.user.username
    #     date_of_birth: $scope.user.dob
    #     promo:  $scope.user.promocode
    #   }
    #   ).done (data) ->
    #     console.log data
    #     Auth.signin
    #       email: $scope.user.email
    #       password: $scope.user.password

      
    #     $location.path '/'
    # console.log "form"
    # $scope.submitted = true

    # if form.$valid
    #   # Account created, redirect to home
    #   Auth.createUser
    #     name: $scope.user.name
    #     email: $scope.user.email
    #     password: $scope.user.password
    #     birthday: $scope.user.dob
    #     username: $scope.user.username
    #   .then ->
    #     $location.path '/'

    #   .catch (err) ->
    #     err = err.data
    #     $scope.errors = {}

    #     # Update validity of form fields that match the mongoose errors
    #     angular.forEach err.errors, (error, field) ->
    #       form[field].$setValidity 'mongoose', false
    #       $scope.errors[field] = error.message

  $scope.loginOauth = (provider) ->
    $window.location.href = '/auth/' + provider
