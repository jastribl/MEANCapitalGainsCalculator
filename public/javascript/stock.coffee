stockApp = angular.module('stockApp', [])


stockApp.controller 'StockController', ($scope, $http) ->

    $scope.editId = null

    $scope.years = [2000..new Date().getFullYear() + 1]
    $scope.months = [1..12]
    $scope.days = [1..31]


    updateEntriesList = ->
        $http.get('/api/entriesList?stockName=' + $scope.stockName).then (entriesList) ->
            $scope.entriesList = entriesList.data

    resetNewEntry = ->
        $scope.newEntry  = {
            stockName: $scope.stockName
            year: new Date().getFullYear()
            month: new Date().getMonth() + 1
            day: new Date().getDate()
            tradeNumber: 1
            buysell: 'buy'
            price: null
            commission: 9.99
        }

    resetError = ->
        $scope.error = null

    resetForm = ->
        updateEntriesList()
        resetNewEntry()
        resetError()
        $scope.adjustTradeNumber()

    $scope.adjustTradeNumber = ->
        $http.get('/api/entriesList/countMatching?entry=' + JSON.stringify($scope.newEntry)).then (res) ->
            if res.data != 0
                $scope.newEntry.tradeNumber++
                $scope.adjustTradeNumber()

    $scope.add = ->
        $http.post('/api/entriesList?entry=' + JSON.stringify($scope.newEntry)).then ->
            resetForm()

    $scope.remove = (_id) ->
        $http.delete('/api/entriesList?_id=' + _id).then ->
            updateEntriesList().then ->
                $scope.adjustTradeNumber()

    $scope.editMode = (_id) ->
        console.log _id

    $scope.edit = (_id) ->
        console.log _id


    resetForm()