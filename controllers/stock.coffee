express = require('express')
controller = express.Router()
Entries = require('../models/Entries')
StockList = require('../models/StockList')


controller.get '/stock', (req, res) ->
    stockname = req.query.stockname
    isEdit = req.session.editEntry
    liveEntry = if req.session.liveEntry then req.session.liveEntry else {}
    editEntry = if isEdit then req.session.editEntry else {}
    req.session.reset()
    StockList.doesStockWithNameExist(stockname).then (stockExists) ->
        if stockExists
            editId = if isEdit then editEntry._id else false
            Entries.getEntriesForStockOrdered(stockname).then (entries) ->
                entries.stockname = stockname
                res.render('stock', { entries, liveEntry, editEntry, editId })
        else
            error = {
                status: '404'
                stack: 'You have attemped to gain access to stock \'' + stockname + '\'\n
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
        res.redirect('/stock?stockname=' + liveEntry.stockname)


controller.post '/editmode', (req, res) ->
    editEntry = req.body
    req.session.editEntry = editEntry
    res.redirect('/stock?stockname=' + editEntry.stockname)


controller.post '/editentry', (req, res) ->
    entry = req.body
    # to-do, check for conflict other than origianl entry (by _id)
    # if no conflict, update (find out how), or jus remove and add a new on
    # only do this if you are sure you want to ad the stock

    # not sure what to do if there is a problem with the entry (i.e. conflict)
    Entries.removeEntry(entry).then ->
        Entries.getEntryCountMatchingData(entry).then (count) ->
            insertAndReCalculate(entry)
            if count == 0
                res.redirect('/stock?stockname=' + entry.stockname)
            else
                req.session.editEntry
                res.redirect('/stock?stockname=' + entry.stockname )


controller.post '/canceledit', (req, res) ->
    stockname = req.body.stockname
    res.redirect('stock?stockname=' + stockname)


controller.post '/deleteentry', (req, res) ->
    entry = req.body
    Entries.removeEntry(entry).then ->
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
                Entries.removeEntry(entry).then ->
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