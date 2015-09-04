stockListApp = angular.module('stockListApp', [])


stockListApp.controller 'StockListController', ($scope, $http) ->

    updateStockList = ->
        $http.get('/api/stockList').then (stockList) ->
            $scope.stockList = stockList.data

    resetForm = ->
        updateStockList().then ->
            $scope.validate()
            $scope.newStock = {}
            $scope.errors = []

    refocusForm = -> $('#newStockAutofocusElement').focus()

    $scope.remove = (stockName) ->
        $http.delete('/api/stockList?stockName=' + stockName).then ->
            updateStockList().then ->
                $scope.validate()
                refocusForm()

    $scope.add = ->
        $http.post('/api/stockList?stock=' + JSON.stringify($scope.newStock)).then ->
            resetForm()
            refocusForm()

    $scope.validate = ->
        if $scope.newStock
            newStock = $scope.newStock
            $scope.errors = []
            if newStock.stockName
                stockList = $scope.stockList

                (
                    if stock.stockName == newStock.stockName.toUpperCase()

                        $scope.errors.push('You already have this stock!')
                        break
                ) for stock in stockList
            if (if newStock.number then !newStock.acb else newStock.acb)
                $scope.errors.push('You must either fill out both the number and the acb or leave both blank!')

    $scope.validStock = (stock) ->
        return false if not stock
        return (!stock.stockName)

    resetForm()