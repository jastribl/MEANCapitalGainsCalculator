stockListApp = angular.module('stockListApp', [])


stockListApp.filter 'moneyFilter', ->
  (number) ->
    if not number then '$0.00' else '$' + number


stockListApp.controller 'StockListController', ($scope, $http) ->

    $scope.add = ->
        $http.post('/api/stockList?stock=' + JSON.stringify($scope.newStock)).then (addedStock) ->
            $scope.stockList.push(addedStock.data)
            resetNewStock()
            refocusForm()

    $scope.remove = (stockName) ->
        $http.delete('/api/stockList?stockName=' + stockName)
        (
            if stock.stockName == stockName
                $scope.stockList.splice(index, 1)
                break
        ) for stock, index in $scope.stockList
        $scope.validate($scope.newStock)
        refocusForm()
        return

    $scope.validate = (stock) ->
        resetErrors()
        return false if not (stock and stock.stockName)
        $scope.errors.push('You already have this stock!') if alreadyHaveStock(stock)
        $scope.errors.length == 0

    resetErrors = -> $scope.errors = []
    resetNewStock = -> $scope.newStock = {}
    refocusForm = -> $('#newStockAutofocusElement').focus()
    alreadyHaveStock = (testStock) -> (return true if stock.stockName == testStock.stockName) for stock in $scope.stockList; false


    $http.get('/api/stockList').then (stockList) -> $scope.stockList = stockList.data
