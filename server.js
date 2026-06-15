const http = require('http');
const fs = require('fs');
const path = require('path');
const root = 'C:/Users/45409/Documents/FreeWork/blog';

const mimeTypes = {
  '.html': 'text/html', '.css': 'text/css', '.js': 'application/javascript',
  '.md': 'text/markdown', '.png': 'image/png', '.gif': 'image/gif',
  '.jpg': 'image/jpeg', '.svg': 'image/svg+xml',
};

const server = http.createServer((req, res) => {
  let filePath = path.join(root, req.url === '/' ? '/index.html' : decodeURIComponent(req.url.split('?')[0]));
  if (!fs.existsSync(filePath)) { res.writeHead(404); return res.end('404'); }
  const ext = path.extname(filePath);
  res.writeHead(200, { 'Content-Type': mimeTypes[ext] || 'text/plain' });
  fs.createReadStream(filePath).pipe(res);
});

server.listen(8080, '127.0.0.1', () => {
  console.log('SERVER_READY: http://127.0.0.1:8080');
  // Quick self-test
  const http2 = require('http');
  http2.get('http://127.0.0.1:8080/', (resp) => {
    let data = '';
    resp.on('data', (chunk) => data += chunk);
    resp.on('end', () => {
      console.log('SELF_TEST: Status=' + resp.statusCode + ' Size=' + data.length);
      if (data.includes('Liangliang')) console.log('SELF_TEST: Bio verified OK');
    });
  });
});

// Keep alive for 300 seconds
setTimeout(() => { server.close(); process.exit(0); }, 300000);
