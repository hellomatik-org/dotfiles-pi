#!/bin/bash
#===============================================================================
# 04-node.sh - Instalar Node.js via n
#===============================================================================

NODE_VERSION="24"

# Verificar si ya esta instalado
if command -v node &> /dev/null; then
    CURRENT_VERSION=$(node -v)
    log_info "Node.js ya instalado: $CURRENT_VERSION"
    
    # Verificar si es la version correcta
    if [[ "$CURRENT_VERSION" == v${NODE_VERSION}* ]]; then
        log_ok "Version correcta instalada"
        return 0
    fi
fi

log_info "Instalando Node.js $NODE_VERSION via n..."

# Instalar n y Node.js
export N_PREFIX="$HOME/n"
curl -fsSL https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash -s -- -y $NODE_VERSION

# Actualizar PATH para esta sesion
export PATH="$N_PREFIX/bin:$PATH"

log_ok "Node.js: $(node -v 2>/dev/null || echo 'requiere relogin')"
log_ok "npm: $(npm -v 2>/dev/null || echo 'requiere relogin')"
