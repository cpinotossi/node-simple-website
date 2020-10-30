var express = require('express');
var router = express.Router();

const fs = require('fs');

/* GET home page. */
router.get('/', function(req, res, next) {
  // directory path
  const name = req.originalUrl.split('/')[2];

  const imageUrl = `/images${req.originalUrl}.jpg`;
  
  let params = {
    imageUrl: imageUrl,
    name: name,
    rootPath: req.originalUrl,
  };

  res.render('test', params);
});

module.exports = router;