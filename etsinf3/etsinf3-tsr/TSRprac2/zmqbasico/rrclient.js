// Hello World client in NodeJS
// Connects REQ socket to tcp://localhost:8000
// Sends "Hello" to server, expects "World" back
var zmq = require('zmq')
, requester = zmq.socket('req');
requester.identity= ”CLIENT1” ;
requester.connect('tcp://localhost:8000');
var replyNbr = 0;
requester.on('message', function(msg) {
console.log('got reply', replyNbr, msg.toString());
replyNbr += 1;
});
for (var i = 0; i < 10; ++i) {
requester.send("WORK");
}
