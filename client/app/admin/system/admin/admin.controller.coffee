angular.module 'clublootApp'
.controller 'AdminSystemAdminCtrl', ($scope, $http, Auth, $state, users, admins, masters) ->

  console.log users
  console.log admins
  $scope.users = users.data
  $scope.admins = admins.data
  $scope.masters = masters.data

  $scope.isMaster = Auth.getCurrentUser().role == 'master'
  console.log $scope.isMaster
  $scope.setRole = (user_id, role) ->
    $http.post("/api/users/#{user_id}/edit_role",
      {
        role: role
      }
    ).success((ok) ->

    ).error((data, status, headers, config) ->
      swal("Not Active")
    )