#!/bin/bash
#===============================================================================
# Hellomatik - Script Maestro de Configuracion
#
# Este script ejecuta todos los scripts de configuracion en orden.
# Requiere config.env con las variables de configuracion.
#
# USO:
#   ./setup.sh
#
#===============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones de log
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Banner
echo ""
echo "========================================"
echo "  Hellomatik Raspberry Pi Setup"
echo "========================================"
echo ""

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR

# Cargar configuracion
if [ -f "$SCRIPT_DIR/config.env" ]; then
    source "$SCRIPT_DIR/config.env"
    log_ok "Configuracion cargada desde config.env"
else
    log_error "No se encontro config.env"
    log_info "Copia config.env.example a config.env y edita los valores:"
    log_info "  cp config.env.example config.env"
    log_info "  nano config.env"
    exit 1
fi

# Validar variables requeridas
if [ -z "$GIT_EMAIL" ] || [ -z "$GIT_NAME" ]; then
    log_error "GIT_EMAIL y GIT_NAME son requeridos en config.env"
    exit 1
fi

# Exportar variables para los subscripts
export GIT_EMAIL GIT_NAME
export TAILSCALE_AUTHKEY TAILSCALE_HOSTNAME
export WORK_DIR GITHUB_ORG

log_info "Usuario: $GIT_NAME <$GIT_EMAIL>"
log_info "Directorio de trabajo: ${WORK_DIR:-/srv/hellomatik}"
echo ""

# Exportar funciones de log para subscripts
export -f log_info log_ok log_warn log_error
export RED GREEN YELLOW BLUE NC

# Ejecutar scripts en orden
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

for script in "$SCRIPTS_DIR"/*.sh; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        echo ""
        log_info "=== Ejecutando: $script_name ==="
        
        # Hacer ejecutable y ejecutar
        chmod +x "$script"
        source "$script"
        
        log_ok "$script_name completado"
    fi
done

# Resumen final
echo ""
echo "========================================"
echo "  Configuracion Completada"
echo "========================================"
echo ""
log_info "Resumen:"
echo "  - Docker: $(docker --version 2>/dev/null | cut -d' ' -f3 | tr -d ',' || echo 'no instalado')"
echo "  - Docker Compose: $(docker compose version 2>/dev/null | cut -d' ' -f4 || echo 'requiere relogin')"
echo "  - Node.js: $(node -v 2>/dev/null || echo 'requiere relogin')"
echo "  - Git: $(git --version 2>/dev/null | cut -d' ' -f3)"
echo "  - Tailscale: $(tailscale version 2>/dev/null | head -1 || echo 'no instalado')"
echo ""

# Mostrar SSH key si existe
if [ -f ~/.ssh/id_rsa.pub ]; then
    log_warn "Anade esta clave SSH a GitHub:"
    echo ""
    cat ~/.ssh/id_rsa.pub
    echo ""
fi

log_info "Proximos pasos:"
echo "  1. Cierra sesion y vuelve a entrar (para Docker sin sudo)"
echo "  2. Si no se clonaron repos: cd ${WORK_DIR:-/srv/hellomatik} && ./clone-repos.sh"
echo "  3. Inicia los servicios en orden (ver README.md)"
echo ""
