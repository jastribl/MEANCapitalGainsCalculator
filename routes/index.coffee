express = require('express')
router = express.Router()

router.get '*', (req, res, next) ->
    res.render 'index', title: 'Stock Application'
    res.end()

module.exports = router