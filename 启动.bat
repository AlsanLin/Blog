@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ================================
echo   L3's Blog - Local Preview
echo ================================
echo.

:: Try docsify first
where docsify >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [Method 1] Using docsify-cli...
    echo.
    echo Blog is ready at: http://localhost:3000
    echo Press Ctrl+C to stop
    echo.
    docsify serve "L3's Blog" --port 3000
    goto :end
)

:: Try Python
where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [Method 2] Using Python HTTP server...
    echo.
    echo Blog is ready at: http://localhost:8080
    echo Press Ctrl+C to stop
    echo.
    python -m http.server 8080
    goto :end
)

:: Try Node.js
where node >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [Method 3] Using Node.js HTTP server...
    echo.
    echo Blog is ready at: http://localhost:8080
    echo Press Ctrl+C to stop
    echo.
    node -e "const h=require('http'),f=require('fs'),p=require('path'),r='.';h.createServer((q,s)=>{let t=p.join(r,q.url==='/'?'/index.html':decodeURIComponent(q.url.split('?')[0]));if(!f.existsSync(t)){s.writeHead(404);s.end('404')}else{let m={'html':'text/html','css':'text/css','js':'text/javascript','md':'text/markdown','png':'image/png','gif':'image/gif'},e=p.extname(t);s.writeHead(200,{'Content-Type':m[e]||'text/plain'});f.createReadStream(t).pipe(s)}}).listen(8080,()=>console.log('Ready: http://localhost:8080'))"
    goto :end
)

echo [ERROR] Neither docsify, python, nor node found.
echo Please install Node.js: https://nodejs.org/
echo Or Python: https://python.org/
pause

:end
