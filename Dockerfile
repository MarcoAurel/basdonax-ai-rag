# Dockerfile para despliegue en Easypanel
# Este archivo está en la raíz del proyecto
FROM python:3.11-slim

# Instalar curl, wget y netcat para healthcheck y diagnóstico
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    netcat-traditional \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar archivos de requirements desde la carpeta app
COPY app/requirements.txt .

# Actualizar pip
RUN pip install --upgrade pip

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Actualizar setuptools y wheel
RUN python -m pip install --upgrade pip setuptools wheel

# Descargar datos de NLTK necesarios para procesamiento de documentos
RUN python -c "import nltk; \
    nltk.download('punkt'); \
    nltk.download('punkt_tab'); \
    nltk.download('averaged_perceptron_tagger'); \
    nltk.download('averaged_perceptron_tagger_eng')"

# Copiar el código de la aplicación
COPY app/ /app/

# Crear script de healthcheck robusto
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Verificar que Streamlit está respondiendo\n\
echo "Verificando Streamlit..."\n\
curl -f -s --max-time 5 http://localhost:8080/_stcore/health > /dev/null || exit 1\n\
\n\
# Verificar que el proceso de Streamlit está corriendo\n\
if ! pgrep -f "streamlit run" > /dev/null; then\n\
    echo "ERROR: Proceso Streamlit no encontrado"\n\
    exit 1\n\
fi\n\
\n\
echo "Healthcheck OK"\n\
exit 0\n\
' > /healthcheck.sh && chmod +x /healthcheck.sh

# Exponer el puerto
EXPOSE 8080

# Healthcheck robusto con período de inicio más largo
HEALTHCHECK --interval=15s --timeout=10s --start-period=120s --retries=5 \
    CMD /healthcheck.sh

# Comando para iniciar la aplicación
CMD ["streamlit", "run", "Inicio.py", "--server.port", "8080", "--server.address", "0.0.0.0", "--server.headless", "true"]
