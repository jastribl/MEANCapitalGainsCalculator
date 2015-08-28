express = require('express')
controller = express.Router()
Entries = require('../models/Entries')
StockList = require('../models/StockList')


controller.get '/stock', (req, res) ->
    stockName = req.query.stockName.toUpperCase()
    isEdit = req.session.editEntry
    liveEntry = if req.session.liveEntry then req.session.liveEntry else {}
    req.session.liveEntry = null
    editEntry = if isEdit then req.session.editEntry else {}
    req.session.editEntry = null
    StockList.doesStockWithNameExist(stockName).then (stockExists) ->
        if stockExists
            editId = if isEdit then editEntry._id else false
            Entries.getEntriesForStockOrdered(stockName).then (entries) ->
                entries.stockName = stockName
                res.render('stock', { entries, liveEntry, editEntry, editId })
        else
            error = {
                status: '404'
                stack: 'You have attemped to gain access to stock \'' + stockName + '\'\n
                        But you do not have that stock!'
            }
            res.render('error', { error })


controller.post '/addentry', (req, res) ->
    liveEntry = req.body
    Entries.getEntryCountMatchingData(liveEntry).then (count) ->
        if count == 0
            insertAndReCalculate(liveEntry)
        else
            req.session.liveEntry = liveEntry
        res.redirect('/stock?stockName=' + liveEntry.stockName)


controller.post '/editmode', (req, res) ->
    editEntry = req.body
    req.session.editEntry = editEntry
    res.redirect('/stock?stockName=' + editEntry.stockName)


controller.post '/editentry', (req, res) ->
    entry = req.body
    Entries.getEntryById(entry._id).then (oldEntry) ->
        Entries.getEntryWithMatchingTimeData(entry).then (conflictEntry) ->
            if (conflictEntry and conflictEntry._id.toString() == entry._id.toString()) or not conflictEntry
                Entries.removeEntry(oldEntry).then ->
                    insertAndReCalculate(entry)
            else
                req.session.editEntry = oldEntry
            res.redirect('/stock?stockName=' + entry.stockName )


controller.post '/canceledit', (req, res) ->
    res.redirect('stock?stockName=' + req.body.stockName)


controller.post '/deleteentry', (req, res) ->
    entry = req.body
    Entries.removeEntry(entry).then ->
        res.redirect('stock?stockName=' + entry.stockName)


module.exports = controller



insertAndReCalculate = (newEntry) ->
    Entries.insertEntry(newEntry)
    stockName = newEntry.stockName
    Entries.getEntriesForStockOrdered(stockName).then (entries) ->
        StockList.getStockByName(stockName).then (initialValues) ->
            lastEntry = {
                quanity: +initialValues.number
                totalshares: +initialValues.number
                acbperunit: +initialValues.number == 0 ? 0 : +initialValues.acb / +initialValues.number
                acbtotal: +initialValues.acb
            }
            Entries.deleteAllEntriesForStockWithName(stockName).then ->
                entries.forEach (entry) ->
                    if entry.buysell == 'buy'
                        entry.totalshares = +lastEntry.totalshares + +entry.quanity
                        entry.acbtotal = +lastEntry.acbtotal + (+entry.price * +entry.quanity) + +entry.commission
                        entry.acbperunit = +entry.acbtotal / +entry.totalshares
                    else if entry.buysell == 'sell'
                        entry.totalshares = +lastEntry.totalshares - +entry.quanity
                        entry.problem = true if entry.totalshares < 0
                        if entry.totalshares == 0
                            entry.acbtotal = 0
                            entry.acbperunit = 0
                        else
                            entry.acbtotal = +lastEntry.getACBTotal - (+entry.quanity * +lastEntry.acbtotal / +lastEntry.totalshares)
                            entry.acbperunit = +entry.acbtotal / +entry.totalshares
                        entry.capitalgainloss = ((+entry.price * +entry.quanity) - +entry.commission) - (+lastEntry.acbperunit * +entry.quanity)
                    lastEntry = entry
                    Entries.updateEntry(entry)