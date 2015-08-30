express = require('express')
api = express.Router()
StockList = require('../models/StockList')
Entries = require('../models/Entries')


api.get '/api/stockList', (req, res) ->
    StockList.getStockListOrdered().then (stockList) ->
        res.json stockList

api.get '/api/entriesList', (req, res) ->
    Entries.getAllEntriesOrdered().then (entriesList) ->
        res.json entriesList


module.exports = api