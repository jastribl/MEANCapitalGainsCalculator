express = require('express')
controller = express.Router()
stockListControlller = require('./stocklist')
stockController = require('./stock')


controller.use(stockListControlller)
controller.use(stockController)



controller.get '*', (req, res) ->
    res.render('index', {title: 'Stock Application'})


module.exports = controller