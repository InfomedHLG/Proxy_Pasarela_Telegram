# 🌐 Servidor Centralizado Telegram
## 6: 💡 Scripts de Notificación para Telegram

Este conjunto de scripts permite enviar notificaciones automatizadas a través de Telegram para monitorear eventos del servidor.

## 🚀 Scripts Disponibles

## 📝 Descripción
Este script está diseñado para monitorear y notificar sobre accesos SSH a un servidor mediante Telegram. Proporciona información detallada sobre cada intento de acceso, incluyendo datos del servidor, detalles de la conexión y estadísticas relevantes, existe una version sencilla y una avanzada

### EnvioTelegram.sh
Script principal para enviar mensajes a Telegram.

# Guía de Uso de los Scripts de Inicio de Servidor

## Script: `Iniciando_Servidor-1.sh`

Este es una version del script sencilla para el uso de texto plano para el envio de notificaciones a telegram

### Uso

1. **Configuración de Destinatarios:**
   - Edita el script para incluir las direcciones de correo electrónico de los destinatarios en la variable `destinatarios`.

2. **Ejecución del Script:**
   - Ejecuta el script desde la terminal con el siguiente comando:
     ```bash
     ./Iniciando_Servidor-1.sh
     ```

3. **Notificaciones:**
   - El script enviará un mensaje de notificación a través de Telegram utilizando el script `/usr/local/bin/EnvioTelegram.sh`.
   - También enviará un correo electrónico a los destinatarios especificados.


## Script: `Iniciando_Servidor-2.sh`

Este es una version del script para enivar mensajes ya en texto enriquecido para el envio de notificaciones a telegram

## 📋 Funcionalidades

- **Verificación de Servicios**: Monitorea el estado de servicios como SSH, Proxmox, Docker, y más.
- **Estado de Máquinas Virtuales y Contenedores**: Muestra el estado de las máquinas virtuales (VMs) y contenedores LXC en Proxmox.
- **Conectividad a Internet**: Verifica la conectividad a Internet mediante un ping a una dirección IP configurable.
- **Notificaciones**: Envía un mensaje con el estado del servidor a través de un script de envío de Telegram.


## ⚙️ Requisitos

- **Bash**
- `systemctl` para verificar el estado de los servicios
- `qm` y `pct` para listar máquinas virtuales y contenedores en Proxmox
- `ping` para verificar la conectividad a Internet


### Uso

1. **Configuración de Servicios:**

El mismo cuenta con Categorías de Servicios:

Los servicios están organizados en categorías, como servicios básicos del sistema, servicios web, bases de datos, correo, virtualización, contenedores, monitoreo y seguridad, almacenamiento, backup, VPN, DNS, proxy y cache, control de versiones, servicios de red, autenticación, y otros.
Ejemplo de Uso:
Si deseas activar el servicio nginx, simplemente cambia su valor a true:

    ["nginx"]=true

- Esto hará que el script incluya nginx en sus operaciones, como verificar si está activo o enviar notificaciones sobre su estado.

Personalización:
Puedes personalizar el arreglo SERVICES para adaptarlo a las necesidades específicas de tu servidor, activando solo los servicios que son relevantes para tu entorno.


### Visualización de Contenedores


#### `SHOW_CONTAINERS`

- **Descripción**: Esta variable controla si se deben mostrar los contenedores activos de Docker.
- **Configuración**:
  - `SHOW_CONTAINERS=true`: El script mostrará la lista de contenedores activos de Docker, proporcionando información sobre su estado y recursos utilizados.
  - `SHOW_CONTAINERS=false`: El script no mostrará información sobre los contenedores de Docker, lo que puede ser útil si no deseas ver esta información o si estás ejecutando el script en un entorno donde no se utilizan contenedores.

#### `SHOW_CONTAINERS_PVE`

- **Descripción**: Esta variable controla si se deben mostrar los contenedores LXC en Proxmox.
- **Configuración**:
  - `SHOW_CONTAINERS_PVE=true`: El script mostrará la lista de contenedores LXC en Proxmox, permitiendo ver su estado y recursos utilizados.
  - `SHOW_CONTAINERS_PVE=false`: El script no mostrará información sobre los contenedores de Proxmox, lo que puede ser útil si no deseas ver esta información o si estás ejecutando el script en un entorno donde no se utilizan contenedores de Proxmox.



Este script se coloca en el crontab con una tarea de reatardo para que pasado un tiempo despues del inicio del servidor se ejecute y notifique que el mismo inicio

nano /etc/crontab

@reboot root sleep 100 && /usr/local/bin/Iniciando_Servidor-2.sh







# Script de Notificación de Accesos SSH

## 📝 Descripción
Este script está diseñado para monitorear y notificar sobre accesos SSH a un servidor mediante Telegram. Proporciona información detallada sobre cada intento de acceso, incluyendo datos del servidor, detalles de la conexión y estadísticas relevantes, existe una version sencilla y una avanzada

### EnvioTelegram.sh
Script principal para enviar mensajes a Telegram.

# Guía de Uso de los Scripts de Inicio de Servidor

## Script: `notificacion_acceso_ssh-1.sh`

Este es una version del script sencilla para el uso de texto plano para el envio de notificaciones a telegram

### Uso

1. **Configuración de Destinatarios:**
   - Edita el script para incluir las direcciones de correo electrónico de los destinatarios en la variable `destinatarios`.

2. **Ejecución del Script:**
   - Ejecuta el script desde la terminal con el siguiente comando:
     ```bash
     ./notificacion_acceso_ssh-1.sh
     ```

3. **Notificaciones:**  
   - El script enviará un mensaje de notificación a través de Telegram utilizando el script `/usr/local/bin/EnvioTelegram.sh`
   - También enviará un correo electrónico a los destinatarios especificados.


 
## Script: `notificacion_acceso_ssh-2.sh`

Este es una version del script para enivar mensajes ya en texto enriquecido para el envio de notificaciones a telegram y mas detallado


## 🔍 Características Principales
El script recopila y muestra:

### 📍 Detalles del Servidor
- Hostname
- IP Local y Puerto
- Versión SSH

### 👤 Información de Acceso
- Usuario y sus grupos
- Fecha y hora del acceso
- IP y puerto remoto
- Detalles de la sesión (TTY, Shell, PID)

### 🔐 Detalles de Conexión SSH
- Cliente SSH
- TTY SSH
- Tipo y método de autenticación

### 📊 Estadísticas
- Usuarios conectados
- Procesos del usuario
- Intentos fallidos
- Historial de accesos

## 🛠�?Instalación

### 1. Copiar el Script
```bash
# Copiar el script a una ubicación permanente
sudo cp notificacion_acceso_ssh.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/notificacion_acceso_ssh.sh
```



### 2. Configurar la Detección de Accesos

Hay varias opciones para implementar la detección de accesos:

#### Opción 1: /etc/profile.d/ (Recomendada)
```bash
# Crear el archivo
sudo nano /etc/profile.d/ssh-alert.sh

# Añadir el contenido
#!/bin/bash
if [ -n "$SSH_CONNECTION" ]; then
    /usr/local/bin/notificacion_acceso_ssh.sh
fi

# Dar permisos
sudo chmod +x /etc/profile.d/ssh-alert.sh
```

#### Opción 2: /etc/ssh/sshrc
```bash
sudo nano /etc/ssh/sshrc
# Añadir la ruta al script
/usr/local/bin/notificacion_acceso_ssh.sh
sudo chmod +x /etc/ssh/sshrc
```

#### Opción 3: ~/.bash_profile
```bash
nano ~/.bash_profile
# Añadir la línea
/usr/local/bin/notificacion_acceso_ssh.sh
```

#### Opción 4: /etc/pam.d/sshd   -- Mejor opcion
```bash
sudo nano /etc/pam.d/sshd
# Añadir la línea
session optional pam_exec.so /usr/local/bin/notificacion_acceso_ssh.sh
```

## 🚨 Notas Importantes
- El script requiere permisos de ejecución
- Algunos comandos pueden requerir permisos sudo
- Se recomienda probar el script en un entorno controlado primero
- Verificar que el bot de Telegram esté correctamente configurado

## 📫 Notificaciones
Las notificaciones se envían a través de Telegram y contienen:
- Información formateada con emojis
- Secciones claramente separadas
- Detalles técnicos en formato código
- Advertencias sobre la verificación del acceso

## 🔒 Seguridad
- El script no almacena información sensible
- Solo notifica sobre accesos SSH exitosos
- Proporciona información útil para auditoría
- Ayuda a detectar accesos no autorizados

## 🤝 Contribuciones
Siéntete libre de mejorar este script y adaptarlo a tus necesidades específicas.
---


























