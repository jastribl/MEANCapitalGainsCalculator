monk = require('monk')

db = monk('127.0.0.1:27017/StockApplication')

db.options.upsert = true


module.exports = db