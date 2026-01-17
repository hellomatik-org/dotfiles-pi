#!/bin/bash
# Configurar Git y SSH

log_info "Configurando Git..."

git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"

# Configuraciones adicionales utiles
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor nano

# Generar clave SSH si no existe
if [ ! -f ~/.ssh/id_rsa ]; then
    log_info "Generando clave SSH..."
    ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f ~/.ssh/id_rsa -N ""
    
    # Iniciar ssh-agent y agregar clave
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    
    log_info "Clave SSH generada"
else
    log_info "Clave SSH ya existe"
fi
