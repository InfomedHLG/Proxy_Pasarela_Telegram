# 🌐 Servidor Centralizado Telegram
## 4: 🐳 Despliegue con Docker

### 📦 Instalación Rápida

```bash
docker run -d \
  --name bot_telegram \
  --restart always \
  -p 8443:8443 \
  -e PORT=8443 \
  -e BOT_TOKEN=your_token \
  -e CHAT_ID=your_chat_id \
  -e EXPECTED_TOKEN=your_auth_token \
  -v /path/to/logs:/srv/log \
  ssanchezhlg/bot_telegram_oficial:1.3
```

### 📦 Instalación con Docker Compose

Crea un archivo `docker-compose.yml`:

```yaml
version: '3.8'

services:
  bot_telegram:
    image: ssanchezhlg/bot_telegram_oficial:1.3
    restart: always
    container_name: bot_telegram
    ports: 
      - '8443:8443'
    environment:
      - PORT=8443
      - BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz123456789
      - CHAT_ID=-100987654321
      - EXPECTED_TOKEN=abc123def456ghi789jkl012mno345pqr678
      - proxy_address=                                    
    volumes:
      - './logs:/srv/log'
```

Inicia el servicio con:
```bash
docker-compose up -d
```

### 📋 Instalación con Portainer Stack

Crea un nuevo stack en Portainer y usa esta configuración:

```yaml
version: "3"

services:
  bot_telegram:
    image: ssanchezhlg/bot_telegram_oficial:1.3
    restart: always
    container_name: bot_telegram
    ports: 
      - '8443:8443'
    environment:
      - SERVER_PORT=8443
      - BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz123456789
      - CHAT_ID=-100987654321
      - EXPECTED_TOKEN=abc123def456ghi789jkl012mno345pqr678
      - proxy_address=192.168.1.100:3128                    # Usar 'none' si no se requiere proxy
      - LOG_DIR=/var/log/telegram-bot
    volumes:
      - 'bot-telegram_volumen:/var/log/telegram-bot' 
      
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints: []  	
        
volumes:
  bot-telegram_volumen:
    driver: local
    driver_opts:
      type: "nfs4"
      o: addr=192.168.1.250,nolock,soft,rw
      device: ":/storage/docker/telegram-bot"  
```

### 📋 Parámetros Docker

| Parámetro | Descripción |
|:---------:|:------------|
| `-d` | Ejecución en segundo plano |
| `--name` | Nombre del contenedor |
| `--restart` | Política de reinicio |
| `-p` | Mapeo de puertos |
| `-e` | Variables de entorno |
| `-v` | Volumen para logs |

> 💡 **Tip**: Verifica la instalación accediendo a `http://IP:8443`

## 📡 API de Mensajería

### 📤 Endpoints Disponibles

<details open>
<summary><b>Envío de Mensaje Simple</b></summary>

```bash
curl -X POST http://127.0.0.1:8443 \
    -H "Content-Type: application/json" \
    -d '{
        "token": "your_auth_token",
        "message": {
            "text": "Mensaje de prueba",
            "topic_id": "2"
        }
    }'
```
</details>

<details>
<summary><b>Mensaje con Formato HTML</b></summary>

```bash
curl -X POST http://127.0.0.1:8443 \
    -H "Content-Type: application/json" \
    -d '{
        "token": "your_auth_token",
        "message": {
            "text": "<b>Mensaje</b> con <i>formato</i>",
            "topic_id": "2"
        }
    }'
```
</details>

<details>
<summary><b>Envío con Archivo Adjunto</b></summary>

```bash
curl -X POST http://127.0.0.1:8443 \
    -H "Content-Type: application/json" \
    -d '{
        "token": "your_auth_token",
        "message": {
            "text": "Archivo adjunto",
            "topic_id": "2",
            "file_path": "/ruta/al/archivo"
        }
    }'
```
</details>

### 📊 Códigos de Respuesta

| Código | Estado | Descripción |
|:------:|:------:|:------------|
| 200 | ✅ Éxito | Operación completada |
| 400 | ❌ Error | JSON inválido |
| 403 | 🚫 Prohibido | Token inválido |
| 404 | 🔍 No encontrado | Archivo no existe |
| 500 | ⚠️ Error | Error del servidor |


---
[⬆️ Volver al inicio del repositorio](../)

  