db = require('../utilities/DB')


entriesTable = db.get('entries')


Entries = {

    getAllEntriesOrdered: ->
        entriesTable.find {}, { sort: stockname: 1, year: 1, month: 1, day: 1, tradenumber: 1 }, (err, entries) ->
            throw err if err
            return entries

    getEntriesForStockOrdered: (stockname) ->
        entriesTable.find { stockname: stockname }, { sort: year: 1, month: 1, day: 1, tradenumber: 1 }, (err, entries) ->
            throw err if err
            return entries

    getEntryById: (_id) ->
        entriesTable.findOne { _id: _id }, (err, entry) ->
            throw err if err
            return entry

    removeEntryById: (_id) ->
        entriesTable.remove { _id: _id }, (err) ->
            throw err if err
            return

    getEntryCountMatchingData: (entry) ->
        entriesTable.count(stockname: entry.stockname, year: entry.year, month: entry.month, day: entry.day, tradenumber: entry.tradenumber)


    insertEntry: (entry) ->
        entriesTable.insert(entry)

    removeAllEntriesForStockWithName: (stockName) ->
        entriesTable.remove {stockname: stockName}, (err) ->
            throw err if err
            return
}


module.exports = Entries