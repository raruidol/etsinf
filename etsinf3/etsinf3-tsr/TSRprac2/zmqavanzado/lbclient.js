
var zmq = require('zmq')
, requester = zmq.socket('req');
var arr = process.argv.slice(2);
requester.identity = arr[0];
requester.connect('tcp://localhost:8000');
var replyNbr = 0;
requester.on('message', function(msg) {
console.log('got reply', replyNbr, msg.toString());
replyNbr += 1;
  if(replyNbr >= 1){ process.exit(0);}
});

requester.send(arr[1]);

