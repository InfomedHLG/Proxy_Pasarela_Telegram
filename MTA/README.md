# 🌐 Servidor Centralizado Telegram

## 7: 📧 MTA para el Envio de Correo

## Descripción

En caso de querer enviar correos electrónicos desde el servidor, se debe configurar el MTA (Mail Transfer Agent) para el envío de correos electrónicos a través de la línea de comandos utilizando `mailx`. Es ideal para automatizar notificaciones y mensajes desde sistemas basados en Linux.

## Instalación

Para instalar y configurar el entorno necesario para utilizar este servidor, sigue los siguientes pasos:


1. **Instalar `msmtp`**:
   `msmtp` es un cliente SMTP que se puede utilizar como un agente de transporte de correo (MTA) para enviar correos electrónicos. Para instalarlo, ejecuta:
   ```bash
   sudo apt-get install msmtp
   ```


2. **Instalar `mailx`**:
   ```bash
   sudo apt-get update
   sudo apt-get install mailutils
   ```

3. **Configurar `msmtp`**:
   Crea o edita el archivo de configuración `~/.msmtprc` con los detalles de tu servidor SMTP. Asegúrate de que el archivo tenga permisos seguros:
   ```bash
   chmod 600 ~/.msmtprc
   ```

   Un ejemplo de configuración para Gmail podría ser:
   ```plaintext
   account default
   host smtp.gmail.com
   port 587
   auth on
   user tu_correo@gmail.com
   password tu_contraseña
   tls on
   tls_trust_file /etc/ssl/certs/ca-certificates.crt
   ```

aqui viene un ejemplo de como se debe configurar el archivo de configuracion de msmtp

## Modo de uso

Para especificar la cuenta que deseas usar con el comando `mailx`, puedes utilizar diferentes opciones. Aquí te muestro varias formas:

1. **Usando la opción -a (account)**:
```bash
echo "Este es un mensaje de prueba" | mailx -s "Asunto" -a gmail usuario@ejemplo.com
```

2. **Usando la opción -r (from)**:
```bash
echo "Este es un mensaje de prueba" | mailx -s "Asunto" -r "tu_correo@gmail.com" usuario@ejemplo.com
```

3. **Combinando opciones para más control**:
```bash
# Con nombre para mostrar
echo "Este es un mensaje de prueba" | mailx -s "Asunto" \
    -r "Sistema de Notificaciones <usuario@ejemplo.com>" \
    -a gmail \
    usuario@ejemplo.com

# Especificando formato HTML
echo "<h1>Mensaje en HTML</h1>" | mailx -s "Asunto" \
    -a gmail \
    -a "Content-Type: text/html" \
    usuario@ejemplo.com

# Con archivo adjunto
echo "Mensaje con adjunto" | mailx -s "Asunto" \
    -a gmail \
    -a "archivo.pdf" \
    usuario@ejemplo.com
```
    


---
[⬆️ Volver al inicio del repositorio](https://github.com/InfomedHLG/Proxy_Pasarela_Telegram)

---
[⬆️ Volver al inicio del repositorio](../)