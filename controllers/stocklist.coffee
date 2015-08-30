express = require('express')
controller = express.Router()
StockList = require('../models/StockList')
Entries = require('../models/Entries')


controller.get '/stocklist', (req, res) ->
    options = {
        title: 'Stock List'
        liveEditStock: req.session.liveEditStock if req.session.liveEditStock
    }
    req.session.liveEditStock = null
    res.render('stocklist', options)

controller.post '/addstock', (req, res) ->
    stock = req.body
    StockList.doesStockWithNameExist(stock.stockName.toUpperCase()).then (stockExists) ->
        if stockExists
            req.session.liveEditStock = stock
            res.redirect('/stocklist')
        else
            stock.stockName = stock.stockName.toUpperCase()
            stock.number = 0 if not stock.number
            stock.acb = 0 if not stock.acb
            StockList.addStock(stock)
            res.redirect('/stocklist')


module.exports = controller