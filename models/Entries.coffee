db = require('../utilities/DB')

entriesTable = db.get('entries')


Entries = {

    deleteAllEntriesForStockWithName: (stockName) ->
        entriesTable.remove { stockName: stockName }, (err) ->
            throw err if err

    getAllEntriesOrdered: ->
        entriesTable.find {}, { sort: stockName: 1, year: 1, month: 1, day: 1, tradeNumber: 1 }, (err, entries) ->
            throw err if err
            entries

    getEntryWithMatchingTimeData: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.findOne {stockName: entry.stockName, year: entry.year, month: entry.month, day: entry.day, tradeNumber: entry.tradeNumber}, (err, entry) ->
            throw err if err
            entry

    getEntriesForStockOrdered: (stockName) ->
        entriesTable.find { stockName: stockName }, { sort: year: 1, month: 1, day: 1, tradeNumber: 1 }, (err, entries) ->
            throw err if err
            entries

    getEntryById: (_id) ->
        entriesTable.findOne { _id: _id }, (err, entry) ->
            throw err if err
            entry

    removeEntryById: (_id) ->
        entriesTable.remove { _id: _id }, (err) ->
            throw err if err

    getEntryCountMatchingData: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.count(stockName: entry.stockName, year: entry.year, month: entry.month, day: entry.day, tradeNumber: entry.tradeNumber)

    addEntry: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.insert(entry)

    updateEntry: (entry) ->
        entry = cleanEntry(entry)
        entriesTable.update {stockName: entry.stockName, year: entry.year, month: entry.month, day: entry.day, tradeNumber: entry.tradeNumber}, entry, (err) ->
            throw err if err

}


module.exports = Entries


cleanEntry = (entry) ->
    entry.year = +entry.year
    entry.month = +entry.month
    entry.day = +entry.day
    entry.tradeNumber = +entry.tradeNumber
    entry