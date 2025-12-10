import os, chromadb
from chromadb.config import Settings

# Define the folder for storing database
#PERSIST_DIRECTORY = os.environ.get('PERSIST_DIRECTORY', 'db')

# Define the Chroma settings
# Use 'chroma' as host for Docker Compose, 'host.docker.internal' for Docker Desktop local dev
CHROMA_HOST = os.environ.get('CHROMA_HOST', 'chroma')
CHROMA_PORT = int(os.environ.get('CHROMA_PORT', 8000))

CHROMA_SETTINGS = chromadb.HttpClient(
    host=CHROMA_HOST,
    port=CHROMA_PORT,
    settings=Settings(allow_reset=True, anonymized_telemetry=False)
)
