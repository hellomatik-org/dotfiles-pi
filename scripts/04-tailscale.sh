#!/bin/bash
# Instalar y configurar Tailscale

if command -v tailscale &> /dev/null; then
    log_info "Tailscale ya instalado"
else
    log_info "Instalando Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh
fi

# Conectar si hay authkey
if [ -n "$TAILSCALE_AUTHKEY" ] && [ "$TAILSCALE_AUTHKEY" != "tskey-auth-XXXXXXXX" ]; then
    HOSTNAME_ARG=""
    if [ -n "$TAILSCALE_HOSTNAME" ]; then
        HOSTNAME_ARG="--hostname=$TAILSCALE_HOSTNAME"
    fi
    
    log_info "Conectando a Tailscale..."
    sudo tailscale up --ssh --authkey="$TAILSCALE_AUTHKEY" $HOSTNAME_ARG
    
    log_info "Tailscale conectado: $(tailscale ip -4)"
else
    log_warn "TAILSCALE_AUTHKEY no configurado - ejecuta manualmente:"
    log_warn "  sudo tailscale up --ssh --authkey=tu-key --hostname=rpi-XXXX"
fi
