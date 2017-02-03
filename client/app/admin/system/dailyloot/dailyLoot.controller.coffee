angular.module 'clublootApp'
.controller 'AdminSystemDailyLootCtrl', ($scope, $http, $state, signinCounts, winnerLogs, allWinnerLogs) ->
# console.log signinCounts
# console.log winnerLogs
  $scope.signinCounts = signinCounts.data.length
  # $scope.todayClaimed = winnerLogs.data
  $scope.allClaimed = allWinnerLogs.data
  $scope.lootClaimed = 0
  $scope.todayClaimed = []
  $scope.todayClaimedList = []
  $scope.claimedName = []

  $scope.data = [ {
    'key': 'Quantity'
    'bar': true
    'values': [
    ]
  } ]
  $scope.data[0].values = []
  for claimed in $scope.allClaimed
    $scope.data[0].values.push [new Date(claimed.created_at).getTime(), claimed.prize]

  f = new Date()
  t = new Date()

  $http.post("/api/v2/dashboard/allloot_by_date", {fr: f, to: t }).success (data, status, headers, config) ->
    allClaimed = 0
    for ca in data
      if ca.format == "loot"
        for t in ca.transaction
          if t.action == "plus"
            if t.unit == "coins"
              coin = t.amount
            else if t.unit == "rubies"
              coin = t.amount*100
            else if t.unit == "sapphires"
              coin = t.amount*500
            else if t.unit == "emeralds"
              coin = t.amount*2500
            else if t.unit == "diamonds"
              coin = t.amount*12500
            allClaimed = allClaimed + coin
            $scope.todayClaimed.push({user: ca.user, amount: coin})

    $scope.lootClaimed = allClaimed

  $scope.options = chart:
    type: 'historicalBarChart'
    height: 350
    margin:
      top: 20
      right: 20
      bottom: 65
      left: 50
    x: (d) ->
      d[0]
    y: (d) ->
      d[1] / 100000
    showValues: true
    valueFormat: (d) ->
      d3.format(',.1f') d
    duration: 100
    xAxis:
      axisLabel: 'X Axis'
      tickFormat: (d) ->
        d3.time.format('%x') new Date(d)
      rotateLabels: 30
      showMaxMin: false
    yAxis:
      axisLabel: 'Y Axis'
      axisLabelDistance: -10
      tickFormat: (d) ->
        d3.format(',.1f') d
    tooltip: keyFormatter: (d) ->
      d3.time.format('%x') new Date(d)
    zoom:
      enabled: true
      scaleExtent: [
        1
        10
      ]
      useFixedDomain: false
      useNiceScale: false
      horizontalOff: false
      verticalOff: true
      unzoomEventType: 'dblclick.zoom'
