#!/bin/bash

# Script Bash para facilitar el despliegue a Easypanel
# Ejecutar: ./deploy-to-easypanel.sh "mensaje del commit"

SERVER_IP="${SERVER_IP:-172.19.5.212}"
MESSAGE="${1:-Update deployment}"

echo "========================================"
echo "  Basdonax AI RAG - Deploy Script"
echo "========================================"
echo ""

# Verificar si estamos en un repositorio git
if [ ! -d ".git" ]; then
    echo "Error: No estamos en un repositorio Git"
    exit 1
fi

echo "[1/5] Verificando estado del repositorio..."
git status

echo ""
echo "[2/5] Agregando archivos modificados..."
git add .

echo ""
echo "[3/5] Creando commit..."
git commit -m "$MESSAGE"

COMMIT_STATUS=$?
if [ $COMMIT_STATUS -ne 0 ]; then
    echo "Nota: No hay cambios para commitear o el commit falló"
fi

echo ""
echo "[4/5] Enviando a GitHub..."
git push origin master

if [ $? -eq 0 ]; then
    echo ""
    echo "[5/5] Despliegue iniciado!"
    echo ""
    echo "Easypanel detectará los cambios automáticamente."
    echo "Revisa el progreso en: http://$SERVER_IP"
    echo "Tu aplicación estará en: http://$SERVER_IP:8080"
else
    echo ""
    echo "Error: No se pudo hacer push a GitHub"
    echo "Verifica tu conexión y permisos"
    exit 1
fi

echo ""
echo "========================================"
echo "  Despliegue completado!"
echo "========================================"
