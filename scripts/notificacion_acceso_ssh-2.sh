#!/bin/bash

if [ "$PAM_SERVICE" = "sshd" ]; then
    TIPO_ACCESO="SSH"
else
    TIPO_ACCESO="consola"
fi

# Recopilación de información básica del acceso
if [ "$TIPO_ACCESO" = "SSH" ]; then
    login_ip="$(echo $SSH_CONNECTION | cut -d " " -f 1)"
    login_port="$(echo $SSH_CONNECTION | cut -d " " -f 2)"
    server_ip="$(echo $SSH_CONNECTION | cut -d " " -f 3)"
    server_port="$(echo $SSH_CONNECTION | cut -d " " -f 4)"
else
    login_ip="localhost"
    login_port="N/A"
    server_ip="$(hostname -I | awk '{print $1}')"
    server_port="N/A"
fi

# Información detallada de la sesión
login_shell="$(echo $SHELL)"
login_tty="$(tty)"
ssh_client="$(echo $SSH_CONNECTION | cut -d' ' -f1,2)"
ssh_tty="$(who -m | awk '{print $2}')"
ssh_connection_type="$(grep -i "Accepted" /var/log/auth.log | grep "$login_ip" | tail -1 | awk '{print $7}')"
tipo_autenticacion="$(grep -i "Accepted" /var/log/auth.log | grep "$login_ip" | tail -1 | awk '{print $7" "$8}')"
terminal="$(echo $TERM)"
login_pid="$(echo $$)"
session_id="$(who -m | awk '{print $2}')"

# Información adicional de seguridad
ultimo_acceso_exitoso="$(last -1 $login_name | head -1 | awk '{print $5,$6,$7,$8}')"
ultimo_acceso_fallido="$(last -f /var/log/btmp $login_name | head -1 2>/dev/null)"
total_usuarios_conectados="$(who | wc -l)"
procesos_usuario="$(ps -u $login_name | wc -l)"
tipo_autenticacion="$(grep -i "Accepted" /var/log/auth.log | grep "$login_ip" | tail -1)"
version_ssh="$(ssh -V 2>&1)"
permisos_usuario="$(groups $login_name)"
intentos_fallidos="$(grep "Failed password" /var/log/auth.log | grep $login_ip | wc -l)"

# Construir mensaje detallado
message="🚨 <b>ALERTA DE SEGURIDAD - Acceso por $TIPO_ACCESO Detectado</b> 🚨\n\n"
message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
message+="📍 <b>Detalles del Servidor:</b>\n"
message+="• Hostname: <code>$login_hostname</code>\n"
message+="• IP Local: <code>$server_ip</code>\n"
message+="• Puerto Local: <code>$server_port</code>\n"
message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
message+="👤 <b>Información de Acceso:</b>\n"
message+="• Usuario: <code>$login_name</code>\n"
message+="• Grupos: <code>$permisos_usuario</code>\n"
message+="• Fecha: <code>$login_date</code>\n"
message+="• IP Remota: <code>$login_ip</code>\n"
message+="• Puerto Remoto: <code>$login_port</code>\n"
message+="• Shell: <code>$login_shell</code>\n"
message+="• TTY: <code>$login_tty</code>\n"
message+="• Terminal: <code>$terminal</code>\n"
message+="• PID Sesión: <code>$login_pid</code>\n"
message+="• ID Sesión: <code>$session_id</code>\n\n"
message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"

# Modificar la sección de detalles según el tipo de acceso
if [ "$TIPO_ACCESO" = "SSH" ]; then
    message+="🔐 <b>Detalles de Conexión SSH:</b>\n"
    message+="• IP y Puerto Cliente: <code>$ssh_client</code>\n"
    message+="• TTY: <code>$ssh_tty</code>\n"
    message+="• Tipo de Conexión: <code>$ssh_connection_type</code>\n"
    message+="• Método de Autenticación: <code>$tipo_autenticacion</code>\n\n"
    message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
else
    message+="🖥️ <b>Detalles de Conexión Local:</b>\n"
    message+="• TTY: <code>$login_tty</code>\n"
    message+="• Terminal: <code>$terminal</code>\n\n"
    message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
fi

message+="📊 <b>Estadísticas:</b>\n"
message+="• Usuarios Conectados: <code>$total_usuarios_conectados</code>\n"
message+="• Procesos del Usuario: <code>$procesos_usuario</code>\n"
message+="• Intentos Fallidos: <code>$intentos_fallidos</code>\n"
message+="• Último Acceso Exitoso: <code>$ultimo_acceso_exitoso</code>\n"
[ ! -z "$ultimo_acceso_fallido" ] && message+="• Último Intento Fallido: <code>$ultimo_acceso_fallido</code>\n\n"
message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
message+="⚠️ <i>Por favor, verifique si este acceso es autorizado.</i>\n\n"
message+="🤖 <b>Sistema Automatizado de Monitoreo</b>\n"
message+="🏥 <i>Nodo Infomed Holguín</i>\n\n"
message+="<code>Esta es una notificación automática del sistema</code>"

asunto="🚨 ALERTA DE SEGURIDAD - Acceso por $TIPO_ACCESO Detectado 🚨"

# Enviar notificación a Telegram
/usr/local/bin/EnvioTelegram.sh "$message" "$TOPIC" 


# Preparar mensaje para correo con saltos de línea HTML
mensaje_correo=$(echo -e "$message" | sed ':a;N;$!ba;s/\n/<br>/g')

# Opcional: Enviar por correo
echo -e "$mensaje_correo" | iconv -f UTF-8 -t UTF-8//IGNORE | mailx -a "Content-Type: text/html; charset=UTF-8" -s "$asunto" ssanchezhlg@infomed.sld.cu salbi@nauta.cu

