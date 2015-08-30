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
        if $scope.newStock.stockName
            $http.get('/api/stockList/stockExists?stock=' + JSON.stringify($scope.newStock)).then (res) ->
                if res.data.stockExists
                    $scope.error = res.data.error
        resetError()


    resetForm()