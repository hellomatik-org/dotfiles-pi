#!/bin/bash
# Configurar locales

log_info "Configurando locales..."

sudo locale-gen en_GB.UTF-8
sudo update-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8

# Crear archivo de locale
sudo tee /etc/default/locale > /dev/null <<EOF
LANG=en_GB.UTF-8
LC_ALL=en_GB.UTF-8
EOF

log_info "Locales configurados"
