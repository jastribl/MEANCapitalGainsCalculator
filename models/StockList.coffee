db = require('../utilities/DB')


stockListTable = db.get('stocklist')


StockList = {

    getStockListOrdered: ->
        stockListTable.find {}, { sort: stockname: 1 }, (err, stockList) ->
            throw err if err
            stockList

    getStockByName: (stockName) ->
        stockListTable.findOne()
        stockListTable.findOne { stockname: stockName }, (err, initialValues) ->
            throw err if err
            initialValues

    doesStockExit: (stock) ->
        stockListTable.count('stockname': stock.stockname).then (count) ->
            count != 0

    addStock: (stock) ->
        stockListTable.insert(stock)

    removeStock: (stock) ->
        stockListTable.remove({ stockname: stock.stockname })

}


module.exports = StockList