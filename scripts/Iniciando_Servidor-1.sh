#!/bin/bash

# prepare any message you want
date="$(date +"%A, %e de %B de %Y, %r" | sed 's/./\L&/g')"
hostname="$(hostname -f)"
proxmox="Server"

destinatarios="usuario1@ejemplo.com,usuario2@ejemplo.com" 

asunto="Iniciando Servidor [ $hostname - $proxmox ]"
message="El Servidor [ $hostname - $proxmox ] acaba de iniciarse correctamente.\n\n¡Todo está listo para comenzar a trabajar!\n\n\n\n- Fecha y hora: $date\n\n\n\n¡Que tengas un excelente día!\n\nEl asistente virtual - Servidor de Ejemplo\nEsta dirección electrónica está protegida contra spam bots"


## Envio de la notificación a Telegram
/usr/local/bin/EnvioTelegram.sh "$message"

## Envio de la notificación por Correo
echo -e "$message" | mailx -s "$asunto" $destinatarios



