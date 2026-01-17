#!/bin/bash
#===============================================================================
# 01-system.sh - Actualizar sistema e instalar paquetes base
#===============================================================================

log_info "Actualizando sistema..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

log_info "Instalando paquetes base..."
sudo apt-get install -y -qq \
    htop \
    curl \
    wget \
    git \
    jq \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release

log_ok "Sistema actualizado y paquetes base instalados"
