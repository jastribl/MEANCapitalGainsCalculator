db = require('../utilities/DB')

entriesTable = db.get('entries')


Entries = {

    deleteAllEntriesForStockWithName: (stockName) ->
        entriesTable.remove {stockName: stockName}, (err) ->
            throw err if err

    getAllEntries: ->
        entriesTable.find {}, (err, entries) ->
            throw err if err
            entries

    getEntriesForStockOrdered: (stockName) ->
        entriesTable.find {stockName: stockName}, {sort: year: 1, month: 1, day: 1, tradeNumber: 1}, (err, entries) ->
            throw err if err
            entries

    removeEntryById: (_id) ->
        entriesTable.remove {_id: _id}, (err) ->
            throw err if err

    # todo: only save the expected parts of the entry
    addEntry: (entry) ->
        entriesTable.insert(entry).then ->
            findEntry(entry)

    # todo: only save the expected parts of the entry
    updateEntry: (entry) ->
        entriesTable.update {_id: entry._id}, entry, (err) ->
            throw err if err
        .then ->
            findEntry(entry)


}


module.exports = Entries


findEntry = (entry) ->
    entriesTable.findOne {stockName: entry.stockName, year: entry.year, month: entry.month, day: entry.day, tradeNumber: entry.tradeNumber}, (err, foundEntry) ->
        throw err if err
        foundEntry
