import os, chromadb
from chromadb.config import Settings

# Define the folder for storing database
#PERSIST_DIRECTORY = os.environ.get('PERSIST_DIRECTORY', 'db')

# Define the Chroma settings
# Use 'chroma' as host for Docker Compose, 'host.docker.internal' for Docker Desktop local dev
CHROMA_HOST = os.environ.get('CHROMA_HOST', 'chroma')
CHROMA_PORT = int(os.environ.get('CHROMA_PORT', 8000))

def get_chroma_client():
    """
    Obtiene el cliente de ChromaDB de forma lazy (solo cuando se necesita)
    Retorna None si ChromaDB no está disponible
    """
    try:
        return chromadb.HttpClient(
            host=CHROMA_HOST,
            port=CHROMA_PORT,
            settings=Settings(allow_reset=True, anonymized_telemetry=False)
        )
    except Exception as e:
        print(f"Advertencia: No se pudo conectar a ChromaDB en {CHROMA_HOST}:{CHROMA_PORT}")
        print(f"Error: {e}")
        return None

# Mantener CHROMA_SETTINGS para compatibilidad pero con lazy loading
CHROMA_SETTINGS = None
