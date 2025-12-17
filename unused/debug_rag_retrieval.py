import os
from langchain_community.embeddings import HuggingFaceEmbeddings
from common.chroma_db_settings import Chroma
from common.constants import get_chroma_client

# Configuración
embeddings_model_name = "all-MiniLM-L6-v2"
query = "¿Qué comandos DISM se recomiendan para verificar la salud del sistema?"

print(f"🔍 DEBUG RAG - Query: {query}\n")

# Conectar a ChromaDB
chroma_client = get_chroma_client()
if not chroma_client:
    print("❌ No se pudo conectar a ChromaDB")
    exit(1)

print("✅ Conectado a ChromaDB\n")

# Crear embeddings y DB
embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_name)
db = Chroma(client=chroma_client, embedding_function=embeddings)

# Buscar con MMR
retriever = db.as_retriever(
    search_type="mmr",
    search_kwargs={
        "k": 4,
        "fetch_k": 16,
        "lambda_mult": 0.5
    }
)

# Recuperar documentos
docs = retriever.get_relevant_documents(query)

print(f"📄 Se recuperaron {len(docs)} chunks:\n")
print("=" * 80)

for i, doc in enumerate(docs, 1):
    print(f"\n--- CHUNK {i} ---")
    print(f"Fuente: {doc.metadata.get('source', 'N/A')}")
    print(f"Contenido (primeros 300 chars):")
    print(doc.page_content[:300])
    print("...")
    print("-" * 80)

print("\n✅ Debug completado")
