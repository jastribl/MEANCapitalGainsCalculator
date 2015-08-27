// Generated by CoffeeScript 1.9.3
(function() {
  var Entries, cleanEntry, db, entriesTable;

  db = require('../utilities/DB');

  entriesTable = db.get('entries');

  Entries = {
    deleteAllEntriesForStockWithName: function(stockname) {
      return entriesTable.remove({
        stockName: stockname
      }, function(err) {
        if (err) {
          throw err;
        }
      });
    },
    getAllEntriesOrdered: function() {
      return entriesTable.find({}, {
        sort: {
          stockname: 1,
          year: 1,
          month: 1,
          day: 1,
          tradenumber: 1
        }
      }, function(err, entries) {
        if (err) {
          throw err;
        }
        return entries;
      });
    },
    getEntryWithMatchingTimeData: function(entry) {
      entry = cleanEntry(entry);
      return entriesTable.findOne({
        stockname: entry.stockname,
        year: entry.year,
        month: entry.month,
        day: entry.day,
        tradenumber: entry.tradenumber
      }, function(err, entry) {
        if (err) {
          throw err;
        }
        return entry;
      });
    },
    getEntriesForStockOrdered: function(stockname) {
      return entriesTable.find({
        stockname: stockname
      }, {
        sort: {
          year: 1,
          month: 1,
          day: 1,
          tradenumber: 1
        }
      }, function(err, entries) {
        if (err) {
          throw err;
        }
        return entries;
      });
    },
    getEntryById: function(_id) {
      return entriesTable.findOne({
        _id: _id
      }, function(err, entry) {
        if (err) {
          throw err;
        }
        return entry;
      });
    },
    removeEntry: function(entry) {
      entry = cleanEntry(entry);
      return entriesTable.remove({
        stockname: entry.stockname,
        year: entry.year,
        month: entry.month,
        day: entry.day,
        tradenumber: entry.tradenumber
      }, function(err) {
        if (err) {
          throw err;
        }
      });
    },
    getEntryCountMatchingData: function(entry) {
      entry = cleanEntry(entry);
      return entriesTable.count({
        stockname: entry.stockname,
        year: entry.year,
        month: entry.month,
        day: entry.day,
        tradenumber: entry.tradenumber
      });
    },
    insertEntry: function(entry) {
      entry = cleanEntry(entry);
      return entriesTable.insert(entry);
    },
    updateEntry: function(entry) {
      entry = cleanEntry(entry);
      return entriesTable.update({
        stockname: entry.stockname,
        year: entry.year,
        month: entry.month,
        day: entry.day,
        tradenumber: entry.tradenumber
      }, entry, function(err) {
        if (err) {
          throw err;
        }
      });
    },
    removeAllEntriesForStockWithName: function(stockName) {
      return entriesTable.remove({
        stockname: stockName
      }, function(err) {
        if (err) {
          throw err;
        }
      });
    }
  };

  module.exports = Entries;

  cleanEntry = function(entry) {
    entry.year = +entry.year;
    entry.month = +entry.month;
    entry.day = +entry.day;
    entry.tradenumber = +entry.tradenumber;
    return entry;
  };

}).call(this);
