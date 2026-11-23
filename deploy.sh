#!/bin/bash
set -e

# 1. Verificar que Podman esté instalado
if ! command -v podman &> /dev/null; then
  echo "Error: Podman no está instalado. Instálalo primero (ej. sudo dnf install -y podman)."
  exit 1
fi

# 2. Obtener la ruta absoluta donde se clonó el repositorio
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 3. Activar linger para que el servicio rootless sobreviva al cierre de sesión SSH
echo "[1/4] Activando linger para el usuario $USER..."
loginctl enable-linger "$USER" 2>/dev/null || sudo loginctl enable-linger "$USER"

# 4. Crear la unidad Quadlet de systemd apuntando al archivo YAML del Pod
echo "[2/4] Configurando reinicio automático con systemd (Quadlet)..."
mkdir -p ~/.config/containers/systemd

cat << EOF > ~/.config/containers/systemd/kuma.kube
[Unit]
Description=Pod Uptime Kuma - Proyecto SO1 (Podman Rootless)
After=network-online.target

[Kube]
Yaml=${REPO_DIR}/kuma-pod.yaml

[Service]
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF

# 5. Recargar systemd de usuario y levantar el servicio
echo "[3/4] Iniciando servicio kuma.service..."
systemctl --user daemon-reload
systemctl --user restart kuma.service

# 6. Verificación rápida del despliegue
echo "[4/4] Verificando estado del Pod y contenedor..."
sleep 3
podman pod ps
podman ps
echo ""
echo "Despliegue completado. Accede en: http://localhost:3001 (o http://<IP_DEL_SERVIDOR>:3001)"