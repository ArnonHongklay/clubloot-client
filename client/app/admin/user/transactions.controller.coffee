
angular.module 'clublootApp'
.controller 'AdminUserTransactionsCtrl', ($scope, $http, socket, transactions, $modal) ->
  $scope.menuActive = 'Transactions'
  $scope.ledgers    = transactions.data

  $scope.transactionDetail = (ledger, transaction)->
    $modal.open(
      templateUrl: 'ModalTransactionsCtrl.html'
      controller: 'ModalTransactionsCtrl'
      resolve:
        ledgers: ($http, $stateParams) ->
          return ledger
        transaction: ($http, $stateParams) ->
          return transaction
    )

.controller 'ModalTransactionsCtrl', ($scope, $http, socket, ledgers, transaction) ->
  $scope.ledgers      = ledgers
  $scope.transaction  = transaction
