#!/bin/bash

# Script Bash para iniciar el proyecto en desarrollo local
# Ejecutar: ./start-local.sh [build|stop|clean|logs]

set -e

COMMAND="${1:-start}"

echo "========================================"
echo "  Basdonax AI RAG - Local Development"
echo "========================================"
echo ""

# Verificar que Docker está corriendo
if ! docker info >/dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo"
    echo "Por favor inicia Docker Desktop y vuelve a intentar"
    exit 1
fi

echo "✅ Docker está corriendo"
echo ""

case $COMMAND in
    stop)
        echo "🛑 Deteniendo contenedores..."
        docker-compose -f docker-compose.local.yml down
        echo "✅ Contenedores detenidos"
        exit 0
        ;;

    clean)
        echo "🧹 Limpiando contenedores y volúmenes..."
        echo "⚠️  ADVERTENCIA: Esto eliminará los modelos descargados y datos de ChromaDB"
        read -p "¿Estás seguro? (escribe 'SI' para confirmar): " confirmation
        if [ "$confirmation" = "SI" ]; then
            docker-compose -f docker-compose.local.yml down -v
            echo "✅ Todo limpio"
        else
            echo "❌ Operación cancelada"
        fi
        exit 0
        ;;

    logs)
        echo "📋 Mostrando logs (Ctrl+C para salir)..."
        docker-compose -f docker-compose.local.yml logs -f
        exit 0
        ;;

    build)
        echo "🔨 Construyendo e iniciando servicios..."
        docker-compose -f docker-compose.local.yml up --build -d
        ;;

    start|*)
        echo "🚀 Iniciando servicios..."
        docker-compose -f docker-compose.local.yml up -d
        ;;
esac

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Servicios iniciados correctamente"
    echo ""
    echo "📊 Estado de los contenedores:"
    docker-compose -f docker-compose.local.yml ps
    echo ""
    echo "⏳ Esperando a que los servicios estén listos..."
    sleep 10

    echo ""
    echo "========================================"
    echo "  Siguiente paso: Descargar modelo"
    echo "========================================"
    echo ""
    echo "Ejecuta el siguiente comando para descargar el modelo Phi3:"
    echo "  docker exec basdonax-ollama-local ollama pull phi3"
    echo ""
    echo "O ejecuta el script:"
    echo "  ./setup-model-local.sh"
    echo ""
    echo "Luego accede a: http://localhost:8080"
    echo ""
    echo "Comandos útiles:"
    echo "  Ver logs:     ./start-local.sh logs"
    echo "  Detener:      ./start-local.sh stop"
    echo "  Rebuild:      ./start-local.sh build"
    echo "  Limpiar todo: ./start-local.sh clean"
    echo ""
else
    echo ""
    echo "❌ Error al iniciar los servicios"
    echo "Ejecuta 'docker-compose -f docker-compose.local.yml logs' para ver los errores"
    exit 1
fi
