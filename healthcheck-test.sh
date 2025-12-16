#!/bin/bash

# Script para probar los healthchecks de todos los servicios
# Útil para debugging y verificación

set -e

echo "======================================"
echo "  Basdonax AI RAG - Healthcheck Test"
echo "======================================"
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar un healthcheck
check_service() {
    local service_name=$1
    local healthcheck_cmd=$2
    local description=$3

    echo -n "Verificando $service_name... "

    if eval $healthcheck_cmd > /dev/null 2>&1; then
        echo -e "${GREEN}✓ OK${NC} - $description"
        return 0
    else
        echo -e "${RED}✗ FAIL${NC} - $description"
        return 1
    fi
}

# Función para verificar puerto
check_port() {
    local service_name=$1
    local host=$2
    local port=$3

    echo -n "Verificando puerto $port de $service_name... "

    if nc -z -w5 $host $port 2>/dev/null; then
        echo -e "${GREEN}✓ Abierto${NC}"
        return 0
    else
        echo -e "${RED}✗ Cerrado o no accesible${NC}"
        return 1
    fi
}

# Contadores
total_checks=0
passed_checks=0
failed_checks=0

echo "======================================"
echo "1. Verificando ChromaDB"
echo "======================================"
total_checks=$((total_checks + 1))
if check_service "ChromaDB Health" \
    "curl -f -s --max-time 5 http://localhost:8000/api/v1/heartbeat" \
    "API heartbeat endpoint"; then
    passed_checks=$((passed_checks + 1))
else
    failed_checks=$((failed_checks + 1))
fi

total_checks=$((total_checks + 1))
if check_port "ChromaDB" "localhost" "8000"; then
    passed_checks=$((passed_checks + 1))
else
    failed_checks=$((failed_checks + 1))
fi

echo ""
echo "======================================"
echo "2. Verificando Ollama"
echo "======================================"
total_checks=$((total_checks + 1))
if check_service "Ollama Health" \
    "curl -f -s --max-time 5 http://localhost:11434/api/tags" \
    "API tags endpoint"; then
    passed_checks=$((passed_checks + 1))
else
    failed_checks=$((failed_checks + 1))
fi

total_checks=$((total_checks + 1))
if check_port "Ollama" "localhost" "11434"; then
    passed_checks=$((passed_checks + 1))
else
    failed_checks=$((failed_checks + 1))
fi

# Verificar si hay modelos descargados
echo -n "Verificando modelos en Ollama... "
models_output=$(curl -s http://localhost:11434/api/tags 2>/dev/null || echo '{"models":[]}')
model_count=$(echo $models_output | grep -o '"name"' | wc -l)
if [ $model_count -gt 0 ]; then
    echo -e "${GREEN}✓ $model_count modelo(s) disponible(s)${NC}"
    echo "  Modelos: $(echo $models_output | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | tr '\n' ', ' | sed 's/,$//')"
else
    echo -e "${YELLOW}⚠ No hay modelos descargados${NC}"
    echo "  Descarga un modelo con: docker-compose exec ollama ollama pull phi3"
fi

echo ""
echo "======================================"
echo "3. Verificando UI (Streamlit)"
echo "======================================"
total_checks=$((total_checks + 1))
if check_service "Streamlit Health" \
    "curl -f -s --max-time 5 http://localhost:8080/_stcore/health" \
    "Streamlit health endpoint"; then
    passed_checks=$((passed_checks + 1))
else
    failed_checks=$((failed_checks + 1))
fi

total_checks=$((total_checks + 1))
if check_port "UI (Streamlit)" "localhost" "8080"; then
    passed_checks=$((passed_checks + 1))
else
    failed_checks=$((failed_checks + 1))
fi

# Verificar proceso de Streamlit
if docker-compose ps | grep -q "basdonax-ui"; then
    total_checks=$((total_checks + 1))
    echo -n "Verificando proceso Streamlit en contenedor... "
    if docker-compose exec -T ui pgrep -f "streamlit run" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Proceso corriendo${NC}"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}✗ Proceso no encontrado${NC}"
        failed_checks=$((failed_checks + 1))
    fi
fi

echo ""
echo "======================================"
echo "4. Verificando Conectividad entre Servicios"
echo "======================================"

# Verificar desde UI a Ollama
if docker-compose ps | grep -q "basdonax-ui"; then
    total_checks=$((total_checks + 1))
    echo -n "Verificando UI -> Ollama... "
    if docker-compose exec -T ui curl -f -s --max-time 5 http://ollama:11434/api/tags > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Conectado${NC}"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}✗ No conectado${NC}"
        failed_checks=$((failed_checks + 1))
    fi

    # Verificar desde UI a ChromaDB
    total_checks=$((total_checks + 1))
    echo -n "Verificando UI -> ChromaDB... "
    if docker-compose exec -T ui curl -f -s --max-time 5 http://chroma:8000/api/v1/heartbeat > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Conectado${NC}"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}✗ No conectado${NC}"
        failed_checks=$((failed_checks + 1))
    fi
fi

echo ""
echo "======================================"
echo "5. Verificando Volúmenes"
echo "======================================"

# Verificar volumen de ChromaDB
total_checks=$((total_checks + 1))
echo -n "Verificando volumen ChromaDB... "
if docker volume ls | grep -q "chroma_data"; then
    volume_size=$(docker volume inspect chroma_data | grep -o '"Mountpoint": "[^"]*"' | cut -d'"' -f4)
    if [ -n "$volume_size" ]; then
        echo -e "${GREEN}✓ Existe${NC} ($volume_size)"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${YELLOW}⚠ Existe pero no se puede inspeccionar${NC}"
        passed_checks=$((passed_checks + 1))
    fi
else
    echo -e "${RED}✗ No existe${NC}"
    failed_checks=$((failed_checks + 1))
fi

# Verificar volumen de Ollama
total_checks=$((total_checks + 1))
echo -n "Verificando volumen Ollama... "
if docker volume ls | grep -q "ollama_models"; then
    volume_size=$(docker volume inspect ollama_models | grep -o '"Mountpoint": "[^"]*"' | cut -d'"' -f4)
    if [ -n "$volume_size" ]; then
        echo -e "${GREEN}✓ Existe${NC} ($volume_size)"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${YELLOW}⚠ Existe pero no se puede inspeccionar${NC}"
        passed_checks=$((passed_checks + 1))
    fi
else
    echo -e "${RED}✗ No existe${NC}"
    failed_checks=$((failed_checks + 1))
fi

echo ""
echo "======================================"
echo "Resumen"
echo "======================================"
echo "Total de verificaciones: $total_checks"
echo -e "${GREEN}Exitosas: $passed_checks${NC}"
echo -e "${RED}Fallidas: $failed_checks${NC}"

success_rate=$((passed_checks * 100 / total_checks))
echo "Tasa de éxito: $success_rate%"

echo ""
if [ $failed_checks -eq 0 ]; then
    echo -e "${GREEN}✓ Todos los servicios están funcionando correctamente!${NC}"
    exit 0
else
    echo -e "${RED}✗ Algunos servicios tienen problemas. Revisa los logs:${NC}"
    echo "  docker-compose logs -f ui"
    echo "  docker-compose logs -f ollama"
    echo "  docker-compose logs -f chroma"
    exit 1
fi
