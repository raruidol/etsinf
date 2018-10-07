var net = require('net');
var arr = process.argv.slice(2);
var client = net.connect({port:8000, host:arr[0]},
 function() { //connect listener
 console.log('client connected');
 var ip = arr[1];
 request = {"ip":ip};
 client.write(JSON.stringify(request));
 });
client.on('data',
 function(data) {
 console.log(data.toString());
 client.end(); //no more data written to the stream
 });
client.on('end',
 function() {
 console.log('client disconnected');
 });
