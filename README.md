<div align="center">

# 🤖 API de Telegram Bot - Servidor Centralizado

[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker)](https://hub.docker.com/r/ssanchezhlg/bot_telegram_oficial)
[![Telegram](https://img.shields.io/badge/Telegram-Bot_API-26A5E4?style=for-the-badge&logo=telegram)](https://core.telegram.org/bots/api)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

*Una solución empresarial para la gestión centralizada de comunicaciones vía Telegram*

[Características](#características) •
[Instalación](#instalación) •
[Documentación](#documentación) •
[Contribuir](#contribuir)

</div>

---

## 📑 Tabla de Contenidos

<details open>
<summary>Expandir / Colapsar</summary>

## 📑 Índice

1. [Descripción General](#descripción-general)
2. [Especificaciones Técnicas](#especificaciones-técnicas)
3. [📡 API de Mensajería](pasarela/README.md)
4. [🐳 Despliegue con Docker](Docker/README.md)
5. [📜 API de Envio de Telegram](api/README.md)
6. [💡 Scripts de Implementación](scripts/README.md)
7. [📧 MTA para el Envio de Correo](MTA/README.md)


</details>

---

## 🎯 Descripción General

<div align="center">

### 🏗️ Arquitectura Centralizada

<pre>
    🖥️ Servidores        🔄 API Central       📱 Telegram
    ┌──────────┐          ┌──────────┐        ┌──────────┐
    │Servidor 1│─────────►│          │        │          │
    └──────────┘          │          │        │          │
    ┌──────────┐          │   API    │────────► Bot API  │
    │Servidor 2│─────────►│ Central  │  HTTPS │          │
    └──────────┘          │          │        │          │
    ┌──────────┐          │  :8443   │        │          │
    │Servidor 3│─────────►│          │        │          │
    └──────────┘          └──────────┘        └──────────┘
         │                     ▲                   │
         │                     │                   │
         └─────── HTTP/JSON ───┘                   │
                                                  │
    ┌─────────── Características ─────────────────┘
    │ • Control de Acceso Centralizado            │
    │ • Gestión de Mensajes y Archivos            │
    │ • Logs y Monitoreo                          │
    │ • Alta Disponibilidad                       │
    └─────────────────────────────────────────────┘
</pre>


</div>

### ✨ Características Principales

<div class="grid-container">
<div class="grid-item">

#### 🔒 Control de Acceso
- Solo el servidor central necesita acceso a Internet
- Comunicación interna segura
- Superficie de exposición reducida
- Políticas de firewall simplificadas

</div>
<div class="grid-item">

#### 🔄 Gestión de Proxy
- Configuración centralizada
- Sin configuración en clientes
- Cambios simplificados
- Administración eficiente

</div>
</div>

<div class="grid-container">
<div class="grid-item">

#### 📊 Monitoreo y Auditoría
- Registro centralizado
- Logs detallados
- Seguimiento en tiempo real
- Análisis de rendimiento

</div>
<div class="grid-item">

#### ⚡ Optimización
- Rate limits gestionados
- Cola centralizada
- Reintentos automáticos
- Uso eficiente de recursos

</div>
</div>

---

## ⚙️ Especificaciones Técnicas

### 🛠️ Configuración Base

<details>
<summary><b>Parámetros Principales</b></summary>

| Parámetro | Valor | Descripción |
|:---------:|:-----:|:------------|
| Puerto | `8443` | Configurable vía `PORT` |
| Host | `0.0.0.0` | Acceso desde cualquier IP |
| Versión API | `v1` | Versión actual |
| Formato | `JSON` | Formato de datos |

</details>

### 🔐 Variables de Entorno

<details open>
<summary><b>Configuración Requerida</b></summary>

```bash
# Credenciales del Bot
BOT_TOKEN="{token_del_bot_telegram}"       # Token de BotFather
CHAT_ID="{id_del_chat}"                    # ID del grupo/canal

# Seguridad y Configuración
EXPECTED_TOKEN="{token_autenticacion}"     # Token de seguridad
PORT="8443"                                # Puerto de escucha
proxy_address="None"                       # Configuración de proxy
```

</details>

---




## ���� Contribuir

¿Encontraste un bug? ¿Tienes una idea? ¡Nos encantaría escucharte!

[![Issues](https://img.shields.io/badge/Issues-Reportar_Bug-red?style=for-the-badge&logo=github)](https://github.com/InfomedHLG/Proxy_Pasarela_Telegram/issues)
[![PRs](https://img.shields.io/badge/PRs-Bienvenidos-brightgreen?style=for-the-badge&logo=github)](https://github.com/InfomedHLG/Proxy_Pasarela_Telegram)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

---

<sub>Desarrollado con ❤️ por el equipo de desarrollo</sub>

</div>