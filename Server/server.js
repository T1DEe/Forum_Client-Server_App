const http = require('http');

const server = http.createServer();
server.on('request', (request, response) => {
    response.writeHead(200, {'Content-Type':'text/plant'});
    response.end('server is working')
}).listen(3000);