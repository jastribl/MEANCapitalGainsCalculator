stockListApp = angular.module('stockListApp', [])


stockListApp.controller 'StockListController', ($scope, $http) ->

    updateStockList = ->
        $http.get('/api/stockList').then (stockList) ->
            $scope.stockList = stockList.data

    resetNewStock = ->
        $scope.newStock = {}

    resetError = ->
        $scope.error = null

    resetForm = ->
        updateStockList()
        resetNewStock()
        resetError()

    $scope.remove = (stockName) ->
        $http.delete('/api/stockList?stockName=' + stockName).then ->
            updateStockList()
            $scope.validate()

    $scope.add = ->
        $http.post('/api/stockList?stock=' + JSON.stringify($scope.newStock)).then ->
            resetForm()

    $scope.validate = ->
        stockList = $scope.stockList
        newStock = $scope.newStock
        entryIsValid = true
        (
            if stock.stockName == newStock.stockName.toUpperCase()
                $scope.error = 'You already have this stock!'
                entryIsValid = false
                break
        ) for stock in stockList
        resetError() if entryIsValid


    resetForm()