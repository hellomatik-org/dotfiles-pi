#!/bin/bash
#===============================================================================
# 05-git.sh - Configurar Git y generar SSH keys
#===============================================================================

log_info "Configurando Git..."

# Configuracion basica
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"

# Configuraciones adicionales
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor nano
git config --global push.autoSetupRemote true

log_ok "Git configurado para: $GIT_NAME <$GIT_EMAIL>"

# Generar clave SSH si no existe
if [ ! -f ~/.ssh/id_rsa ]; then
    log_info "Generando clave SSH..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f ~/.ssh/id_rsa -N ""
    
    # Configurar ssh-agent
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_rsa 2>/dev/null
    
    log_ok "Clave SSH generada"
else
    log_info "Clave SSH ya existe"
fi
