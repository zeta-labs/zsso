var bodyparser = require('body-parser');
var express = require('express');
var OAuthServer = require('express-oauth-server');
var model = require('./model');
var util = require('util');

var app = express();

app.oauth = new OAuthServer({
  // See https://github.com/thomseddon/node-oauth2-server for specification
  debug: true,
  grants: ['password'],
  model: model
});

// console.log(util.inspect(app.oauth, false, null));

app.use(bodyparser.json());
app.use(bodyparser.urlencoded({ extended: false }));

app.get('/secret', app.oauth.authorize(), function(req, res) {
  // Will require a valid access_token.
  res.send('Secret area');
});

app.get('/public', function(req, res) {
  // Does not require an access_token.
  res.send('Public area');
});

app.listen(3000);
