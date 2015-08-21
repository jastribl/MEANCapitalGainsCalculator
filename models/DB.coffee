monk = require('monk')

db = monk('localhost:27017/StockApplication')


module.exports = db