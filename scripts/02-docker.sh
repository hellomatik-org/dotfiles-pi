#!/bin/bash
# Instalar Docker

if command -v docker &> /dev/null; then
    log_info "Docker ya instalado: $(docker --version)"
else
    log_info "Instalando Docker..."
    curl -fsSL https://get.docker.com | sh
    
    # Agregar usuario al grupo docker
    sudo usermod -aG docker $USER
    
    log_info "Docker instalado"
fi

# Instalar plugins de Docker
log_info "Instalando plugins de Docker..."
sudo apt-get update -qq
sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin

log_info "Docker Compose: $(docker compose version 2>/dev/null || echo 'requiere relogin')"
