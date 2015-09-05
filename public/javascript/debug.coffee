debugApp = angular.module('debugApp', [])


debugApp.controller 'StockListController', ($scope, $http) ->
    $http.get('/api/stockList').then (stockList) ->
        $scope.stockList = stockList.data


debugApp.controller 'EntriesListController', ($scope, $http) ->
    $http.get('/api/entriesList').then (entriesList) ->
        $scope.entriesList = entriesList.data
