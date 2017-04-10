angular.module 'clublootApp'
.controller 'AdminSystemAnnouncementsCtrl', ($scope, Auth, $http, $state, messages) ->
  $('.datetimepicker').datetimepicker()
  $scope.newMessage = {message:'', publish_time:'', postBy:''}

  $scope.messages = messages.data

  $scope.checkTime = (message) ->
    new Date(message.publish_time) > new Date()

  $scope.saveMessage = () ->
    return if $scope.newMessage.message == ''
    return if $scope.newMessage.publish_time == ''
    $scope.newMessage.publish_time = new Date($scope.newMessage.publish_time)
    $scope.newMessage.postBy = Auth.getCurrentUser().email
    $http.post("/api/broadcast",
      $scope.newMessage
    ).success((data, status, headers, config) ->
      $scope.messages.unshift(data)
      $scope.newMessage = {message:'', publish_time:'', postBy:''}
      swal("Announcements created")
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )


  $scope.checkTextLenght = () ->
    if $scope.newMessage.message.length >= 400
      $scope.newMessage.message = $scope.newMessage.message.substring(0, 400)
