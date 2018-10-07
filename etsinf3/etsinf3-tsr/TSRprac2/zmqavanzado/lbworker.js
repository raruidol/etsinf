var dispo = arr[1];
var verbose = arr[3];

var zmq = require('zmq')
, requester = zmq.socket('req');
var arr = process.argv.slice(2);
requester.connect('tcp://localhost:8001');
requester.identity= arr[0];
requester.send(dispo);

requester.on('message', function(msg) {
console.log('received request:', msg.toString());
setTimeout(function() {
requester.send(arr[2]);
}, 10000000000);
});
