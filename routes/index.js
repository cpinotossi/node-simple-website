var express = require('express');
var router = express.Router();

const fs = require('fs');

/* GET home page. */
router.get('/', function (req, res, next) {    
  let params = {
    name: "Welcome"
  };

  res.render('index', params);
});

module.exports = router;