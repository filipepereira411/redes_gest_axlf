@echo off
title Compilador Automatizado - Gestor LAN
cd /d "%~dp0"
if not exist "public" mkdir "public"
copy index.html public\index.html >nul 2>&1

( 
echo const express = require('express');
echo const os = require('os');
echo const ping = require('ping');
echo const path = require('path');
echo const app = express();
echo app.use(express.json());
echo const publicPath = path.join(__dirname, 'public');
echo app.use(express.static(publicPath));
echo app.get('/', (req, res) =^> { res.sendFile(path.join(publicPath, 'index.html')); });
echo function getLocalIP() {
echo     const interfaces = os.networkInterfaces();
echo     for (let name in interfaces) {
echo         for (let iface of interfaces[name]) {
echo             if (iface.family === 'IPv4' ^&& !iface.internal) return iface.address;
echo         }
echo     }
echo     return '127.0.0.1';
echo }
echo app.get('/api/scan', async (req, res) =^> {
echo     const localIP = getLocalIP();
echo     const baseIP = localIP.substring(0, localIP.lastIndexOf('.') + 1);
echo     const devices = [];
echo     const promises = [];
echo     for (let i = 1; i ^<= 254; i++) {
echo         const targetIP = `${baseIP}${i}`;
echo         promises.push(ping.promise.probe(targetIP, { timeout: 1 }).then(result =^> { if (result.alive) devices.push({ ip: targetIP, name: targetIP === localIP ? "Este Computador" : "Dispositivo na Rede", status: "Online" }); }));
echo     }
echo     await Promise.all(promises);
echo     res.json(devices);
echo });
echo app.listen(3000, '0.0.0.0', () =^> console.log('Ativo em http://localhost:3000'));
) > server.js

if not exist "package.json" call npm init -y >nul
call npm install express ping --no-audit --no-fund
call npm install -g pkg --no-audit --no-fund
call pkg server.js --targets node18-win-x64 --output gestor_total.exe
echo [SUCESSO] Ficheiro gestor_total.exe gerado!
pause