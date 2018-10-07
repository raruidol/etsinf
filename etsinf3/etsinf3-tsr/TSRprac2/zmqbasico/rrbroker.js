// Simple request-reply in NodeJS
var zmq = require('zmq')
, frontend = zmq.socket('router')
, backend = zmq.socket('dealer');
frontend.bindSync('tcp://*:8000');
backend.bindSync('tcp://*:8001');
frontend.on('message', function() {
// Note that separate message parts come as function arguments.
var args = Array.apply(null, arguments);
// Pass array of strings/buffers to send multipart messages.
backend.send(args);
});
backend.on('message', function() {
var args = Array.apply(null, arguments);
frontend.send(args);
});
