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

    getEntryById: (_id) ->
        entriesTable.findOne {_id: _id}, (err, foundEntry) ->
            throw err if err
            foundEntry

    removeEntryById: (_id) ->
        entriesTable.remove {_id: _id}, (err) ->
            throw err if err

    addEntry: (entry) ->
        entry = sanitizeEntry(entry)
        entriesTable.insert(entry).then ->
            findEntry(entry)

    updateEntry: (entry) ->
        entry = sanitizeEntry(entry)
        entriesTable.update {_id: entry._id}, entry, (err) ->
            throw err if err


}


module.exports = Entries


sanitizeEntry = (entry) ->
    {
        stockName: entry.stockName
        _id: entry._id
        year: entry.year
        month: entry.month
        day: entry.day
        tradeNumber: entry.tradeNumber
        buysell: entry.buysell
        quantity: entry.quantity
        price: entry.price
        commission: entry.commission
        totalshares: entry.totalshares
        acbperunit: entry.acbperunit
        acbtotal: entry.acbtotal
        capitalgainloss: entry.capitalgainloss
    }

findEntry = (entry) ->
    entriesTable.findOne {stockName: entry.stockName, year: entry.year, month: entry.month, day: entry.day, tradeNumber: entry.tradeNumber}, (err, foundEntry) ->
        throw err if err
        foundEntry
