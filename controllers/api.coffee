express = require('express')
api = express.Router()
StockList = require('../models/StockList')
Entries = require('../models/Entries')


api.get '/api/stockList', (req, res) ->
    StockList.getStockList().then (stockList) ->
        res.json stockList

api.delete '/api/stockList', (req, res) ->
    stockName = req.query.stockName
    StockList.deleteStockWithName(stockName).then ->
        Entries.deleteAllEntriesForStockWithName(stockName).then ->
            res.sendStatus(200)

api.post '/api/stockList', (req, res) ->
    stock = JSON.parse(req.query.stock)
    stock.stockName = stock.stockName.toUpperCase()
    stock.number = 0 if not stock.number
    stock.acb = 0 if not stock.acb
    StockList.addStock(stock).then ->
        res.json stock


api.get '/api/entriesList', (req, res) ->
    stockName = req.query.stockName
    if stockName
        Entries.getEntriesForStockOrdered(stockName).then (entriesList) ->
            res.json entriesList
    else
        Entries.getAllEntries().then (entriesList) ->
            res.json entriesList

api.post '/api/entriesList', (req, res) ->
    entry = JSON.parse(req.query.entry)
    Entries.addEntry(entry).then (addedEntry) ->
        calculateEntries(addedEntry).then (changedEntries) ->
            res.json changedEntries

api.delete '/api/entriesList', (req, res) ->
    entry = JSON.parse(req.query.entry)
    Entries.removeEntryById(entry._id).then ->
        # todo: make this so it does not need to send everything back
        calculateEntries(entry, true).then (changedEntries) ->
            res.json changedEntries

api.put '/api/entriesList', (req, res) ->
    entry = JSON.parse(req.query.entry)
    Entries.updateEntry(entry).then (updatedEntry) ->
        calculateEntries(updatedEntry).then (changedEntries) ->
            res.json changedEntries


module.exports = api


# todo: problem with only recalcuating below where an enty is moved to
calculateEntries = (insertedEntry, reCalculateAll) ->
    stockName = insertedEntry.stockName
    Entries.getEntriesForStockOrdered(stockName).then (entriesList) ->
        StockList.getStockByName(stockName).then (initialValues) ->
            lastEntry = {
                quantity: initialValues.number
                totalshares: initialValues.number
                acbperunit: initialValues.number == 0 ? 0 : initialValues.acb / initialValues.number
                acbtotal: initialValues.acb
            }
            going = reCalculateAll
            listOfModifiedEntries = []
            entriesList.forEach (entry) ->
                if going or entry._id.toString() == insertedEntry._id.toString()
                    going = true

                    if entry.buysell == 'buy'
                        entry.totalshares = lastEntry.totalshares + entry.quantity
                        entry.acbtotal = lastEntry.acbtotal + (entry.price * entry.quantity) + entry.commission
                        entry.acbperunit = entry.acbtotal / entry.totalshares
                    else if entry.buysell == 'sell'
                        entry.totalshares = lastEntry.totalshares - entry.quantity
                        entry.problem = true if entry.totalshares < 0
                        if entry.totalshares == 0
                            entry.acbtotal = 0
                            entry.acbperunit = 0
                        else
                            entry.acbtotal = lastEntry.getACBTotal - (entry.quantity * lastEntry.acbtotal / lastEntry.totalshares)
                            entry.acbperunit = entry.acbtotal / entry.totalshares
                        entry.capitalgainloss = ((entry.price * entry.quantity) - entry.commission) - (lastEntry.acbperunit * entry.quantity)
                    Entries.updateEntry(entry)
                    listOfModifiedEntries.push(entry)
                lastEntry = entry
            return listOfModifiedEntries
