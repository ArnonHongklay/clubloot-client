angular.module 'clublootApp'
.controller 'AdminSystemLedgerCtrl', ($scope, $http, socket, $state, ledgers, $window) ->
  $scope.ledgers = ledgers.data

  $('.datetimepicker').datetimepicker()

  $scope.selectLedger = (lad) ->
    $scope.showLedgerModal = lad

  today = moment(new Date()).format("YYYY/M/D")
  $scope.filterDate = {from: today, to: today}

  $scope.filterToday = () ->
    $scope.filterDate = {from: today, to: today}
    $scope.getDataByDate()

  $scope.getDataByDate = () ->
    f = $scope.filterDate.from
    t = $scope.filterDate.to

    fp = new Date('2000')

    $http.post("/api/ledgers/by_date",
      { fr: f, to: t }
    ).success (data, status, headers, config) ->
      console.log data
      $scope.ledgers = data

  $scope.gotoUser = (id) ->
    $window.location.href = "/admin/user/#{id}/transactions"
