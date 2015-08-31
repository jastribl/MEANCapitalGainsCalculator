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

  api["delete"]('/api/stockList', function(req, res) {
    var stockName;
    stockName = req.query.stockName;
    return StockList.deleteStockWithName(stockName).then(function() {
      return Entries.deleteAllEntriesForStockWithName(stockName).then(function() {
        return res.sendStatus(200);
      });
    });
  });

  api.get('/api/stockList/stockExists', function(req, res) {
    var stock;
    stock = JSON.parse(req.query.stock);
    return StockList.doesStockWithNameExist(stock.stockName.toUpperCase()).then(function(stockExists) {
      var response;
      response = {
        stockExists: stockExists,
        error: stockExists ? 'You already have this stock!' : void 0
      };
      return res.json(response);
    });
  });

  api.post('/api/stockList', function(req, res) {
    var stock;
    stock = JSON.parse(req.query.stock);
    stock.stockName = stock.stockName.toUpperCase();
    if (!stock.number) {
      stock.number = 0;
    }
    if (!stock.number) {
      stock.acb = 0;
    }
    return StockList.addStock(stock).then(function() {
      return res.sendStatus(200);
    });
  });

  api.get('/api/entriesList', function(req, res) {
    var stockName;
    stockName = req.query.stockName;
    if (stockName) {
      return Entries.getEntriesForStockOrdered(stockName).then(function(entriesList) {
        return res.json(entriesList);
      });
    } else {
      return Entries.getAllEntriesOrdered().then(function(entriesList) {
        return res.json(entriesList);
      });
    }
  });

  api.get('/api/entriesList/countMatching', function(req, res) {
    var entry;
    entry = JSON.parse(req.query.entry);
    return Entries.getEntryCountMatchingData(entry).then(function(count) {
      return res.json(count);
    });
  });

  api.post('/api/entriesList', function(req, res) {
    var entry;
    entry = JSON.parse(req.query.entry);
    return Entries.addEntry(entry).then(function() {
      return res.sendStatus(200);
    });
  });

  api["delete"]('/api/entriesList', function(req, res) {
    var _id;
    _id = req.query._id;
    return Entries.removeEntryById(_id).then(function() {
      return res.sendStatus(200);
    });
  });

  module.exports = api;

}).call(this);
