stockApp = angular.module('stockApp', [])


stockApp.controller 'StockController', ($scope, $http) ->


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

    resetForm = ->
        $scope.editId = null
        updateEntriesList().then ->
            resetNewEntry()
            adjustTradeNumbers()
            document.getElementById('newEntryAutofocusElement').focus()

    adjustTradeNumbers = ->
        $scope.adjustTradeNumber($scope.newEntry)
        $scope.adjustTradeNumber($scope.editEntry)


    $scope.adjustTradeNumber = (adjustEntry) ->
        if adjustEntry
            conflictEntries = []
            (
                if entry._id != adjustEntry._id
                    if entry.year == adjustEntry.year and entry.month == adjustEntry.month and entry.day == adjustEntry.day
                        conflictEntries.push(entry.tradeNumber)
                    else if entry.year > adjustEntry.year and entry.month > adjustEntry.month and entry.day > adjustEntry.day
                        return if conflictEntries.length == 0 or conflictEntries.indexOf(adjustEntry.tradeNumber) == -1
                        break
            ) for entry in $scope.entriesList
            while true
                break if conflictEntries.indexOf(adjustEntry.tradeNumber) == -1
                adjustEntry.tradeNumber++

    $scope.add = ->
        $http.post('/api/entriesList?entry=' + JSON.stringify($scope.newEntry)).then ->
            resetForm()

    $scope.remove = (_id) ->
        $http.delete('/api/entriesList?_id=' + _id).then ->
            updateEntriesList().then ->
                adjustTradeNumbers()

    $scope.editMode = (entry) ->
        $scope.editEntry = angular.copy(entry)

    $scope.confirmEdit = ->
        $scope.editEntry = null

    $scope.cancelEdit = ->
        $scope.editEntry = null


    resetForm()