express = require('express')
api = express.Router()
StockList = require('../models/StockList')
Entries = require('../models/Entries')


# todo: split this up into differnet parts of the api.  Also, look into removing some model functions

api.get '/api/stockList', (req, res) ->
    StockList.getStockListOrdered().then (stockList) ->
        res.json stockList

api.delete '/api/stockList/:stockName', (req, res) ->
    stockName = req.params.stockName
    StockList.deleteStockWithName(stockName).then ->
        Entries.deleteAllEntriesForStockWithName(stockName).then ->
            res.sendStatus(200)

api.post '/api/stockList', (req, res) ->
    stock = JSON.parse(req.query.stock)
    stock.stockName = stock.stockName.toUpperCase()
    stock.number = 0 if not stock.number
    stock.acb = 0 if not stock.number
    StockList.addStock(stock).then ->
        res.sendStatus(200)


api.get '/api/entriesList/:stockName', (req, res) ->
    stockName = req.params.stockName
    if stockName
        Entries.getEntriesForStockOrdered(stockName).then (entriesList) ->
            res.json entriesList
    else
        Entries.getAllEntriesOrdered().then (entriesList) ->
            res.json entriesList

api.post '/api/entriesList', (req, res) ->
    entry = JSON.parse(req.query.entry)
    Entries.addEntry(entry).then ->
        res.sendStatus(200)

api.delete '/api/entriesList/:_id', (req, res) ->
    _id = req.params._id
    Entries.removeEntryById(_id).then ->
        res.sendStatus(200)


module.exports = api

# need re-implementing
# insertAndReCalculate = (newEntry) ->
#     Entries.addEntry(newEntry)
#     stockName = newEntry.stockName
#     Entries.getEntriesForStockOrdered(stockName).then (entries) ->
#         StockList.getStockByName(stockName).then (initialValues) ->
#             lastEntry = {
#                 quanity: +initialValues.number
#                 totalshares: +initialValues.number
#                 acbperunit: +initialValues.number == 0 ? 0 : +initialValues.acb / +initialValues.number
#                 acbtotal: +initialValues.acb
#             }
#             Entries.deleteAllEntriesForStockWithName(stockName).then ->
#                 entries.forEach (entry) ->
#                     if entry.buysell == 'buy'
#                         entry.totalshares = +lastEntry.totalshares + +entry.quanity
#                         entry.acbtotal = +lastEntry.acbtotal + (+entry.price * +entry.quanity) + +entry.commission
#                         entry.acbperunit = +entry.acbtotal / +entry.totalshares
#                     else if entry.buysell == 'sell'
#                         entry.totalshares = +lastEntry.totalshares - +entry.quanity
#                         entry.problem = true if entry.totalshares < 0
#                         if entry.totalshares == 0
#                             entry.acbtotal = 0
#                             entry.acbperunit = 0
#                         else
#                             entry.acbtotal = +lastEntry.getACBTotal - (+entry.quanity * +lastEntry.acbtotal / +lastEntry.totalshares)
#                             entry.acbperunit = +entry.acbtotal / +entry.totalshares
#                         entry.capitalgainloss = ((+entry.price * +entry.quanity) - +entry.commission) - (+lastEntry.acbperunit * +entry.quanity)
#                     lastEntry = entry
#                     Entries.updateEntry(entry)