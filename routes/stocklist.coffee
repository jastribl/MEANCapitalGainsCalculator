express = require('express')
router = express.Router()

router.get '/stocklist', (req, res, next) ->
    db = req.db
    collection = db.get('stocklist')
    collection.find {}, { sort: stockname: 1 }, (err, stocklist) ->
        res.render('stocklist', { title: 'Stock List', 'stocklist': stocklist })

router.post '/addstock', (req, res, next) ->
    db = req.db
    stock = req.body
    stock.stockname = stock.stockname.toUpperCase()
    collection = db.get('stocklist')
    collection.count('stockname': stock.stockname).then (count) ->
        if count == 0
            stock.number = 0 if not stock.number
            stock.acb = 0 if not stock.acb
            collection.insert(stock)
    res.redirect('stocklist')

router.post '/deletestock', (req, res, next) ->
    db = req.db
    stockname = req.body.stockname
    collection = db.get('stocklist')
    collection.remove { stockname: stockname }, (err) ->
        res.send 'There was a problem deleting the information to the database.' if err
        res.redirect('stocklist')

module.exports = router