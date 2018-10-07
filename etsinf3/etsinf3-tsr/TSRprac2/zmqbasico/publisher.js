var zmq = require('zmq')
aux = require("./auxfunctions.js");
var publisher = zmq.socket('pub')
publisher.bind('tcp://*:8000', function(err) {
if(err)
console.log(err)
else
console.log("Listening on 8000...")
})
for (var i=1 ; i<10 ; i++)
setTimeout(function() {
var rand = aux.randNumber(0,999);
console.log('sent');
publisher.send("NOTICIAS :"+rand)
}, 1000 * i)
for (var i=1 ; i<10 ; i++)
setTimeout(function() {
var rand = aux.randNumber(0,999);
console.log('sent');
publisher.send("OFERTAS :"+rand)
}, 1000 * i)
process.on('SIGINT', function() {
publisher.close()
console.log('\nClosed')
})
