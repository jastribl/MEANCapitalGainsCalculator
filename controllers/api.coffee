express = require('express')
api = express.Router()
StockList = require('../models/StockList')
Entries = require('../models/Entries')


api.get '/api/stockList', (req, res) ->
    StockList.getStockListOrdered().then (stockList) ->
        res.json stockList

api.delete '/api/stockList', (req, res) ->
    stockName = req.query.stockName
    StockList.deleteStockWithName(stockName).then ->
        Entries.deleteAllEntriesForStockWithName(stockName).then ->
            res.sendStatus(200)

api.get '/api/entriesList', (req, res) ->
    Entries.getAllEntriesOrdered().then (entriesList) ->
        res.json entriesList


module.exports = api