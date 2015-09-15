db = require('../utilities/DB')


stocksTable = db.get('stocks')


Stocks = {

    getStocks: ->
        stocksTable.find {}, (err, stocks) ->
            throw err if err
            stocks

    getStockByName: (stockName) ->
        stocksTable.findOne {stockName: stockName}, (err, initialValues) ->
            throw err if err
            initialValues

    doesStockWithNameExist: (stockName) ->
        stocksTable.count('stockName': stockName).then (count) ->
            count != 0

    addStock: (stock) ->
        stock = sanitizeStock(stock)
        stocksTable.insert(stock)

    deleteStockWithName: (stockName) ->
        stocksTable.remove({stockName: stockName})

}


module.exports = Stocks


sanitizeStock = (stock) ->
    {
        stockName: stock.stockName
        number: stock.number
        acb: stock.acb
    }
