# 🌐 Servidor Centralizado Telegram

## 3: 📡 API de Mensajería

### 1. Instalación de Python y Dependencias

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv supervisor
```

### 2. Creación y Activación del Entorno Virtual

```bash
python3 -m venv venv
source venv/bin/activate  # Linux
```

### 3. Instalación de Dependencias

```bash
pip install requests psutil
```

### 4. Configuración de Variables de Entorno

```bash
export BOT_TOKEN="tu_token"
export CHAT_ID="tu_chat_id"
export EXPECTED_TOKEN="tu_token_seguridad"
export PORT="8443"
```

### 5. Configuración del Script de Inicio

```bash
nano /etc/supervisor/conf.d/telegram_server.conf
```

Contenido del archivo:

```
[program:telegram_server]
command=/ruta/al/venv/bin/python /ruta/al/script/ServerCentralizadoTelegram.py
directory=/ruta/al/script
user=www-data
autostart=true
autorestart=true
stderr_logfile=/var/log/telegram_server.err.log
stdout_logfile=/var/log/telegram_server.out.log
environment=
   BOT_TOKEN="tu_token",
   CHAT_ID="tu_chat_id",
   EXPECTED_TOKEN="tu_token_seguridad",
   PORT="8443"
```

### 6. Permisos y Actualización de Supervisor

```bash
chmod +x ServerCentralizadoTelegram.py
sudo supervisorctl reread
sudo supervisorctl update
```

### 7. Comandos Útiles de Supervisor

```bash
sudo supervisorctl status telegram_server  # Ver estado
sudo supervisorctl start telegram_server   # Iniciar
sudo supervisorctl stop telegram_server    # Detener
sudo supervisorctl restart telegram_server # Reiniciar
```

## ⚙️ Método 2: Instalación Directa

### 1. Instalación de Python y Dependencias

```bash
sudo apt update
sudo apt install python3 python3-pip gunicorn
pip3 install requests
```

### 2. Configuración de Variables de Entorno

```bash
sudo nano /etc/environment
```

Agregar:

```
BOT_TOKEN="tu_token"
CHAT_ID="tu_chat_id"
EXPECTED_TOKEN="tu_token_seguridad"
PORT="8443"
```

### 3. Creación del Servicio systemd

```bash
sudo nano /etc/systemd/system/telegram-server.service
```

Contenido del archivo:

```
[Unit]
Description=Telegram Server Service
After=network.target

[Service]
User=www-data
WorkingDirectory=/ruta/a/tu/script
Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ExecStart=gunicorn -b 0.0.0.0:8443 ServerCentralizadoTelegram:httpd
Restart=always

[Install]
WantedBy=multi-user.target
```

### 4. Habilitación e Inicio del Servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable telegram-server
sudo systemctl start telegram-server
```

### 5. Verificación del Estado

```bash
sudo systemctl status telegram-server
```

## 🔍 Verificación

Probar el servidor:

```bash
curl -X POST https://tu_ip_publica:8443/webhook -d "token=tu_token_seguridad"
```

## 📜 Logs

Ver logs del servicio:

```bash
sudo journalctl -u telegram-server -f
```

## 📝 Notas

- **Puerto por defecto:** 8443
- **Logs en:** `/srv/log/telegram-bot_servercentralizado.log`
- **Requiere permisos de escritura en** `/srv/log`

---
[⬆️ Volver al inicio del repositorio](https://github.com/InfomedHLG/Proxy_Pasarela_Telegram)

---
[⬆️ Volver al inicio del repositorio](../)