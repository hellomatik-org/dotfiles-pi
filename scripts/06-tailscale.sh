#!/bin/bash
#===============================================================================
# 06-tailscale.sh - Instalar y configurar Tailscale
#===============================================================================

# Instalar si no existe
if ! command -v tailscale &> /dev/null; then
    log_info "Instalando Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh
    log_ok "Tailscale instalado"
else
    log_info "Tailscale ya instalado"
fi

# Conectar si hay authkey valido
if [ -n "$TAILSCALE_AUTHKEY" ] && [ "$TAILSCALE_AUTHKEY" != "tskey-auth-XXXXXXXX" ]; then
    log_info "Conectando a Tailscale..."
    
    HOSTNAME_ARG=""
    if [ -n "$TAILSCALE_HOSTNAME" ]; then
        HOSTNAME_ARG="--hostname=$TAILSCALE_HOSTNAME"
    fi
    
    sudo tailscale up --ssh --authkey="$TAILSCALE_AUTHKEY" $HOSTNAME_ARG
    
    log_ok "Tailscale conectado: $(tailscale ip -4 2>/dev/null)"
else
    log_warn "TAILSCALE_AUTHKEY no configurado"
    log_info "Para conectar manualmente:"
    echo "  sudo tailscale up --ssh --authkey=tu-key --hostname=rpi-XXXX"
fi
