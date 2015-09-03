express = require('express')


router = require('./controllers/router')

app = express()

app.set('view engine', 'jade')
app.use(express.static('public'))
app.use(express.static('node_modules/angular'))


app.use(router)


if app.get('env') == 'development'
    app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render('error', {
            message: err.message
            error: err
        })


app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render('error', {
        message: err.message
        error: {}
    })


module.exports = app