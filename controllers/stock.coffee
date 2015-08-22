express = require('express')
controller = express.Router()
Entries = require('../models/Entries')
StockList = require('../models/StockList')


controller.get '/stock', (req, res) ->
    query = req.query
    stockname = query.stockname
    StockList.doesStockExit(query).then (stockExists) ->
        if stockExists
            liveEditEntry = null
            if query.edit
                editId = query._id
                Entries.getEntryById(query._id).then (entry) ->
                    liveEditEntry = entry
            else
                editId = false
                liveEditEntry = query

            Entries.getEntriesForStockOrdered(stockname).then (entries) ->
                entries['stockname'] = stockname
                res.render('stock', { entries, liveEditEntry, editId })
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
            insertAndReCalculate(entry)
            res.redirect('/stock?stockname=' + entry.stockname)
        else
            query = ''
            Object.keys(entry).forEach (k) ->
                query += '&' + k + '=' + entry[k]
            res.redirect('/stock?' + query)


controller.post '/editmode', (req, res) ->
    entry = req.body
    res.redirect('/stock?stockname=' + entry.stockname + '&edit=true' + '&_id=' + entry._id)


controller.post '/editentry', (req, res) ->
    entry = req.body

    Entries.removeEntryById(entry._id).then ->
    Entries.getEntryCountMatchingData(entry).then (count) ->
        insertAndReCalculate(entry)
        if count == 0
            res.redirect('/stock?stockname=' + entry.stockname)
        else
            res.redirect('stock?stockname=' + entry.stockname + '&edit=true' + '&_id=' + entry._id)


controller.post '/canceledit', (req, res) ->
    entry = req.body
    res.redirect('stock?stockname=' + entry.stockname)

controller.post '/deleteentry', (req, res) ->
    entry = req.body

    Entries.removeEntryById(entry._id).then ->
        res.send 'There was a problem deleting the information to the database.' if err
    res.redirect('stock?stockname=' + entry.stockname)


module.exports = controller


insertAndReCalculate = (newEntry) ->
    Entries.insertEntry(newEntry)
    Entries.getEntriesForStockOrdered(newEntry.stockname).then (entries) ->
        StockList.getStockByName(newEntry.stockname).then (initialValues) ->
            lastEntry = {
                quanity: initialValues.number
                totalshares: initialValues.number
                acbperunit: initialValues.number == 0 ? 0 : initialValues.acb / initialValues.number
                acbtotal: initialValues.acb
            }
            (
                Entries.removeEntryById(entry._id).then ->
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
                    Entries.insertEntry(entry)
                    lastEntry = entry
            ) for entry in entries