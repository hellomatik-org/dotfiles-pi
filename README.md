# dotfiles-pi

Configuracion automatizada para Raspberry Pi con el stack Hellomatik.

## Uso rapido

Desde una Raspberry Pi recien instalada con Raspberry Pi OS:

```bash
curl -fsSL https://raw.githubusercontent.com/hellomatik-org/dotfiles-pi/main/setup.sh | bash
```

O si prefieres revisar antes de ejecutar:

```bash
git clone git@github.com:hellomatik-org/dotfiles-pi.git
cd dotfiles-pi
./setup.sh
```

## Que instala

- Docker y Docker Compose
- Node.js 24 (via n)
- Tailscale
- Git configurado
- Herramientas: htop, neofetch
- Locales en_GB.UTF-8
- Clona todos los repos de Hellomatik en /srv/hellomatik

## Configuracion requerida

Antes de ejecutar, edita `config.env`:

```bash
GIT_EMAIL="tu@email.com"
GIT_NAME="Tu Nombre"
TAILSCALE_AUTHKEY="tskey-auth-xxx"  # Obtener de https://login.tailscale.com/admin/settings/keys
TAILSCALE_HOSTNAME="rpi-XXXX"
```

## Estructura

```
dotfiles-pi/
  setup.sh           # Script principal de instalacion
  config.env         # Variables de configuracion (editar)
  scripts/
    01-locale.sh     # Configura locales
    02-docker.sh     # Instala Docker
    03-node.sh       # Instala Node.js
    04-tailscale.sh  # Instala y conecta Tailscale
    05-git.sh        # Configura Git y SSH
    06-repos.sh      # Clona repositorios
    07-tools.sh      # Herramientas adicionales
  config/
    neofetch.conf    # Configuracion de neofetch
    bashrc.append    # Lineas a anadir a .bashrc
```

## Post-instalacion

Despues de ejecutar el script:

1. Reinicia la sesion o ejecuta `source ~/.bashrc`
2. Anade tu clave SSH publica a GitHub (se muestra al final del script)
3. Levanta los servicios con docker compose

## Orden de inicio de servicios

```bash
cd /srv/hellomatik/PostgresSocket && make up-dev
cd /srv/hellomatik/RedisBridge && make docker-up
cd /srv/hellomatik/ReverseProxy && docker compose -f docker-compose.dev.yml up -d
cd /srv/hellomatik/core && make dev-up
cd /srv/hellomatik/core-app && make dev-up
cd /srv/hellomatik/app && make up
```
