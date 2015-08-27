// Generated by CoffeeScript 1.9.3
(function() {
  var Entries, StockList, controller, express, insertAndReCalculate;

  express = require('express');

  controller = express.Router();

  Entries = require('../models/Entries');

  StockList = require('../models/StockList');

  controller.get('/stock', function(req, res) {
    var editEntry, isEdit, liveEntry, stockname;
    stockname = req.query.stockname.toUpperCase();
    isEdit = req.session.editEntry;
    liveEntry = req.session.liveEntry ? req.session.liveEntry : {};
    editEntry = isEdit ? req.session.editEntry : {};
    req.session.reset();
    return StockList.doesStockWithNameExist(stockname).then(function(stockExists) {
      var editId, error;
      if (stockExists) {
        editId = isEdit ? editEntry._id : false;
        return Entries.getEntriesForStockOrdered(stockname).then(function(entries) {
          entries.stockname = stockname;
          return res.render('stock', {
            entries: entries,
            liveEntry: liveEntry,
            editEntry: editEntry,
            editId: editId
          });
        });
      } else {
        error = {
          status: '404',
          stack: 'You have attemped to gain access to stock \'' + stockname + '\'\n But you do not have that stock!'
        };
        return res.render('error', {
          error: error
        });
      }
    });
  });

  controller.post('/addentry', function(req, res) {
    var liveEntry;
    liveEntry = req.body;
    return Entries.getEntryCountMatchingData(liveEntry).then(function(count) {
      if (count === 0) {
        insertAndReCalculate(liveEntry);
      } else {
        req.session.liveEntry = liveEntry;
      }
      return res.redirect('/stock?stockname=' + liveEntry.stockname);
    });
  });

  controller.post('/editmode', function(req, res) {
    var editEntry;
    editEntry = req.body;
    req.session.editEntry = editEntry;
    return res.redirect('/stock?stockname=' + editEntry.stockname);
  });

  controller.post('/editentry', function(req, res) {
    var entry;
    entry = req.body;
    return Entries.getEntryById(entry._id).then(function(oldEntry) {
      return Entries.getEntryWithMatchingTimeData(entry).then(function(conflictEntry) {
        if (conflictEntry && conflictEntry._id.toString() === entry._id.toString()) {
          Entries.removeEntry(oldEntry).then(function() {
            return insertAndReCalculate(entry);
          });
        } else {
          req.session.editEntry = oldEntry;
        }
        return res.redirect('/stock?stockname=' + entry.stockname);
      });
    });
  });

  controller.post('/canceledit', function(req, res) {
    var stockname;
    stockname = req.body.stockname;
    return res.redirect('stock?stockname=' + stockname);
  });

  controller.post('/deleteentry', function(req, res) {
    var entry, stockname;
    entry = req.body;
    stockname = entry.stockname;
    return Entries.removeEntry(entry).then(function() {
      return res.redirect('stock?stockname=' + stockname);
    });
  });

  module.exports = controller;

  insertAndReCalculate = function(newEntry) {
    var stockname;
    Entries.insertEntry(newEntry);
    stockname = newEntry.stockname;
    return Entries.getEntriesForStockOrdered(stockname).then(function(entries) {
      return StockList.getStockByName(stockname).then(function(initialValues) {
        var lastEntry, ref;
        lastEntry = {
          quanity: initialValues.number,
          totalshares: initialValues.number,
          acbperunit: (ref = initialValues.number === 0) != null ? ref : {
            0: initialValues.acb / initialValues.number
          },
          acbtotal: initialValues.acb
        };
        return Entries.deleteAllEntriesForStockWithName(stockname).then(function() {
          return entries.forEach(function(entry) {
            if (entry.buysell === 'buy') {
              entry.totalshares = +lastEntry.totalshares + +entry.quanity;
              entry.acbtotal = +lastEntry.acbtotal + (+entry.price * +entry.quanity) + +entry.commission;
              entry.acbperunit = +entry.acbtotal / +entry.totalshares;
            } else if (entry.buysell === 'sell') {
              entry.totalshares = +lastEntry.totalshares - +entry.quanity;
              if (entry.totalshares < 0) {
                entry.problem = true;
              }
              if (entry.totalshares === 0) {
                entry.acbtotal = 0;
                entry.acbperunit = 0;
              } else {
                entry.acbtotal = +lastEntry.getACBTotal - (+entry.quanity * +lastEntry.acbtotal / +lastEntry.totalshares);
                entry.acbperunit = +entry.acbtotal / +entry.totalshares;
              }
              entry.capitalgainloss = ((+entry.price * +entry.quanity) - +entry.commission) - (+lastEntry.acbperunit * +entry.quanity);
            }
            lastEntry = entry;
            return Entries.insertEntry(entry);
          });
        });
      });
    });
  };

}).call(this);
