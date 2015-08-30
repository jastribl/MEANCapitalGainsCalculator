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
        response = {
            stockExists: stockExists
            error: 'You already have this stock!' if stockExists
        }
        res.json response

api.post '/api/stockList', (req, res) ->
    stock = JSON.parse(req.query.stock)
    stock.stockName = stock.stockName.toUpperCase()
    stock.number = 0 if not stock.number
    stock.acb = 0 if not stock.number
    StockList.addStock(stock).then ->
        res.sendStatus(200)


api.get '/api/entriesList', (req, res) ->
    Entries.getAllEntriesOrdered().then (entriesList) ->
        res.json entriesList


module.exports = api