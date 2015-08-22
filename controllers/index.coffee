express = require('express')
controller = express.Router()
stockListControlller = require('./stocklist')
stockController = require('./stock')
Entries = require('../models/Entries')
StockList = require('../models/StockList')


controller.use(stockListControlller)
controller.use(stockController)


controller.get '/debug', (req, res) ->
    StockList.getStockListOrdered().then (stocklist) ->
        Entries.getAllEntriesOrdered().then (entries) ->
            res.render('debug', {stocklist: stocklist, entries: entries})


controller.get '*', (req, res) ->
    res.render('index', {title: 'Stock Application'})


module.exports = controller