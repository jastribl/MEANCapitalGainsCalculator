express = require('express')
router = express.Router()
stockController = require('./stock')
api = require('./api')
Entries = require('../models/Entries')
StockList = require('../models/StockList')


router.use(stockController)
router.use(api)

router.get '/stocklist', (req, res) ->
    res.render('stocklist', { title: 'Stock List' })

router.get '/debug', (req, res) ->
    res.render('debug', {title: 'Debug'})

router.get '*', (req, res) ->
    res.render('index', {title: 'Stock Application'})


module.exports = router