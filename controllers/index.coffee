express = require('express')
controller = express.Router()
stockController = require('./stock')
api = require('./api')
Entries = require('../models/Entries')
StockList = require('../models/StockList')


controller.use(stockController)
controller.use(api)

controller.get '/stocklist', (req, res) ->
    res.render('stocklist', { title: 'Stock List' })

controller.get '/debug', (req, res) ->
    res.render('debug', {title: 'Debug'})

controller.get '*', (req, res) ->
    res.render('index', {title: 'Stock Application'})


module.exports = controller