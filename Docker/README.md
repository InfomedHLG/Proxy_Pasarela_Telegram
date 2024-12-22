# 🌐 Servidor Centralizado Telegram

## 5: 🐳 Creación, Subida de la Imagen Docker y Despliegue con Docker

### 🚀 Construir la Imagen

Asegúrate de tener un `Dockerfile` configurado correctamente en tu proyecto. Luego, ejecuta el siguiente comando para construir la imagen:

```bash
docker build -t tu_usuario/tu_imagen:1.0 .
```

Reemplaza `tu_usuario/tu_imagen:1.0` con el nombre que desees para tu imagen.

### 🔑 Iniciar Sesión en Docker Hub

Si aún no lo has hecho, inicia sesión en Docker Hub:

```bash
docker login
```

Ingresa tus credenciales de Docker Hub cuando se te solicite.

### ☁️ Subir la Imagen al Repositorio

Una vez que la imagen esté construida, puedes subirla a tu repositorio personal en Docker Hub:

```bash
docker push tu_usuario/tu_imagen:1.0
```

Asegúrate de reemplazar `tu_usuario/tu_imagen:1.0` con el nombre de tu imagen.

## 2: 🐳 Despliegue con Docker

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
  tu_usuario/tu_imagen:1.0
```

### 📦 Instalación con Docker Compose

Crea un archivo `docker-compose.yml`:

```yaml
version: '3.8'

services:
  bot_telegram:
    image: tu_usuario/tu_imagen:1.0
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
    image: tu_usuario/tu_imagen:1.0
    restart: always
    container_name: bot_telegram
    ports: 
      - '8443:8443'
    environment:
      - SERVER_PORT=8443
      - BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz123456789
      - CHAT_ID=-1234567890
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

## 3: 📋 Parámetros Docker

| Parámetro | Descripción |
|:---------:|:------------|
| `-d` | Ejecución en segundo plano |
| `--name` | Nombre del contenedor |
| `--restart` | Política de reinicio |
| `-p` | Mapeo de puertos |
| `-e` | Variables de entorno |
| `-v` | Volumen para logs |

> 💡 **Tip**: Verifica la instalación accediendo a `http://IP:8443`

## 4: 📡 API de Mensajería

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

  