#!/bin/bash
# Instalar Node.js via n

NODE_VERSION="24"

if command -v node &> /dev/null; then
    log_info "Node.js ya instalado: $(node -v)"
else
    log_info "Instalando Node.js $NODE_VERSION via n..."
    
    # Instalar n y Node.js
    curl -fsSL https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash -s -- -y $NODE_VERSION
    
    # Recargar PATH
    export N_PREFIX="$HOME/n"
    export PATH="$N_PREFIX/bin:$PATH"
    
    log_info "Node.js instalado: $(node -v)"
    log_info "npm instalado: $(npm -v)"
fi
