var express = require('express');
var path = require('path');

var indexRouter = require('./routes/index');
var testRouter = require('./routes/test');

var app = express();

// disable page caching
// app.disable('view cache');

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

let staticOptions = {
    maxAge: "60s"
}

app.use(express.static(path.join(__dirname, 'public'),staticOptions));

app.use('/', indexRouter);
app.use('/test/*', testRouter);

module.exports = app;
