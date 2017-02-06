angular.module 'clublootApp'
.controller 'AdminSystemCtrl', ($scope, $http, socket, $state) ->
  $scope.menus = [
    { name: "Announcements", state: 'announcements' , title: 'New Announcement'},
    { name: "Daily Loot",    state: 'dailyLoot' ,     title: '' }
    { name: "Programming",   state: 'programming' ,   title: '' },
    { name: "Ledger",        state: 'ledger' ,        title: '' },
    { name: "Prizes",        state: 'prizes' ,        title: '' },
    { name: "Taxes",         state: 'taxes' ,         title: '' },
    { name: "Gems",          state: 'gems' ,          title: '' },
    { name: "Users",         state: 'users' ,         title: '' },
    { name: "Winners",       state: 'winners' ,         title: '' },
    { name: "Free loot",     state: 'freeloot' ,      title: '' },
    { name: "Subscribe",     state: 'subscribe' ,      title: '' }
  ]
  $scope.systemTab  = $scope.menus[0]

  $scope.changeMenu = (index) ->
    return if $scope.systemTab.state == $scope.menus[index].state
    $scope.systemTab = $scope.menus[index]
    $state.go("AdminSystem.#{$scope.systemTab.state}")
