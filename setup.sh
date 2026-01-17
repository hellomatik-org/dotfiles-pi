#!/bin/bash
set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cargar configuracion
if [ -f "$SCRIPT_DIR/config.env" ]; then
    source "$SCRIPT_DIR/config.env"
else
    log_error "No se encontro config.env"
    log_info "Copia config.env.example a config.env y edita los valores"
    exit 1
fi

# Validar variables requeridas
if [ -z "$GIT_EMAIL" ] || [ -z "$GIT_NAME" ]; then
    log_error "GIT_EMAIL y GIT_NAME son requeridos en config.env"
    exit 1
fi

log_info "Iniciando configuracion de Raspberry Pi"
log_info "Usuario: $GIT_NAME <$GIT_EMAIL>"

# Ejecutar scripts en orden
for script in "$SCRIPT_DIR"/scripts/*.sh; do
    if [ -f "$script" ]; then
        log_info "Ejecutando: $(basename "$script")"
        source "$script"
    fi
done

log_info "Configuracion completada!"
log_info ""
log_info "Proximos pasos:"
log_info "1. Reinicia sesion: exit && ssh $(hostname)"
log_info "2. Anade esta clave SSH a GitHub:"
echo ""
cat ~/.ssh/id_rsa.pub 2>/dev/null || log_warn "No se encontro clave SSH"
echo ""
log_info "3. Clona los repos (si no se clonaron):"
log_info "   cd /srv/hellomatik && ./clone-repos.sh"
