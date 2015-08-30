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

api.get '/api/stockList/stockExists', (req, res) ->
    stock = JSON.parse(req.query.stock)
    StockList.doesStockWithNameExist(stock.stockName.toUpperCase()).then (stockExists) ->
        res.json stockExists

api.post '/api/stockList/add', (req, res) ->
    stock = JSON.parse(req.query.stock)
    stock.stockName = stock.stockName.replace(' ', '_').toUpperCase()
    stock.number = 0 if not stock.number
    stock.acb = 0 if not stock.number
    StockList.addStock(stock).then ->
        res.sendStatus(200)


api.get '/api/entriesList', (req, res) ->
    Entries.getAllEntriesOrdered().then (entriesList) ->
        res.json entriesList


module.exports = api