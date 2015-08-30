stockListApp = angular.module('stockListApp', [])


stockListApp.controller 'StockListController', ($scope, $http) ->

    updateStockList = ->
        $http.get('/api/stockList').then (stockList) ->
            $scope.stockList = stockList.data

    resetNewStock = ->
        $scope.newStock = {
            stockName: null
            number: null
            acb: null
        }

    $scope.reserError = ->
        $scope.error = null

    resetForm = ->
        updateStockList()
        resetNewStock()
        $scope.reserError()

    $scope.remove = (stockName) ->
        $http.delete('/api/stockList?stockName=' + stockName).then ->
            updateStockList()

    $scope.add = ->
        $http.get('/api/stockList/stockExists?stock=' + JSON.stringify($scope.newStock)).then (stockExists) ->
            if stockExists.data
                $scope.error = 'You already have this stock!'
            else
                $http.post('/api/stockList/add?stock=' + JSON.stringify($scope.newStock)).then (res) ->
                    resetForm()


    resetForm()