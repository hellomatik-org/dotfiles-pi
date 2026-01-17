#!/bin/bash
# Instalar herramientas adicionales

log_info "Instalando herramientas..."

sudo apt-get update -qq
sudo apt-get install -y -qq htop curl wget

# Instalar neofetch desde source (version mas reciente)
if ! command -v neofetch &> /dev/null; then
    log_info "Instalando neofetch..."
    sudo wget -qO /usr/local/bin/neofetch https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
    sudo chmod +x /usr/local/bin/neofetch
fi

# Copiar configuracion de neofetch
if [ -f "$SCRIPT_DIR/config/neofetch.conf" ]; then
    mkdir -p ~/.config/neofetch
    cp "$SCRIPT_DIR/config/neofetch.conf" ~/.config/neofetch/config.conf
fi

# Anadir lineas a bashrc
if [ -f "$SCRIPT_DIR/config/bashrc.append" ]; then
    if ! grep -q "# dotfiles-pi" ~/.bashrc; then
        log_info "Actualizando .bashrc..."
        cat "$SCRIPT_DIR/config/bashrc.append" >> ~/.bashrc
    fi
fi

log_info "Herramientas instaladas"
