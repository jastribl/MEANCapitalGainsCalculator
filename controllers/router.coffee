express = require('express')
router = express.Router()
api = require('./api')
Stocks = require('../models/Stocks')


router.use(api)

router.get '/stocks', (req, res) ->
    res.render('stocks', {title: 'Stock List'})

router.get '/stock', (req, res) ->
    stockName = req.query.stockName.toUpperCase()
    Stocks.doesStockWithNameExist(stockName).then (stockExists) ->
        if stockExists
            res.render('stock', {title: stockName})
        else
            error = {
                status: 404
                message: 'You have attemped to gain access to stock \'' + stockName + '\'\n
                        But you do not have that stock!'
            }
            res.render('error', {error})

router.get '/debug', (req, res) ->
    res.render('debug', {title: 'Debug'})

router.get '*', (req, res) ->
    res.render('index', {title: 'Stock Application'})


module.exports = router
