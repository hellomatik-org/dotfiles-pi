#!/bin/bash
#===============================================================================
# 03-docker.sh - Instalar Docker y Docker Compose
#===============================================================================

if command -v docker &> /dev/null; then
    log_info "Docker ya instalado: $(docker --version)"
else
    log_info "Instalando Docker..."
    curl -fsSL https://get.docker.com | sh
    log_ok "Docker instalado"
fi

# Agregar usuario al grupo docker
if ! groups $USER | grep -q docker; then
    log_info "Agregando usuario al grupo docker..."
    sudo usermod -aG docker $USER
    log_warn "Requiere cerrar sesion para que surta efecto"
fi

# Instalar plugins de Docker
log_info "Instalando/actualizando plugins de Docker..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    docker-buildx-plugin 2>/dev/null || true

log_ok "Docker: $(docker --version 2>/dev/null | cut -d' ' -f3 | tr -d ',')"
log_ok "Docker Compose: $(docker compose version 2>/dev/null | cut -d' ' -f4 || echo 'requiere relogin')"
