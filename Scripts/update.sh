#!/usr/bin/env bash

# ================================
#  Script: update-system.sh
#  Descripción:
#    - Actualiza repos oficiales
#    - Actualiza paquetes AUR (si existe yay)
#    - Limpia dependencias huérfanas
#    - Limpia la caché de pacman
# ================================

set -e 

echo " Actualizando..."
sudo pacman -Syu --noconfirm


echo
echo " Limpiando paquetes huérfanos..."
orphans=$(pacman -Qdtq || true)

if [[ -n "$orphans" ]]; then
    sudo pacman -Rns --noconfirm $orphans
else
    echo " No hay paquetes huérfanos."
fi


echo " Limpiando caché de paquetes ..."
sudo paccache -r


if command -v yay >/dev/null 2>&1; then
    echo "Se detecteto yay, actualizando paquetes AUR.."
    yay -Syu --noconfirm
else
    "No se encorntro yay."
fi

echo
echo " ✅ Sistema actualizado y limpio."
