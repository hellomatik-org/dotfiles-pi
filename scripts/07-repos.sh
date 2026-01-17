#!/bin/bash
#===============================================================================
# 07-repos.sh - Clonar repositorios de Hellomatik
#===============================================================================

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

# Crear script para clonar despues (siempre util)
cat > "$WORK_DIR/clone-repos.sh" <<'SCRIPT'
#!/bin/bash
WORK_DIR="/srv/hellomatik"
GITHUB_ORG="hellomatik-org"
REPOS=("core" "core-app" "app" "PostgresSocket" "ReverseProxy" "RedisBridge" "mcp-router")

cd "$WORK_DIR"
for repo in "${REPOS[@]}"; do
    if [ ! -d "$repo" ]; then
        echo "Clonando $repo..."
        git clone "git@github.com:$GITHUB_ORG/$repo.git"
    else
        echo "$repo ya existe"
    fi
done
echo "Completado!"
SCRIPT
chmod +x "$WORK_DIR/clone-repos.sh"

# Verificar si la clave SSH esta en GitHub
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    log_info "SSH autenticado con GitHub, clonando repos..."
    
    cd "$WORK_DIR"
    for repo in "${REPOS[@]}"; do
        if [ ! -d "$repo" ]; then
            log_info "Clonando $repo..."
            git clone "git@github.com:$GITHUB_ORG/$repo.git" 2>/dev/null || log_warn "No se pudo clonar $repo"
        else
            log_info "$repo ya existe"
        fi
    done
    
    log_ok "Repositorios clonados en $WORK_DIR"
else
    log_warn "Clave SSH no configurada en GitHub"
    log_info "Anade tu clave SSH a GitHub y luego ejecuta:"
    echo "  cd $WORK_DIR && ./clone-repos.sh"
fi
