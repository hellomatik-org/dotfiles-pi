#!/bin/bash
# Clonar repositorios de Hellomatik

WORK_DIR="${WORK_DIR:-/srv/hellomatik}"
GITHUB_ORG="${GITHUB_ORG:-hellomatik-org}"

REPOS=(
    "core"
    "core-app"
    "app"
    "PostgresSocket"
    "ReverseProxy"
    "RedisBridge"
    "mcp-router"
)

# Crear directorio de trabajo
if [ ! -d "$WORK_DIR" ]; then
    log_info "Creando $WORK_DIR..."
    sudo mkdir -p "$WORK_DIR"
    sudo chown -R $USER:$USER "$WORK_DIR"
fi

# Verificar si la clave SSH esta en GitHub
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    log_warn "Clave SSH no configurada en GitHub"
    log_warn "Anade esta clave a GitHub y luego ejecuta:"
    log_warn "  cd $WORK_DIR && ./clone-repos.sh"
    
    # Crear script para clonar despues
    cat > "$WORK_DIR/clone-repos.sh" <<SCRIPT
#!/bin/bash
cd "$WORK_DIR"
for repo in ${REPOS[@]}; do
    if [ ! -d "\$repo" ]; then
        git clone git@github.com:$GITHUB_ORG/\$repo.git
    fi
done
SCRIPT
    chmod +x "$WORK_DIR/clone-repos.sh"
    return 0
fi

# Clonar repos
cd "$WORK_DIR"
for repo in "${REPOS[@]}"; do
    if [ ! -d "$repo" ]; then
        log_info "Clonando $repo..."
        git clone "git@github.com:$GITHUB_ORG/$repo.git"
    else
        log_info "$repo ya existe"
    fi
done
