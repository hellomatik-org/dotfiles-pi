# dotfiles-pi

Configuracion automatizada para Raspberry Pi con el stack Hellomatik.

## Uso rapido

Desde una Raspberry Pi recien instalada con Raspberry Pi OS:

```bash
# Opcion 1: Clonar y ejecutar
git clone https://github.com/hellomatik-org/dotfiles-pi.git
cd dotfiles-pi
cp config.env.example config.env
nano config.env  # Editar con tus datos
./setup.sh
```

```bash
# Opcion 2: Una linea (requiere config.env ya configurado)
curl -fsSL https://raw.githubusercontent.com/hellomatik-org/dotfiles-pi/main/bootstrap.sh | bash
```

## Que instala

- Sistema actualizado (apt update/upgrade)
- Locales en_GB.UTF-8
- Docker 29.x + Docker Compose v5.x
- Node.js 24.x (via n)
- Tailscale (VPN mesh)
- Git configurado con SSH keys
- Herramientas: htop, neofetch, curl, wget, jq
- Clona todos los repos de Hellomatik en /srv/hellomatik

## Configuracion requerida

Antes de ejecutar, crea `config.env` basado en el ejemplo:

```bash
# Git
GIT_EMAIL="tu@email.com"
GIT_NAME="Tu Nombre"

# Tailscale - Obtener de https://login.tailscale.com/admin/settings/keys
TAILSCALE_AUTHKEY="tskey-auth-xxx"
TAILSCALE_HOSTNAME="rpi-1001"

# Directorio de trabajo
WORK_DIR="/srv/hellomatik"
GITHUB_ORG="hellomatik-org"
```

## Estructura

```
dotfiles-pi/
  bootstrap.sh        # Script de una linea para descargar y ejecutar
  setup.sh            # Script maestro principal
  config.env.example  # Plantilla de configuracion
  scripts/
    01-system.sh      # Actualiza sistema e instala paquetes base
    02-locale.sh      # Configura locales
    03-docker.sh      # Instala Docker y Docker Compose
    04-node.sh        # Instala Node.js via n
    05-git.sh         # Configura Git y genera SSH keys
    06-tailscale.sh   # Instala y conecta Tailscale
    07-repos.sh       # Clona repositorios de Hellomatik
    08-dotfiles.sh    # Configura bashrc, neofetch, aliases
  config/
    neofetch.conf     # Configuracion completa de neofetch
    bashrc.append     # Lineas a anadir a .bashrc
```

## Post-instalacion

Despues de ejecutar el script:

1. Cierra sesion y vuelve a entrar (para que Docker funcione sin sudo)
2. Si no se clonaron los repos, anade tu SSH key a GitHub y ejecuta:
   ```bash
   cd /srv/hellomatik && ./clone-repos.sh
   ```

## Orden de inicio de servicios

```bash
cd /srv/hellomatik

# 1. Base de datos
cd PostgresSocket && make up-dev && cd ..

# 2. WebSocket bridge  
cd RedisBridge && make docker-up && cd ..

# 3. Reverse proxy
cd ReverseProxy && docker compose -f docker-compose.dev.yml up -d && cd ..

# 4. Backend AI
cd core && make dev-up && cd ..

# 5. Backend Panel
cd core-app && make dev-up && cd ..

# 6. Frontend
cd app && make up && cd ..

# 7. MCP Router (opcional)
cd mcp-router && docker compose -f docker-compose.dev.yml up -d && cd ..
```

## Versiones instaladas

| Software | Version |
|----------|---------|  
| Docker | 29.1.5 |
| Docker Compose | v5.0.1 |
| Node.js | v24.13.0 |
| npm | 11.6.2 |

## Verificar instalacion

```bash
# Ver info del sistema
neofetch

# Ver servicios Docker
docker ps -a

# Ver temperatura (Raspberry Pi)
vcgencmd measure_temp

# Ver IP de Tailscale
tailscale ip -4
```
