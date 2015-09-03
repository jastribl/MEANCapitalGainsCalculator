express = require('express')
router = express.Router()
api = require('./api')
StockList = require('../models/StockList')


router.use(api)

router.get '/stocklist', (req, res) ->
    res.render('stocklist', {title: 'Stock List'})

router.get '/stock', (req, res) ->
    stockName = req.query.stockName.toUpperCase()
    # todo: remove this call from here and move to 'stock' page
    StockList.doesStockWithNameExist(stockName).then (stockExists) ->
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