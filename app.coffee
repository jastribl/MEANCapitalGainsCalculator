express = require('express')
logger = require('morgan')
bodyParser = require('body-parser')

# New Code
mongo = require('mongodb')

controller = require('./controllers/index')

app = express()

# view engine setup
app.set('views', 'views')
app.set('view engine', 'jade')
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(express.static('public'))


app.use(controller)

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next err


# error handlers
# development error handler
# will print stacktrace
if app.get('env') == 'development'
    app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render('error', {
            message: err.message
            error: err
        })

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render('error', {
        message: err.message
        error: {}
    })


module.exports = app