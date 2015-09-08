// Generated by CoffeeScript 1.9.3
(function() {
  var debugApp;

  debugApp = angular.module('debugApp', []);

  debugApp.filter('moneyFilter', function() {
    return function(number) {
      if (!number) {
        return '$0.00';
      } else {
        return '$' + number;
      }
    };
  });

  debugApp.controller('StockListController', function($scope, $http) {
    return $http.get('/api/stockList').then(function(stockList) {
      return $scope.stockList = stockList.data;
    });
  });

  debugApp.controller('EntriesListController', function($scope, $http) {
    return $http.get('/api/entriesList').then(function(entriesList) {
      return $scope.entriesList = entriesList.data;
    });
  });

}).call(this);
