# Dockerfile para despliegue en Easypanel
# Este archivo está en la raíz del proyecto
FROM python:3.11

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

# Exponer el puerto
EXPOSE 8080

# Comando para iniciar la aplicación
CMD ["streamlit", "run", "Inicio.py", "--server.port", "8080", "--server.address", "0.0.0.0"]
