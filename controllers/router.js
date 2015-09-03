// Generated by CoffeeScript 1.9.3
(function() {
  var StockList, api, express, router;

  express = require('express');

  router = express.Router();

  api = require('./api');

  StockList = require('../models/StockList');

  router.use(api);

  router.get('/stocklist', function(req, res) {
    return res.render('stocklist', {
      title: 'Stock List'
    });
  });

  router.get('/stock', function(req, res) {
    var stockName;
    stockName = req.query.stockName.toUpperCase();
    return StockList.doesStockWithNameExist(stockName).then(function(stockExists) {
      var error;
      if (stockExists) {
        return res.render('stock', {
          title: stockName
        });
      } else {
        error = {
          status: 404,
          message: 'You have attemped to gain access to stock \'' + stockName + '\'\n But you do not have that stock!'
        };
        return res.render('error', {
          error: error
        });
      }
    });
  });

  router.get('/debug', function(req, res) {
    return res.render('debug', {
      title: 'Debug'
    });
  });

  router.get('*', function(req, res) {
    return res.render('index', {
      title: 'Stock Application'
    });
  });

  module.exports = router;

}).call(this);
