# 🌐 Servidor Centralizado Telegram

## 🚀 5: 📜 API de Envío de Telegram

### Uso del Script

#### Sintaxis Básica
```bash
./EnvioTelegram.sh "mensaje" "topic_id" "ruta_archivo"
```

#### Parámetros
1. **`mensaje`** (obligatorio): Texto que se enviará a Telegram.
2. **`topic_id`** (obligatorio): ID del tema/grupo de Telegram.
3. **`ruta_archivo`** (opcional): Ruta al archivo que se desea adjuntar.

#### Ejemplos de Uso
```bash
# Enviar solo mensaje
./EnvioTelegram.sh "Hola Mundo" "123456"

# Enviar mensaje con archivo
./EnvioTelegram.sh "Reporte adjunto" "123456" "/ruta/al/archivo.pdf"
```

## Características Principales

### 🔄 Alta Disponibilidad
- Múltiples servidores de respaldo.
- Verificación de estado.
- Failover automático.
- Comprobación de salud.

### 📨 Sistema de Mensajería
- Soporte HTML y texto plano.
- División automática de mensajes.
- Gestión de adjuntos.
- Soporte para topics.

### Sistema de Logs
- Rotación automática diaria de logs.
- Compresión de logs antiguos.
- Diferentes niveles de log (INFO, ERROR, WARN, SUCCESS, DEBUG).
- Limpieza automática de logs antiguos.

### Sistema de Cola
- Almacenamiento automático de mensajes fallidos.
- Reintentos automáticos al restaurar conexión.
- Preservación del orden de los mensajes.
- Manejo de archivos adjuntos en cola.

### Manejo de Conexiones
- Verificación de disponibilidad de servidores.
- Comprobación de estado de API.
- Failover automático entre servidores.
- Timeout configurable en conexiones.

### Características de Mensajería
- Soporte para formato HTML.
- División automática de mensajes largos (límite 4096 caracteres).
- Soporte para archivos adjuntos.
- Manejo de topics/grupos.

## Requisitos de Instalación

### Dependencias
```bash
# Instalar jq para procesamiento JSON
sudo apt-get install jq

# Instalar curl para transferencia de datos
sudo apt-get install curl
```

### Permisos Necesarios
```bash
# Dar permisos de ejecución al script
chmod +x EnvioTelegram.sh

# Asegurar permisos de escritura en directorio de logs
chmod 755 /home/python/servercentralizado/logs
```

## Manejo de Errores
- Validación de argumentos requeridos.
- Verificación de permisos de escritura.
- Manejo de interrupciones (SIGINT, SIGTERM).
- Registro detallado de errores en logs.

## Notas Adicionales
- Los mensajes HTML deben estar correctamente formateados.
- Los archivos adjuntos deben ser accesibles por el usuario que ejecuta el script.
- El sistema de cola es persistente entre reinicios.
- Los logs se comprimen automáticamente después de `MAX_LOG_DAYS`.

---

[⬆️ Volver al inicio del repositorio](https://github.com/InfomedHLG/Proxy_Pasarela_Telegram)

---

[⬆️ Volver al inicio del repositorio](../)