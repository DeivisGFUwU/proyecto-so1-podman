# Proyecto Sistemas Operativos I – Uptime Kuma (Podman Rootless)

Despliegue automatizado de Uptime Kuma en modo **Podman rootless** mediante un Pod definido en YAML, volumen persistente, límite de memoria y reinicio automático con `systemd` (Quadlet).

## Requisitos previos en Linux
- Podman 4.4 o superior (`sudo dnf install -y podman` en AlmaLinux 9 / Fedora, o `sudo apt install -y podman` en Ubuntu 24.04).
- Puerto TCP `3001` abierto en el firewall o Security Group.

## Despliegue en un solo paso
```bash
git clone [https://github.com/TU_USUARIO/proyecto-so1-podman.git](https://github.com/TU_USUARIO/proyecto-so1-podman.git)
cd proyecto-so1-podman
./deploy.sh