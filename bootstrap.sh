#!/bin/bash
#===============================================================================
# Hellomatik - Bootstrap Script
#
# Descarga y ejecuta el setup completo en una sola linea:
#   curl -fsSL https://raw.githubusercontent.com/hellomatik-org/dotfiles-pi/main/bootstrap.sh | bash
#
#===============================================================================

set -e

echo ""
echo "========================================"
echo "  Hellomatik Raspberry Pi Bootstrap"
echo "========================================"
echo ""

# Directorio temporal
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo "[INFO] Descargando dotfiles-pi..."
git clone --depth 1 https://github.com/hellomatik-org/dotfiles-pi.git
cd dotfiles-pi

# Verificar si existe config.env
if [ ! -f config.env ]; then
    echo ""
    echo "[WARN] No existe config.env"
    echo "[INFO] Creando desde plantilla..."
    cp config.env.example config.env
    
    # Pedir datos interactivamente
    echo ""
    read -p "Email para Git: " git_email
    read -p "Nombre para Git: " git_name
    read -p "Tailscale AuthKey (dejar vacio para omitir): " ts_key
    read -p "Hostname Tailscale (ej: rpi-1001): " ts_hostname
    
    # Actualizar config.env
    sed -i "s/tu@email.com/$git_email/" config.env
    sed -i "s/Tu Nombre/$git_name/" config.env
    if [ -n "$ts_key" ]; then
        sed -i "s/tskey-auth-XXXXXXXX/$ts_key/" config.env
    fi
    if [ -n "$ts_hostname" ]; then
        sed -i "s/rpi-1001/$ts_hostname/" config.env
    fi
fi

echo ""
echo "[INFO] Ejecutando setup..."
chmod +x setup.sh
./setup.sh

# Limpiar
cd /
rm -rf "$TMP_DIR"

echo ""
echo "[OK] Bootstrap completado!"
