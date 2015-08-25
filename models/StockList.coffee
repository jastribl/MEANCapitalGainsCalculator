db = require('../utilities/DB')


stockListTable = db.get('stocklist')


StockList = {

    getStockListOrdered: ->
        stockListTable.find {}, { sort: stockname: 1 }, (err, stockList) ->
            throw err if err
            stockList

    getStockByName: (stockName) ->
        stockListTable.findOne { stockname: stockname }, (err, initialValues) ->
            throw err if err
            initialValues

    doesStockWithNameExist: (stockname) ->
        stockListTable.count('stockname': stockname).then (count) ->
            count != 0

    addStock: (stock) ->
        stockListTable.insert(stock)

    removeStock: (stock) ->
        stockListTable.remove({ stockname: stock.stockname })

}


module.exports = StockList