'use strict'

angular.module 'clublootApp'
.controller 'ContestVsCtrl', ($scope, $http, Auth, $state, $cable, $stateParams, $rootScope, $timeout, $cookieStore) ->
  $scope.ansList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"]

  $scope.setData = () ->
    $.ajax
      url: "#{window.apiLink}/v2/contests/contest.json?contest_id=#{$stateParams.contest_id}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.contest = data.data
        $scope.contestPrize = data.data

        for player in $scope.contest.leaders
          if player.id.$oid == $scope.user.id.$oid
            $scope.playerMe = player
          if player.id.$oid == $stateParams.user_id
            $scope.playerVs = player
          if player.id.$oid == $scope.user.id.$oid
            $scope.alreadyJoin = true
        $scope.$apply()
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.setData()
        , 2000
        return

  $scope.outHover = () ->
    $scope.hoverAnswer = null

  $scope.showDetail = (index, who, event) ->
    console.log index
    console.log event
    # y = $(event.currentTarget)[0].offsetTop
    # x = $(event.currentTarget)[0].offsetLeft
    x = event.pageX
    y = event.pageY
    user_answer = $scope.checkIndex(index, who)
    ansIndex = $scope.ansList.indexOf(user_answer)
    $scope.hoverAnswer = $scope.contest.template.questions[index].answers[ansIndex]
    console.log $scope.hoverAnswer
    $timeout ->
      $('.answer-pop-box').css("top", y-20+"px")
      $('.answer-pop-box').css("left", x+40+"px")
    , 50
    


  $scope.checkIndex = (index, user) ->
    answers = $scope.contest.template.questions[index].answers
    if user == 'me'
      return "" unless $scope.playerMe
      return "" if $scope.playerMe.quizes.length == 0
      return "" unless $scope.playerMe.quizes[index]
      ans_id = $scope.playerMe.quizes[index].answer_id
    if user == 'vs'
      return "" unless $scope.playerVs
      return "" if $scope.playerVs.quizes.length == 0
      return "" unless $scope.playerVs.quizes[index]
      ans_id = $scope.playerVs.quizes[index].answer_id
    for ans, i in answers
      if ans._id.$oid == ans_id
        return $scope.ansList[i]


  $scope.cancelVs = () ->
    $state.go('^')

  $scope.userToken = $cookieStore.get 'token'
  $scope.getUserProfile = () ->
    $.ajax
      url: "#{window.apiLink}/v2/user/profile.json?token=#{$scope.userToken}"
      type: 'GET'
      datatype: 'json'
      success: (data) ->
        $scope.user = data.data
        $scope.$apply()
        $scope.cable = $cable(window.socketLink)
        $scope.channel = $scope.cable.subscribe('ContestChannel', received: (data) ->
          if typeof(data) == "undefined"
            $scope.setData()
            return
          if data.page == "contest_details"
            $scope.setData()
            return
          
          return
        )
      error: (jqXHR, textStatus, errorThrown) ->
        $timeout ->
          $scope.getUserProfile()
        , 2000

  if $scope.userToken
    $scope.getUserProfile()

  
