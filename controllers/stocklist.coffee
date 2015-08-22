express = require('express')
controller = express.Router()
StockList = require('../models/StockList')
Entries = require('../models/Entries')


controller.get '/stocklist', (req, res) ->
    StockList.getStockListOrdered().then (stockList) ->
        options = {
            stocklist: stockList
            liveEditStock: req.session.liveEditStock if req.session.liveEditStock
        }
        req.session.reset()
        res.render('stocklist', options)

controller.post '/addstock', (req, res) ->
    stock = req.body
    stock.stockname = stock.stockname.toUpperCase()
    StockList.doesStockExit(stock).then (stockExists) ->
        if stockExists
            req.session.liveEditStock = stock
            res.redirect('/stocklist')
        else
            stock.number = 0 if not stock.number
            stock.acb = 0 if not stock.acb
            StockList.addStock(stock)
            res.redirect('/stocklist')

controller.post '/deletestock', (req, res) ->
    stock = req.body
    Entries.removeAllEntriesForStockWithName(stock.stockname).then ->
        StockList.removeStock(stock).then ->
        res.redirect('/stocklist')


module.exports = controller