db = require('../utilities/DB')

entriesTable = db.get('entries')


Entries = {

    deleteAllEntriesForStockWithName: (stockname) ->
        entriesTable.remove { stockName: stockname }, (err) ->
            throw err if err

    getAllEntriesOrdered: ->
        entriesTable.find {}, { sort: stockname: 1, year: 1, month: 1, day: 1, tradenumber: 1 }, (err, entries) ->
            throw err if err
            entries

    getEntryWithMatchingTimeData: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.findOne {stockname: entry.stockname, year: entry.year, month: entry.month, day: entry.day, tradenumber: entry.tradenumber}, (err, entry) ->
            throw err if err
            entry

    getEntriesForStockOrdered: (stockname) ->
        entriesTable.find { stockname: stockname }, { sort: year: 1, month: 1, day: 1, tradenumber: 1 }, (err, entries) ->
            throw err if err
            entries

    getEntryById: (_id) ->
        entriesTable.findOne { _id: _id }, (err, entry) ->
            throw err if err
            entry

    removeEntry: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.remove { stockname: entry.stockname, year: entry.year, month: entry.month, day: entry.day, tradenumber: entry.tradenumber }, (err) ->
            throw err if err

    getEntryCountMatchingData: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.count(stockname: entry.stockname, year: entry.year, month: entry.month, day: entry.day, tradenumber: entry.tradenumber)


    insertEntry: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.insert(entry)

    updateEntry: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.update {stockname: entry.stockname, year: entry.year, month: entry.month, day: entry.day, tradenumber: entry.tradenumber}, entry, (err) ->
            throw err if err

    removeAllEntriesForStockWithName: (stockName) ->
        entriesTable.remove {stockname: stockName}, (err) ->
            throw err if err

}


module.exports = Entries


cleanEntry = (entry) ->
    entry.year = +entry.year
    entry.month = +entry.month
    entry.day = +entry.day
    entry.tradenumber = +entry.tradenumber
    entry