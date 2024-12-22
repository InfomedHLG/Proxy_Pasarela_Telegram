#!/bin/bash

# prepare any message you want
ip="$(echo $SSH_CONNECTION | cut -d " " -f 1)"
date="$(date +"%A, %e de %B de %Y, %r" | sed 's/./\L&/g')"
name="$(whoami)"
hostname="$(hostname -f)"
proxmox="Server"

destinatarios="scripts/Iniciando_Servidor-1.sh"


asunto="ALERTA: Acceso a Terminal de Root en [ $hostname - $proxmox ]"
message="Se ha detectado un acceso a la Terminal de Root en el servidor [ $hostname - $proxmox] \n\nA continuación se muestran los detalles del acceso:\n\n\n\nUsuario: $name\nFecha de Acceso: $date\nIP de Acceso: $ip\n\n\n\n\n\n\n\nPor favor, verifica que este acceso fue autorizado y toma las medidas necesarias para garantizar la seguridad del servidor.\n\nAtentamente, \nEl equipo de administración de sistemas - Servidor de Ejemplo\nEsta dirección electrónica está protegida contra spam bots"





## Envio de la notificación a Telegram
/usr/local/bin/EnvioTelegram.sh "$message"

## Envio de la notificación por Correo
echo -e "$message" | mailx -s "$asunto" $destinatarios


