db = require('../utilities/DB')


entriesTable = db.get('entries')


Entries = {

    deleteAllEntries: ->
        entriesTable.remove {}, (err) ->
            throw err if err
            return

    getAllEntriesOrdered: ->
        entriesTable.find {}, { sort: stockname: 1, year: 1, month: 1, day: 1, tradenumber: 1 }, (err, entries) ->
            throw err if err
            return entries

    getEntryWithMatchingTimeData: (entry) ->
        entriesTable.findOne {stockname: entry.stockname, year: entry.year, month: entry.month, day: entry.day, tradenumber: entry.tradenumber}, (err, entry) ->
            throw err if err
            return entry

    getEntriesForStockOrdered: (stockname) ->
        entriesTable.find { stockname: stockname }, { sort: year: 1, month: 1, day: 1, tradenumber: 1 }, (err, entries) ->
            throw err if err
            return entries

    getEntryById: (_id) ->
        entriesTable.findOne { _id: _id }, (err, entry) ->
            throw err if err
            return entry

    removeEntry: (entry) ->
        entriesTable.remove { stockname: entry.stockname, year: entry.year, month: entry.month, day: entry.day, tradenumber: entry.tradenumber }, (err) ->
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

    updateEntry: (entry) ->
        entriesTable.update {_id: _id}, { totalshares:entry.totalshares, acbperunit: entry.acbperunit, acbtotal: entry.acbtotal, capitalgainloss: entry.capitalgainloss}, (err) ->
            throw err if err
            return

}


module.exports = Entries