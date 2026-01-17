#!/bin/bash
#===============================================================================
# 08-dotfiles.sh - Configurar bashrc, neofetch y aliases
#===============================================================================

# Instalar neofetch desde source (version mas reciente)
if ! command -v neofetch &> /dev/null; then
    log_info "Instalando neofetch..."
    sudo wget -qO /usr/local/bin/neofetch https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
    sudo chmod +x /usr/local/bin/neofetch
    log_ok "neofetch instalado"
else
    log_info "neofetch ya instalado"
fi

# Copiar configuracion de neofetch
if [ -f "$SCRIPT_DIR/config/neofetch.conf" ]; then
    log_info "Configurando neofetch..."
    mkdir -p ~/.config/neofetch
    cp "$SCRIPT_DIR/config/neofetch.conf" ~/.config/neofetch/config.conf
    log_ok "Configuracion de neofetch copiada"
fi

# Anadir lineas a bashrc
if [ -f "$SCRIPT_DIR/config/bashrc.append" ]; then
    if ! grep -q "# dotfiles-pi" ~/.bashrc 2>/dev/null; then
        log_info "Actualizando .bashrc..."
        cat "$SCRIPT_DIR/config/bashrc.append" >> ~/.bashrc
        log_ok ".bashrc actualizado"
    else
        log_info ".bashrc ya configurado"
    fi
fi
