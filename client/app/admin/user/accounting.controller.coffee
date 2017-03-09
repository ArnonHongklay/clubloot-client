
angular.module 'clublootApp'
.controller 'AdminUserAccountingCtrl', ($scope, $http, socket) ->
  $scope.menuActive = 'Accounting'

  $scope.history = [
    {id: 1, status: 'plus', gem: 'diamond', name: 'Sapphire', color: 'gem-blue', amount: 'amount'},
    {id: 2, status: 'minus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 3, status: 'plus', gem: 'diamond', name: 'Diamond', color: 'gem-grey', amount: 'amount'},
    {id: 4, status: 'plus', gem: 'diamond', name: 'Emerald', color: 'gem-green', amount: 'amount'},
    {id: 5, status: 'plus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 6, status: 'plus', gem: 'diamond', name: 'Diamond', color: 'gem-grey', amount: 'amount'},
    {id: 7, status: 'plus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 8, status: 'plus', gem: 'diamond', name: 'Sapphire', color: 'gem-blue', amount: 'amount'},
    {id: 9, status: 'plus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 10, status: 'plus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 11, status: 'plus', gem: 'diamond', name: 'Diamond', color: 'gem-grey', amount: 'amount'},
    {id: 12, status: 'plus', gem: 'diamond', name: 'Sapphire', color: 'gem-blue', amount: 'amount'},
    {id: 13, status: 'plus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 14, status: 'minus', gem: 'diamond', name: 'Diamond', color: 'gem-grey', amount: 'amount'},
    {id: 15, status: 'plus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 16, status: 'plus', gem: 'diamond', name: 'Diamond', color: 'gem-grey', amount: 'amount'},
    {id: 17, status: 'minus', gem: 'diamond', name: 'Emerald', color: 'gem-green', amount: 'amount'},
    {id: 18, status: 'plus', gem: 'diamond', name: 'Ruby', color: 'gem-red', amount: 'amount'},
    {id: 19, status: 'plus', gem: 'diamond', name: 'Sapphire', color: 'gem-blue', amount: 'amount'},
  ]
