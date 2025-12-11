# Usa una imagen base de Python
FROM python:3.11

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

CMD streamlit run Inicio.py --server.port 8080