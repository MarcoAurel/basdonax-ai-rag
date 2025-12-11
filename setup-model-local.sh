#!/bin/bash

# Script Bash para descargar el modelo Phi3 en desarrollo local
# Ejecutar: ./setup-model-local.sh [modelo]

set -e

MODEL="${1:-phi3}"

echo "========================================"
echo "  Configuración de Modelo LLM"
echo "========================================"
echo ""

# Verificar que el contenedor de Ollama está corriendo
CONTAINER=$(docker ps --filter "name=basdonax-ollama-local" --format "{{.Names}}" 2>/dev/null || true)

if [ -z "$CONTAINER" ]; then
    echo "❌ Error: El contenedor de Ollama no está corriendo"
    echo ""
    echo "Por favor ejecuta primero:"
    echo "  ./start-local.sh"
    exit 1
fi

echo "✅ Contenedor de Ollama encontrado: $CONTAINER"
echo ""

# Verificar si el modelo ya está descargado
echo "🔍 Verificando modelos instalados..."
INSTALLED_MODELS=$(docker exec basdonax-ollama-local ollama list 2>&1)

if echo "$INSTALLED_MODELS" | grep -q "$MODEL"; then
    echo "✅ El modelo '$MODEL' ya está instalado"
    echo ""
    echo "Modelos disponibles:"
    docker exec basdonax-ollama-local ollama list
    echo ""

    read -p "¿Deseas reinstalarlo de todas formas? (S/N): " reinstall
    if [ "$reinstall" != "S" ]; then
        echo "✅ Usando modelo existente"
        exit 0
    fi
fi

echo ""
echo "⬇️  Descargando modelo '$MODEL'..."
echo "⏱️  Esto puede tardar 5-10 minutos (~2.5GB)"
echo ""

# Descargar el modelo
docker exec basdonax-ollama-local ollama pull "$MODEL"

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "  ✅ Modelo instalado correctamente!"
    echo "========================================"
    echo ""
    echo "📋 Modelos disponibles:"
    docker exec basdonax-ollama-local ollama list
    echo ""
    echo "🎉 Todo listo! Accede a tu aplicación en:"
    echo "   http://localhost:8080"
    echo ""
    echo "💡 Consejos:"
    echo "   - Sube un documento PDF o TXT"
    echo "   - Haz preguntas sobre su contenido"
    echo "   - Los documentos se guardan en ChromaDB"
    echo ""
else
    echo ""
    echo "❌ Error al descargar el modelo"
    echo "Verifica tu conexión a internet e intenta de nuevo"
    exit 1
fi
