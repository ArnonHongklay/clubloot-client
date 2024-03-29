'use strict'

angular.module 'clublootApp'
.controller 'NavbarCtrl', ($scope, $location, Auth, $http, $rootScope, $cookieStore, $timeout, socket, $cable) ->
  $scope.socket = socket.socket
  $scope.userToken = $cookieStore.get 'token'
  unless $scope.userToken
    window.location.href = '/login'

  $scope.socket.on 'message', (data) ->
    return

  console.log window.apiLink
  console.log "link"

  $scope.reAfterLoot = () ->
    location.reload()

  $scope.menu = [
    {
      title: 'Dashboard'
      link: '/'
    },
    {
      title: 'Contests',
      link: '/contest'
    },
    {
      title: 'Prizes',
      link: '/prize'
    }
  ]

  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  # $scope.getCurrentUser = Auth.getCurrentUser()

  # $scope.CurrentUser =  Auth.getCurrentUser()

  $scope.logout = ->
    Auth.logout()
    $location.path '/login'

  $scope.isActive = (route) ->
    route is $location.path()

  $scope.getFreeLoot = () ->
    $rootScope.showDailyLoot = true
    $scope.$apply()


  console.log("xxxxxxxxxxx")
  $scope.confirmAds = () ->
    console.log('in confirmAds')
    $rootScope.showDailyLoot=false

    $.ajax
      url: "#{window.apiLink}/v2/user/daily_loot.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        console.log "dailyloot"
        console.log data
        $root.showDailyLoot = false
        return
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "error"
        return

  $scope.getUserProfile = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        unless $scope.user.email
          window.location.href = "/login"
        $rootScope.currentUser = $scope.user
        $scope.$apply()
        $.ajax
          url: "#{window.apiLink}/v2/adverts"
          type: 'GET'
          datatype: 'json'
          success: (data) ->
            if data.data.length > 0
              $rootScope.ads = data.data[0]
              $rootScope.showAds = true

            if $scope.user.free_loot
              $rootScope.showDailyLoot = true
              $scope.$apply()
              $rootScope.$apply()

            return
          error: (jqXHR, textStatus, errorThrown) ->
            console.log "error"
            return

        if $scope.user.promo_code
          $rootScope.showPromocode = true
          $scope.$apply()
          $rootScope.$apply()
          $.ajax
            url: "#{window.apiLink}/v2/user/promo_code.json?token=#{$scope.userToken}"
            type: 'GET'
            datatype: 'json'
            success: (data) ->
              console.log "promocode"
              console.log data
              return
            error: (jqXHR, textStatus, errorThrown) ->
              console.log "error"
              return

      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()
