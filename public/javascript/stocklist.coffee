stockListApp = angular.module('stockListApp', [])


stockListApp.controller 'StockListController', ($scope, $http) ->

    $scope.updateStockList = ->
        $http.get('/api/stockList').then (stockList) ->
            $scope.stockList = stockList.data

    $scope.remove = (stockName) ->
        $http.delete('/api/stockList?stockName=' + stockName).then ->
            $scope.updateStockList()


    $scope.updateStockList()