stocksApp = angular.module('stocksApp', [])


stocksApp.filter 'moneyFilter', ->
  (number) ->
    if not number then '$0.00' else '$' + number


# todo: make the stockname and initial values editable
stocksApp.controller 'StocksController', ($scope, $http) ->

    $scope.add = ->
        $http.post('/api/stocks?stock=' + JSON.stringify($scope.newStock)).then (addedStock) ->
            $scope.stocks.push(addedStock.data)
            resetNewStock()
            refocusForm()

    $scope.remove = (stockName) ->
        $http.delete('/api/stocks?stockName=' + stockName)
        (
            if stock.stockName == stockName
                $scope.stocks.splice(index, 1)
                break
        ) for stock, index in $scope.stocks
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
    alreadyHaveStock = (testStock) -> (return true if stock.stockName == testStock.stockName) for stock in $scope.stocks; false


    $http.get('/api/stocks').then (stocks) -> $scope.stocks = stocks.data
