// Generated by CoffeeScript 1.9.3
(function() {
  var app, express, router;

  express = require('express');

  router = require('./controllers/router');

  app = express();

  app.set('view engine', 'jade');

  app.use(express["static"]('public'));

  app.use(express["static"]('node_modules/angular'));

  app.use(router);

  if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
      res.status(err.status || 500);
      return res.render('error', {
        message: err.message,
        error: err
      });
    });
  }

  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    return res.render('error', {
      message: err.message,
      error: {}
    });
  });

  module.exports = app;

}).call(this);
