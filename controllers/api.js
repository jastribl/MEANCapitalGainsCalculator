// Generated by CoffeeScript 1.9.3
(function() {
  var Entries, StockList, api, express;

  express = require('express');

  api = express.Router();

  StockList = require('../models/StockList');

  Entries = require('../models/Entries');

  api.get('/api/stockList', function(req, res) {
    return StockList.getStockListOrdered().then(function(stockList) {
      return res.json(stockList);
    });
  });

  api.get('/api/entriesList', function(req, res) {
    return Entries.getAllEntriesOrdered().then(function(entriesList) {
      return res.json(entriesList);
    });
  });

  module.exports = api;

}).call(this);
