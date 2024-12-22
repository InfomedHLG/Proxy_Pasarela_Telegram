#!/bin/bash
# Version 2

# Configuración de variables
VERBOSE=false
TOPIC_ID=""
SHOW_CONTAINERS=true  # Variable para controlar la visualización de contenedores
SCRIPT_TELEGRAM="/usr/local/bin/EnvioTelegram.sh"  # Ruta completa con nombre del script
PING_IP="10.10.10.1"  # IP para verificar conectividad
SHOW_CONTAINERS_PVE=true
destinatarios="usuario1@ejemplo.com,usuario2@ejemplo.com"

# Configuración de servicios (true para activar, false para desactivar)
declare -A SERVICES=(
    # Servicios básicos del sistema
    ["ssh"]=true
    ["cron"]=false
    ["systemd-resolved"]=false
    ["systemd-timesyncd"]=false
    
    # Servicios Web
    ["nginx"]=false
    ["apache2"]=false
    ["php-fpm"]=false
    ["tomcat"]=false
    
    # Bases de datos
    ["mysql"]=false
    ["postgresql"]=false
    ["mongodb"]=false
    ["redis-server"]=false
    ["memcached"]=false
    
    # Correo
    ["postfix"]=false
    ["dovecot"]=false
    ["amavis"]=false
    ["spamassassin"]=false
    ["opendkim"]=false
    
    # Virtualización
    ["pve-cluster"]=false    
    ["pvedaemon"]=false      
    ["pveproxy"]=false
    ["qemu-guest-agent"]=false
    ["libvirtd"]=false
    
    # Contenedores
    ["docker"]=true
    ["containerd"]=false
    ["kubernetes"]=false
    ["k3s"]=false
    ["podman"]=false
    
    # Monitoreo y Seguridad
    ["fail2ban"]=false
    ["ufw"]=false
    ["iptables"]=false
    ["snmpd"]=false
    ["prometheus"]=false
    ["grafana-server"]=false
    ["zabbix-agent"]=false
    ["nagios-nrpe-server"]=false
    
    # Almacenamiento
    ["nfs-kernel-server"]=false
    ["samba"]=false
    ["vsftpd"]=false
    ["proftpd"]=false
    
    # Backup
    ["bacula-fd"]=false
    ["duplicati"]=false
    ["rsync"]=false
    
    # VPN
    ["openvpn"]=false
    ["wireguard"]=false
    
    # DNS
    ["bind9"]=false
    ["dnsmasq"]=false
    
    # Proxy y Cache
    ["squid"]=false
    ["varnish"]=false
    ["haproxy"]=false
    
    # Control de versiones
    ["gitlab-runner"]=false
    ["jenkins"]=false
    
    # Servicios de red
    ["network-manager"]=false
    ["isc-dhcp-server"]=false
    ["tftp"]=false
    
    # Autenticación
    ["slapd"]=false
    ["freeradius"]=false
    ["sssd"]=false
    
    # Otros
    ["elasticsearch"]=false
    ["kibana"]=false
    ["logstash"]=false
    ["rabbitmq-server"]=false
    ["mosquitto"]=false
    
    # Proxmox (simplificado a un solo servicio)
    ["proxmox"]=false
)

# Función para verificar conectividad
check_internet() {
    if ping -c 1 "$PING_IP" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Función para verificar servicios
check_services() {
    local status=""
    for service in "${!SERVICES[@]}"; do
        if [[ ${SERVICES[$service]} == true ]]; then
            # Caso especial para Proxmox
            if [[ "$service" == "proxmox" ]]; then
                # Verificar si al menos uno de los servicios principales está activo
                if systemctl is-active pve-cluster >/dev/null 2>&1 || \
                   systemctl is-active pvedaemon >/dev/null 2>&1 || \
                   systemctl is-active pveproxy >/dev/null 2>&1; then
                    status+="✅ $service "
                else
                    status+="❌ $service "
                fi
            else
                # Para el resto de servicios
                if systemctl is-active --quiet $service; then
                    status+="✅ $service "
                else
                    status+="❌ $service "
                fi
            fi
        fi
    done
    echo $status
}

# Función para verificar contenedores Docker
check_docker_containers() {
    if command -v docker &> /dev/null; then
        local containers=""
        local count=0
        
        while IFS= read -r container; do
            local name=$(echo "$container" | awk '{print $NF}')
            containers+="✅ $name "
            ((count++))
            
            if ((count % 4 == 0)); then
                containers+="\n"
            fi
        done < <(docker ps --format "{{.Names}}")
        
        if ((count % 4 != 0)); then
            containers+="\n"
        fi
        
        echo "$containers"
    fi
}

# Función mejorada para verificar VMs y Contenedores de Proxmox
check_pve_containers() {
    local output=""
    
    # Listar Máquinas Virtuales (qm)
    output+="🖥️ <b>Máquinas Virtuales:</b>\n"
    local count=0
    
    while IFS= read -r line; do
        if [[ -n "$line" && "$line" != *"VMID"* ]]; then
            local vmid=$(echo "$line" | awk '{print $1}')
            local name=$(echo "$line" | awk '{print $2}')
            local status=$(echo "$line" | awk '{print $3}')
            
            if [[ "$status" == "running" ]]; then
                output+="✅ $name "
            else
                output+="❌ $name "
            fi
            ((count++))
            
            if ((count % 4 == 0)); then
                output+="\n"
            fi
        fi
    done < <(qm list | grep -v "VMID")
    
    if ((count % 4 != 0)); then
        output+="\n"
    fi
    
    # Listar Contenedores LXC (pct)
    output+="\n📦 <b>Contenedores LXC:</b>\n"
    count=0
    
    while IFS= read -r line; do
        if [[ -n "$line" && "$line" != *"VMID"* ]]; then
            local vmid=$(echo "$line" | awk '{print $1}')
            local name=$(pct config "$vmid" | grep "hostname:" | cut -d" " -f2)
            local status=$(echo "$line" | awk '{print $2}')
            
            if [[ "$status" == "running" ]]; then
                output+="✅ $name "
            else
                output+="❌ $name "
            fi
            ((count++))
            
            if ((count % 4 == 0)); then
                output+="\n"
            fi
        fi
    done < <(pct list)
    
    if ((count % 4 != 0)); then
        output+="\n"
    fi
    
    echo "$output"
}

# Procesar argumentos
while getopts "t:m:vs:lc:i:p:" opt; do
    case $opt in
        t) TOPIC_ID="$OPTARG" ;;
        m) MENSAJE_CUSTOM="$OPTARG" ;;
        v) VERBOSE=true ;;
        c) SHOW_CONTAINERS="$OPTARG" ;;  # true o false
        p) SHOW_CONTAINERS_PVE="$OPTARG" ;;  # Nueva opción para Proxmox
        i) PING_IP="$OPTARG" ;;  # Nueva opción para la IP
        s) # Activar/desactivar servicios específicos
           IFS=',' read -ra SRV_ARRAY <<< "$OPTARG"
           for srv in "${SRV_ARRAY[@]}"; do
               IFS=':' read -r name state <<< "$srv"
               if [[ -n "${SERVICES[$name]}" ]]; then
                   SERVICES[$name]=$state
               fi
           done
           ;;
        l) # Listar servicios disponibles
           echo "Servicios disponibles y su estado actual:"
           for srv in "${!SERVICES[@]}"; do
               echo "$srv: ${SERVICES[$srv]}"
           done
           exit 0
           ;;
        ?) echo "Uso: $0 [-t topic_id] [-m mensaje] [-v] [-s servicio1:true,servicio2:false] [-l] [-c true|false] [-i ip_address] [-p true|false]" >&2; exit 1 ;;
    esac
done

# Obtener información del sistema
ip="$(echo $SSH_CONNECTION | cut -d " " -f 1)"
[[ -z "$ip" ]] && ip="$(hostname -I | awk '{print $1}')"
date="$(date +"%A, %e de %B de %Y, %r" | sed 's/./\L&/g')"
name="$(whoami)"
hostname="$(hostname -f)"
uptime="$(uptime -p)"
memoria="$(free -h | awk '/^Mem/ {print $3 "/" $2}')"
disco="$(df -h / | awk 'NR==2 {print $5}')"
carga_cpu="$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')"
servicios="$(check_services)"
internet_status=$(check_internet && echo "✅ Conectado" || echo "❌ Sin conexión")

# Construir el mensaje
message="🌟 <b>Notificación de Estado del Servidor</b> 🌟\n\n"
message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
message+="🖥️ <b>Servidor:</b> [ $hostname ]\n"
message+="📊 <b>Estado:</b> ✅ Operativo\n"
message+="👤 <b>Usuario:</b> $name\n"
message+="🌐 <b>IP:</b> $ip\n"
message+="🕒 <b>Fecha y Hora:</b> $date\n\n"
message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
message+="📈 <b>Estadísticas del Sistema:</b>\n"
message+="⏰ <b>Tiempo activo:</b> $uptime\n"
message+="💾 <b>Uso de memoria:</b> $memoria\n"
message+="💽 <b>Uso de disco:</b> $disco\n"
message+="🔄 <b>Carga CPU:</b> ${carga_cpu}%\n"
message+="🌐 <b>Internet:</b> $internet_status\n"
message+="🔌 <b>Servicios Activos:</b> $servicios\n\n"

# Sección de Docker si está activo
if [[ ${SERVICES["docker"]} == true && $SHOW_CONTAINERS == true ]]; then
    containers=$(check_docker_containers)
    if [[ -n "$containers" ]]; then
        message+="━━━━━━━━━━━━━━━━━━━━━━\n"
        message+="🐳 <b>Contenedores:</b>\n"
        message+="$containers\n"
    fi
fi

# Sección de bases de datos si están activas
if [[ ${SERVICES["mysql"]} == true || ${SERVICES["postgresql"]} == true || ${SERVICES["mongodb"]} == true ]]; then
    message+="━━━━━━━━━━━━━━━━━━━━━━\n"
    message+="🗄️ <b>Estado Bases de Datos:</b>\n"
    [[ ${SERVICES["mysql"]} == true ]] && message+="📊 <b>MySQL:</b> $(systemctl is-active mysql)\n"
    [[ ${SERVICES["postgresql"]} == true ]] && message+="🐘 <b>PostgreSQL:</b> $(systemctl is-active postgresql)\n"
    [[ ${SERVICES["mongodb"]} == true ]] && message+="🍃 <b>MongoDB:</b> $(systemctl is-active mongodb)\n"
    message+="\n"
fi

# Sección de servicios de correo si están activos
if [[ ${SERVICES["postfix"]} == true || ${SERVICES["dovecot"]} == true ]]; then
    message+="━━━━━━━━━━━━━━━━━━━━━━\n"
    message+="📧 <b>Estado Servicios de Correo:</b>\n"
    [[ ${SERVICES["postfix"]} == true ]] && message+="📨 <b>Postfix:</b> $(systemctl is-active postfix)\n"
    [[ ${SERVICES["dovecot"]} == true ]] && message+="📥 <b>Dovecot:</b> $(systemctl is-active dovecot)\n"
    message+="\n"
fi

# Sección de Proxmox si está activo
if [[ ${SERVICES["pve-cluster"]} == true || ${SERVICES["pvedaemon"]} == true || ${SERVICES["pveproxy"]} == true ]]; then
    message+="━━━━━━━━━━━━━━━━━━━━━━\n"
    message+="🖥️ <b>Estado Proxmox:</b>\n"
    [[ ${SERVICES["pve-cluster"]} == true ]] && message+="🔄 <b>Cluster:</b> $(systemctl is-active pve-cluster)\n"
    [[ ${SERVICES["pvedaemon"]} == true ]] && message+="👾 <b>Daemon:</b> $(systemctl is-active pvedaemon)\n"
    [[ ${SERVICES["pveproxy"]} == true ]] && message+="🌐 <b>Proxy:</b> $(systemctl is-active pveproxy)\n"
    message+="\n"
fi

# Sección de Proxmox VE
if [[ ${SERVICES["proxmox"]} == true && $SHOW_CONTAINERS_PVE == true ]]; then
    message+="━━━━━━━━━━━━━━━━━━━━━━\n"
    message+="🖥️ <b>Proxmox VE:</b>\n"
    
    # Verificar servicios principales de Proxmox
    for pve_service in pve-cluster pvedaemon pveproxy; do
        status=$(systemctl is-active $pve_service)
        if [[ "$status" == "active" ]]; then
            message+="✅ $pve_service\n"
        else
            message+="❌ $pve_service\n"
        fi
    done
    
    # Mostrar VMs y Contenedores
    containers_pve=$(check_pve_containers)
    if [[ -n "$containers_pve" ]]; then
        message+="\n$containers_pve"
    fi
fi

message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
message+="✨ ¡Sistema listo y funcionando!\n"
message+="📝 Todas las funciones están operativas\n"
message+="🔒 Seguridad activada y monitoreando\n\n"
message+="━━━━━━━━━━━━━━━━━━━━━━\n\n"
message+="💫 <i>¡Que tengas un excelente día!</i>\n\n"
message+="🤖 <b>Asistente Virtual</b>\n"
message+="🏥 <i>Servidor de Ejemplo</i>\n\n"
message+="<code>Esta es una notificación automática del sistema</code>"

# Función para enviar mensaje
enviar_mensaje() {
    if [[ $VERBOSE == true ]]; then
        echo "Enviando mensaje..."
    fi
    
    if "$SCRIPT_TELEGRAM" "$message"; then
        echo "✅ Mensaje enviado exitosamente"
        return 0
    else
        echo "❌ Error al enviar el mensaje"
        return 1
    fi
}

# Enviar mensaje y manejar errores
if ! enviar_mensaje; then
    echo "Error: Falló el envío del mensaje" >&2
    exit 1
fi

asunto="Iniciando Servidor [ $hostname - $(date +"%d/%m/%Y %H:%M") ]"


# Preparar mensaje para correo con saltos de línea HTML
mensaje_correo=$(echo -e "$message" | sed ':a;N;$!ba;s/\n/<br>/g')

echo -e "$mensaje_correo" | iconv -f UTF-8 -t UTF-8//IGNORE | mailx -a "Content-Type: text/html; charset=UTF-8" --return-address="monitoreo@ejemplo.com" -s "$asunto" $destinatarios



exit 0
