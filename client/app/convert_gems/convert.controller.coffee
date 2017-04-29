'use strict'

angular.module 'clublootApp'
.controller 'ConvertGemsCtrl', ($scope, $http, socket, $cookieStore, $timeout, gems, $rootScope, Auth) ->
  $scope.showModal = false

  $.ajax
    url: "#{window.apiLink}/v2/user/gems.json"
    type: 'GET'
    datatype: 'json'
    success: (data) ->
      $scope.gems = data.data
    error: (jqXHR, textStatus, errorThrown) ->
      return

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
        $scope.currentGem = {
          diamonds: $scope.user.diamonds, emeralds: $scope.user.emeralds, sapphires: $scope.user.sapphires, rubies: $scope.user.rubies, coins: $scope.user.coins
        }
        $scope.mirorCurrent = $scope.currentGem
        
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()


  
  $scope.titleText = ""
  $scope.alertText = ""

  $scope.convertGem = (type)->
    $(".value-box-added").removeClass('changed')
    rate = 0
    if type == "diamond"
      rate = $scope.gems.diamond.fee
      $scope.titleText = "Convert Emerald to Diamond"
      if $scope.currentGem.emeralds < $scope.gems.diamond.rate
        $scope.alertText  = "You need more Emerald"

    else if type == "emerald"
      rate = $scope.gems.emerald.fee
      $scope.titleText = "Convert Sapphire to Emerald"
      if $scope.currentGem.sapphires < $scope.gems.emerald.rate
        $scope.alertText = "You need more Sapphire"

    else if type == "sapphire"
      rate = $scope.gems.sapphire.fee
      $scope.titleText = "Convert Ruby to Sapphire"
      if $scope.currentGem.rubies < $scope.gems.sapphire.rate
        $scope.alertText = "You need more Ruby"

    if $scope.currentGem.coins < rate
      $scope.alertText = "You need more Coins"

    if $scope.alertText != ""
      swal {
        title: 'Something wrong'
        text: $scope.alertText
        type: 'warning'
        confirmButtonColor: '#50ACC4'
        confirmButtonText: 'OK'
      }, ->
        $scope.alertText = ""
        return
    else
      swal {
        title: 'Are you sure?'
        text: $scope.titleText
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#50ACC4'
        confirmButtonText: 'convert'
        html: false
      }, ->
        $scope.alertText = ""
        $scope.confirmConvert(type)
        return

  $scope.confirmConvert = (type) ->
    coinFee = 0
    gemMinus = 0
    subType = ''
    if type == "diamond"
      subType = "emerald"
      coinFee = $scope.gems.diamond.fee
      $scope.currentGem.diamonds = $scope.currentGem.diamonds + 1
      $scope.currentGem.emeralds = $scope.currentGem.emeralds - $scope.gems.diamond.rate
      $scope.currentGem.coins    = $scope.currentGem.coins - coinFee
      gemMinus = $scope.gems.diamond.rate

    else if type == "emerald"
      subType = "sapphire"
      coinFee = $scope.gems.emerald.fee
      $scope.currentGem.emeralds  = $scope.currentGem.emeralds + 1
      $scope.currentGem.sapphires = $scope.currentGem.sapphires - $scope.gems.emerald.rate
      $scope.currentGem.coins     = $scope.currentGem.coins - coinFee
      gemMinus = $scope.gems.emerald.rate

    else if type == "sapphire"
      subType = "ruby"
      coinFee = $scope.gems.sapphire.fee
      $scope.currentGem.sapphires = $scope.currentGem.sapphires + 1
      $scope.currentGem.rubies    = $scope.currentGem.rubies - $scope.gems.sapphire.rate
      $scope.currentGem.coins     = $scope.currentGem.coins - coinFee
      gemMinus = $scope.gems.sapphire.rate
    $scope.$apply()
    $(".value-box-added."+type+" .num-noti").html("+1")
    $(".value-box-added."+subType+" .num-noti").html("-"+gemMinus)
    $(".value-box-added.coins .num-noti").html("-"+coinFee)

    $(".value-box-added."+type+" .num-noti").addClass("plus show")
    $(".value-box-added."+subType+" .num-noti").addClass("minus show")
    $(".value-box-added.coins .num-noti").addClass("minus show")

    $(".value-box-added."+type).addClass('changed')
    $(".value-box-added."+type).addClass('shake-rotate shake-constant')
    $timeout ->
      $(".value-box-added."+type).removeClass('shake-rotate shake-constant')
    , 1000
    $timeout ->
      $(".value-box-added.coins .num-noti").removeClass("minus show")
      $(".value-box-added."+type).removeClass('changed')
      $(".value-box-added."+type+" .num-noti").removeClass("plus show")
      $(".value-box-added."+subType+" .num-noti").removeClass("minus show")
    , 2000

    $.ajax
      url: "#{window.apiLink}/v2/user/convert_gem.json"
      type: 'POST'
      datatype: 'json'
      data: {
        token: $scope.userToken
        type: type
      }
      success: (data) ->
        return
      error: (jqXHR, textStatus, errorThrown) ->
        return

  $scope.goDashboard = () ->
    window.location.href = "/dashboard"
