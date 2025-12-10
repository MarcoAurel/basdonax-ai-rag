#!/bin/bash

# Script de inicialización para descargar el modelo Phi3 en Ollama
# Ejecutar este script después del primer despliegue

set -e

echo "🚀 Iniciando descarga del modelo Phi3..."

# Esperar a que Ollama esté listo
echo "⏳ Esperando a que Ollama esté disponible..."
sleep 10

# Obtener el ID del contenedor de Ollama
CONTAINER_ID=$(docker ps -q -f name=basdonax-ollama)

if [ -z "$CONTAINER_ID" ]; then
    echo "❌ Error: No se encontró el contenedor de Ollama"
    echo "Asegúrate de que el proyecto esté corriendo con: docker-compose -f docker-compose.prod.yml up -d"
    exit 1
fi

echo "📦 Contenedor de Ollama encontrado: $CONTAINER_ID"

# Descargar el modelo Phi3
echo "⬇️  Descargando modelo Phi3 (esto puede tardar varios minutos)..."
docker exec $CONTAINER_ID ollama pull phi3

echo "✅ Modelo Phi3 descargado exitosamente"

# Verificar que el modelo está disponible
echo "📋 Modelos disponibles:"
docker exec $CONTAINER_ID ollama list

echo ""
echo "🎉 ¡Inicialización completada!"
echo "Puedes acceder a la aplicación en: http://172.19.5.212:8080"
