db = require('./DB')


stockListTable = db.get('stocklist')


StockList = {

    getNumberOfStocksWithName: (stockname) ->
        stockListTable.count({ stockname: stockname })

}


module.exports = StockList