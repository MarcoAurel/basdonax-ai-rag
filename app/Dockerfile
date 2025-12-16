# Usa una imagen base de Python
FROM python:3.11-slim

# Instalar curl y herramientas para healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo
WORKDIR /app

# Copia todo el contenido del directorio actual al directorio de trabajo
COPY . .

RUN pip install --upgrade pip

# Instala las dependencias
RUN pip install --no-cache-dir -r requirements.txt

RUN python -m pip install --upgrade pip setuptools wheel

# Descargar datos de NLTK necesarios para procesamiento de documentos
RUN python -c "import nltk; \
    nltk.download('punkt'); \
    nltk.download('punkt_tab'); \
    nltk.download('averaged_perceptron_tagger'); \
    nltk.download('averaged_perceptron_tagger_eng')"

# Crear script de healthcheck robusto
RUN echo '#!/bin/bash\n\
set -e\n\
curl -f -s --max-time 5 http://localhost:8080/_stcore/health > /dev/null || exit 1\n\
if ! pgrep -f "streamlit run" > /dev/null; then\n\
    echo "ERROR: Proceso Streamlit no encontrado"\n\
    exit 1\n\
fi\n\
exit 0\n\
' > /healthcheck.sh && chmod +x /healthcheck.sh

# Exponer el puerto
EXPOSE 8080

# Healthcheck robusto
HEALTHCHECK --interval=15s --timeout=10s --start-period=120s --retries=5 \
    CMD /healthcheck.sh

CMD streamlit run Inicio.py --server.port 8080 --server.address 0.0.0.0 --server.headless true