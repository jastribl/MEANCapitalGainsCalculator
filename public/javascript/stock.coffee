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
        updateEntriesList().then ->
            resetNewEntry()
            resetError()
            $scope.adjustTradeNumber()
            document.getElementById('newEntryAutofocusElement').focus()

    $scope.adjustTradeNumber = ->
        conflictEntries = []
        (
            if testEntry.year == $scope.newEntry.year and testEntry.month == $scope.newEntry.month and testEntry.day == $scope.newEntry.day
                conflictEntries.push(testEntry.tradeNumber)
            else if testEntry.year > $scope.newEntry.year and testEntry.month > $scope.newEntry.month and testEntry.day > $scope.newEntry.day
                return if conflictEntries.length == 0 or conflictEntries.indexOf($scope.newEntry.tradeNumber) == -1
                break
        ) for testEntry in $scope.entriesList
        while true
            break if conflictEntries.indexOf($scope.newEntry.tradeNumber) == -1
            $scope.newEntry.tradeNumber++
        return

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