// Hello World server in NodeJS
// Connects REP socket to tcp://*:8001
// Expects "Hello" from client, replies with "World"
var zmq = require('zmq')
, responder = zmq.socket('rep');
responder.connect('tcp://localhost:8001');
responder.on('message', function(msg) {
console.log('received request:', msg.toString());
setTimeout(function() {
responder.send("DONE");
}, 1000);
});
