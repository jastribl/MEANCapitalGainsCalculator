debugApp = angular.module('debugApp', [])


debugApp.filter 'moneyFilter', ->
    (number) ->
        if not number then '$0.00' else '$' + number


debugApp.controller 'StocksController', ($scope, $http) ->
    $http.get('/api/stocks').then (stocks) ->
        $scope.stocks = stocks.data


debugApp.controller 'EntriesListController', ($scope, $http) ->
    $http.get('/api/entriesList').then (entriesList) ->
        $scope.entriesList = entriesList.data
