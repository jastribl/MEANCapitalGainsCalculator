express = require('express')
logger = require('morgan')
bodyParser = require('body-parser')
session = require('client-sessions')


controller = require('./controllers/index')

app = express()

app.use session({
  cookieName: 'session'
  secret: 'JustinStriblingsSecretString'
  duration: 60 * 60 * 1000
  activeDuration: 5 * 60 * 1000})

# view engine setup
app.set('view engine', 'jade')
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(express.static('public'))


app.use(controller)


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