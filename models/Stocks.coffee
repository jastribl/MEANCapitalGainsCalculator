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

    # todo: only save the expected parts of the stock
    addStock: (stock) ->
        stocksTable.insert(stock)

    deleteStockWithName: (stockName) ->
        stocksTable.remove({stockName: stockName})

}


module.exports = Stocks
