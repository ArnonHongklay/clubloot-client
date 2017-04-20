'use strict'

angular.module 'clublootApp'
.controller 'NavbarCtrl', ($scope, $location, Auth, $http, $rootScope, $cookieStore, $timeout, socket, $cable) ->
  $scope.socket = socket.socket
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
  
  $scope.userToken = $cookieStore.get 'token'
  unless $scope.userToken
    window.location.href = '/login'
  


  $scope.getUserProfile = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        console.log data
        $scope.user = data.data
        console.log $scope.user
        console.log "-0-0-0-0-0-00-"
        unless $scope.user.email
          window.location.href = "/login"
        $rootScope.currentUser = $scope.user
        $scope.$apply()
        $.ajax
          url: "#{window.apiLink}/v2/adverts"
          type: 'GET'
          datatype: 'json'
          success: (data) ->
            console.log "adword"
            console.log data
            if data.data.length > 0
              $rootScope.ads = data.data[0]
              console.log "---==="
              $rootScope.showAds = true
              $scope.$apply()
              console.log data

            if $scope.user.free_loot
              $rootScope.showDailyLoot = true
              $.ajax
                url: "#{window.apiLink}/v2/user/daily_loot.json?token=#{$scope.userToken}"
                type: 'GET'
                datatype: 'json'
                success: (data) ->
                  console.log "dailyloot"
                  console.log data
                  return
                error: (jqXHR, textStatus, errorThrown) ->
                  console.log "error"
                  return
            return
          error: (jqXHR, textStatus, errorThrown) ->
            console.log "error"
            return


        

        if $scope.user.promo_code
          $rootScope.showPromocode = true
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


  



        
  # $timeout ->
  #   if Auth.getCurrentUser()
  #     $http.get("/api/users/#{Auth.getCurrentUser()._id}").success (data) ->
  #       # console.log data
  #       $scope.getFreeLoot() if data.free_loot
  # , 300
