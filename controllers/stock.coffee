express = require('express')
controller = express.Router()
db = require('../models/DB')
Entries = require('../models/Entries')
StockList = require('../models/StockList')

controller.get '/stock', (req, res) ->


    query = req.query
    stockname = query.stockname
    StockList.getNumberOfStocksWithName(stockname).then (count) ->
        if count > 0
            liveEditEntry = null
            if query.edit
                editId = query._id
                Entries.getEntryById(query._id).then (entry) ->
                    liveEditEntry = entry
            else
                editId = false
                liveEditEntry = query

            Entries.getOrderedEntriesForStockWithName(stockname).then (entries) ->
                entries['stockname'] = stockname
                res.render('stock', { title: stockname, entries, liveEditEntry, editId })
        else
            error = {
                status: '404'
                stack: 'You have attemped to gail access to stock ' + stockname + '\n
                        But you do not have that stock!'
            }
            res.render('error', { error })

controller.post '/addentry', (req, res) ->
    entry = req.body

    Entries.getEntryCountMatchingData(entry).then (count) ->
        if count == 0
            insertAndReCalculate(db, entry)
            res.redirect('/stock?stockname=' + entry.stockname)
        else
            query = ''
            Object.keys(entry).forEach (k) ->
                query += '&' + k + '=' + entry[k]
            res.redirect('/stock?' + query)

controller.post '/editmode', (req, res) ->
    entry = req.body
    res.redirect('stock?stockname=' + entry.stockname + '&edit=true' + '&_id=' + entry._id)

controller.post '/editentry', (req, res) ->
    entry = req.body

    Entries.removeEntryById(entry._id).then (err) ->
        res.send 'There was a problem deleting the information to the database.' if err
    Entries.getEntryCountMatchingData(entry).then (count) ->
        insertAndReCalculate(db, entry)
        if count == 0
            res.redirect('/stock?stockname=' + entry.stockname)
        else
            res.redirect('stock?stockname=' + entry.stockname + '&edit=true' + '&_id=' + entry._id)

controller.post '/canceledit', (req, res) ->
    entry = req.body
    res.redirect('stock?stockname=' + entry.stockname)

controller.post '/deleteentry', (req, res) ->
    entry = req.body

    Entries.removeEntryById(entry._id).then (err) ->
        res.send 'There was a problem deleting the information to the database.' if err
    res.redirect('stock?stockname=' + entry.stockname)

module.exports = controller


insertAndReCalculate = (db, newEntry) ->
    entriesCollection = db.get('entries')
    stocksCollection = db.get('stocklist')
    entriesCollection.insert(newEntry)
    entriesCollection.find { stockname: newEntry.stockname }, { sort: year: 1, month: 1, day: 1, tradenumber: 1 }, (err, entries) ->
        console.log err if err

        stocksCollection.findOne { stockname: newEntry.stockname }, (err, initialValues) ->
            console.log initialValues
            lastEntry = {
                quanity: initialValues.number
                totalshares: initialValues.number
                acbperunit: initialValues.number == 0 ? 0 : initialValues.acb / initialValues.number
                acbtotal: initialValues.acb
            }
            (
                entriesCollection.remove { _id: entry._id }, (err) ->
                    res.send 'There was a problem deleting the information to the database.' if err
                    if entry.buysell == 'buy'
                        entry.totalshares = lastEntry.totalshares + entry.quanity
                        entry.acbtotal = lastEntry.acbtotal + (entry.price * entry.quanity) + entry.commission
                        entry.acbperunit = entry.acbtotal / entry.totalshares
                    else if entry.buysell == 'sell'
                        entry.totalshares = lastEntry.totalshares - entry.quanity
                        if entry.totalshares < 0
                            entry.problem = true
                        if entry.totalshares == 0
                            entry.acbtotal = 0
                            entry.acbperunit = 0
                        else
                            entry.acbtotal = lastEntry.getACBTotal - (entry.quanity * lastEntry.acbtotal / lastEntry.totalshares)
                            entry.acbperunit = entry.acbtotal / entry.totalshares
                        entry.capitalgainloss = ((entry.price * entry.quanity) - entry.commission) - (lastEntry.acbperunit * entry.quanity)
                    else
                        console.log 'we have a problem'
                    entriesCollection.insert(entry)
                    lastEntry = entry
            ) for entry in entries