// Generated by CoffeeScript 1.9.3
(function() {
  var stockApp;

  stockApp = angular.module('stockApp', []);

  stockApp.controller('StockController', function($scope, $http) {
    var adjustTradeNumbers, i, j, ref, resetForm, resetNewEntry, results, results1, updateEntriesList;
    $scope.years = (function() {
      results = [];
      for (var i = 2000, ref = new Date().getFullYear() + 1; 2000 <= ref ? i <= ref : i >= ref; 2000 <= ref ? i++ : i--){ results.push(i); }
      return results;
    }).apply(this);
    $scope.months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    $scope.days = (function() {
      results1 = [];
      for (j = 1; j <= 31; j++){ results1.push(j); }
      return results1;
    }).apply(this);
    updateEntriesList = function() {
      return $http.get('/api/entriesList?stockName=' + $scope.stockName).then(function(entriesList) {
        return $scope.entriesList = entriesList.data;
      });
    };
    resetNewEntry = function() {
      return $scope.newEntry = {
        stockName: $scope.stockName,
        year: new Date().getFullYear(),
        month: new Date().getMonth() + 1,
        day: new Date().getDate(),
        tradeNumber: 1,
        buysell: 'buy',
        price: null,
        commission: 9.99
      };
    };
    resetForm = function() {
      return updateEntriesList().then(function() {
        resetNewEntry();
        adjustTradeNumbers();
        return document.getElementById('newEntryAutofocusElement').focus();
      });
    };
    adjustTradeNumbers = function() {
      $scope.adjustTradeNumber($scope.newEntry);
      return $scope.adjustTradeNumber($scope.editEntry);
    };
    $scope.adjustTradeNumber = function(adjustEntry) {
      var conflictEntries, entry, k, len, ref1, results2;
      if (adjustEntry) {
        conflictEntries = [];
        ref1 = $scope.entriesList;
        for (k = 0, len = ref1.length; k < len; k++) {
          entry = ref1[k];
          if (entry._id !== adjustEntry._id) {
            if (entry.year === adjustEntry.year && entry.month === adjustEntry.month && entry.day === adjustEntry.day) {
              conflictEntries.push(entry.tradeNumber);
            } else if (entry.year > adjustEntry.year && entry.month > adjustEntry.month && entry.day > adjustEntry.day) {
              if (conflictEntries.length === 0 || conflictEntries.indexOf(adjustEntry.tradeNumber) === -1) {
                return;
              }
              break;
            }
          }
        }
        results2 = [];
        while (true) {
          if (conflictEntries.indexOf(adjustEntry.tradeNumber) === -1) {
            break;
          }
          results2.push(adjustEntry.tradeNumber++);
        }
        return results2;
      }
    };
    $scope.add = function() {
      return $http.post('/api/entriesList?entry=' + JSON.stringify($scope.newEntry)).then(function() {
        return resetForm();
      });
    };
    $scope.remove = function(_id) {
      return $http["delete"]('/api/entriesList?_id=' + _id).then(function() {
        return updateEntriesList().then(function() {
          return adjustTradeNumbers();
        });
      });
    };
    $scope.editMode = function(entry) {
      return $scope.editEntry = angular.copy(entry);
    };
    $scope.confirmEdit = function() {
      return $http.put('/api/entriesList?entry=' + JSON.stringify($scope.editEntry)).then(function() {
        $scope.editEntry = null;
        return resetForm();
      });
    };
    $scope.cancelEdit = function() {
      return $scope.editEntry = null;
    };
    return resetForm();
  });

}).call(this);
