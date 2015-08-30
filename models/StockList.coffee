db = require('../utilities/DB')


stockListTable = db.get('stocklist')


StockList = {

    getStockListOrdered: ->
        stockListTable.find {}, { sort: stockName: 1 }, (err, stockList) ->
            throw err if err
            stockList

    getStockByName: (stockName) ->
        stockListTable.findOne { stockName: stockName }, (err, initialValues) ->
            throw err if err
            initialValues

    doesStockWithNameExist: (stockName) ->
        stockListTable.count('stockName': stockName).then (count) ->
            count != 0

    addStock: (stock) ->
        stockListTable.insert(stock)

    deleteStockWithName: (stockName) ->
        stockListTable.remove({ stockName: stockName })

}


module.exports = StockList