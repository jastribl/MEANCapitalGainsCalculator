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

    $scope.validate = (stock) ->
        if stock
            $scope.errors = []
            $scope.errors.push('You must enter a name!') if not stock.stockName and (stock.number || stock.acb)
            $scope.errors.push('You already have this stock!') if stock.stockName and alreadyHaveStock(stock)
            $scope.errors.push('You must either fill out both the number and the acb!') if (if stock.number then !stock.acb else stock.acb)


    alreadyHaveStock = (testStock) ->
        (
            return true if stock.stockName == testStock.stockName.toUpperCase()
        ) for stock in $scope.stockList
        return false

    $scope.validStock = (stock) ->
        return false if not stock
        return (!stock.stockName)

    resetForm()

stockListApp.filter 'moneyFilter', ->
  (number) ->
    '$' + number
