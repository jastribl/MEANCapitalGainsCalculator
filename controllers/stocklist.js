// Generated by CoffeeScript 1.9.3
(function() {
  var Entries, StockList, controller, express;

  express = require('express');

  controller = express.Router();

  StockList = require('../models/StockList');

  Entries = require('../models/Entries');

  controller.get('/stocklist', function(req, res) {
    return StockList.getStockListOrdered().then(function(stockList) {
      var options;
      options = {
        stocklist: stockList,
        liveEditStock: req.session.liveEditStock ? req.session.liveEditStock : void 0
      };
      req.session.reset();
      return res.render('stocklist', options);
    });
  });

  controller.post('/addstock', function(req, res) {
    var stock;
    stock = req.body;
    stock.stockname = stock.stockname.toUpperCase();
    return StockList.doesStockExit(stock).then(function(stockExists) {
      if (stockExists) {
        req.session.liveEditStock = stock;
        return res.redirect('/stocklist');
      } else {
        if (!stock.number) {
          stock.number = 0;
        }
        if (!stock.acb) {
          stock.acb = 0;
        }
        StockList.addStock(stock);
        return res.redirect('/stocklist');
      }
    });
  });

  controller.post('/deletestock', function(req, res) {
    var stock;
    stock = req.body;
    return Entries.removeAllEntriesForStockWithName(stock.stockname).then(function() {
      StockList.removeStock(stock).then(function() {});
      return res.redirect('/stocklist');
    });
  });

  module.exports = controller;

}).call(this);
