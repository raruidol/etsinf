var zmq = require('zmq')
, frontend = zmq.socket('router')
, backend = zmq.socket('router');
frontend.bindSync('tcp://*:8000');
backend.bindSync('tcp://*:8001');

var dispoList = [];

frontend.on('message', function() {
var args = dispoList[0];
dispoList.splice(0,0);
// Note that separate message parts come as function arguments.
args = args.push(null, arguments);
// Pass array of strings/buffers to send multipart messages.
backend.send(args);
});

backend.on('message', function() {
if(arguments[1] === "Ready"){dispoList.push(arguments[0]);}
else{
var args = Array.apply(null, arguments);
args.splice(0,1);
frontend.send(args);
dispoList.push(arguments[0]);}
});
