stockApp = angular.module('stockApp', [])


stockApp.filter 'moneyFilter', ->
  (number) ->
    '$' + number


stockApp.controller 'StockController', ($scope, $http) ->

    $scope.years = [2000..new Date().getFullYear() + 1]
    $scope.months = [1..12]
    $scope.days = [1..31]


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

    $scope.validEntry = (entry) ->
        return false if not entry
        return (!entry.tradeNumber || !entry.quantity || !entry.price || !entry.commission)

    $scope.add = ->
        $http.post('/api/entriesList?entry=' + JSON.stringify($scope.newEntry)).then (addedEntry) ->
            addEntry(addedEntry.data)
            resetForm()
            refocusForm()

    $scope.remove = (_id) ->
        $http.delete('/api/entriesList?_id=' + _id)
        removeEntryById(_id)
        adjustTradeNumbers()
        refocusForm()
        return

    $scope.editMode = (entry) -> $scope.editEntry = angular.copy(entry)

    $scope.confirmEdit = ->
        $http.post('/api/entriesList/updateEntry?entry=' + JSON.stringify($scope.editEntry)).then (updatedEntry) ->
            removeEntryById(updatedEntry.data._id)
            addEntry(updatedEntry.data)
            delete $scope.editEntry
            refocusForm()

    $scope.cancelEdit = ->
        delete $scope.editEntry
        refocusForm()

    addEntry = (entry) ->
        $scope.entriesList.push(entry)

    removeEntryById = (_id) ->
        (
            if entry._id == _id
                $scope.entriesList.splice(index, 1)
                break
        ) for entry, index in $scope.entriesList
        return

    resetForm = ->
        adjustTradeNumbers()
        delete $scope.newEntry.price
        delete $scope.newEntry.quantity

    refocusForm = -> $('#newEntryAutofocusElement').focus()

    adjustTradeNumbers = -> $scope.adjustTradeNumber($scope.newEntry); $scope.adjustTradeNumber($scope.editEntry)


    $http.get('/api/entriesList?stockName=' + $scope.stockName).then (entriesList) ->
        $scope.entriesList = entriesList.data
        $scope.newEntry = {
            stockName: $scope.stockName
            year: new Date().getFullYear()
            month: new Date().getMonth() + 1
            day: new Date().getDate()
            tradeNumber: 1
            buysell: 'buy'
            commission: 9.99
        }
        adjustTradeNumbers()
        refocusForm()
