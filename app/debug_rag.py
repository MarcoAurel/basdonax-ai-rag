#!/usr/bin/env python3
"""
Script para debuggear el flujo RAG completo
"""
import sys
sys.path.append('/app')

from common.langchain_module import response
import os

# Configurar variables de entorno si no están
os.environ.setdefault('CHROMA_HOST', 'chroma')
os.environ.setdefault('CHROMA_PORT', '8000')
os.environ.setdefault('TARGET_SOURCE_CHUNKS', '5')
os.environ.setdefault('EMBEDDINGS_MODEL_NAME', 'all-MiniLM-L6-v2')

# La pregunta de prueba
question = "¿Cuál es el error específico que aparece al exportar a Excel desde Wigos GUI en Windows 11?"

print("="*80)
print("🔍 DEBUG RAG - Flujo Completo")
print("="*80)
print(f"\n📝 Pregunta: {question}\n")

# Obtener embeddings
print("📊 Paso 1: Inicializando embeddings...")
from langchain_community.embeddings import HuggingFaceEmbeddings
embeddings_model_name = os.environ.get("EMBEDDINGS_MODEL_NAME", "all-MiniLM-L6-v2")
embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_name)
print(f"✅ Embeddings listos: {embeddings_model_name}\n")

# Conectar a ChromaDB
print("🗄️  Paso 2: Conectando a ChromaDB...")
from common.constants import CHROMA_SETTINGS
from common.chroma_db_settings import Chroma

db = Chroma(client=CHROMA_SETTINGS, embedding_function=embeddings)
print(f"✅ Conectado a ChromaDB\n")

# Configurar retriever
print("🔎 Paso 3: Configurando retriever...")
target_source_chunks = int(os.environ.get('TARGET_SOURCE_CHUNKS', 5))
retriever = db.as_retriever(search_kwargs={"k": target_source_chunks})
print(f"✅ Retriever configurado para recuperar {target_source_chunks} chunks\n")

# Probar retrieval
print("📚 Paso 4: Recuperando documentos relevantes...")
docs = retriever.get_relevant_documents(question)
print(f"✅ Recuperados {len(docs)} documentos\n")

if len(docs) > 0:
    print("📄 Contenido de los documentos recuperados:\n")
    for i, doc in enumerate(docs, 1):
        print(f"--- Documento {i} ---")
        print(f"Fuente: {doc.metadata.get('source', 'N/A')}")
        print(f"Contenido:\n{doc.page_content[:300]}...")
        print()
else:
    print("❌ No se recuperaron documentos!\n")

# Formatear contexto
print("📝 Paso 5: Formateando contexto...")
def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)

context = format_docs(docs)
print(f"✅ Contexto formateado ({len(context)} caracteres)\n")
print("Primeros 500 caracteres del contexto:")
print("-" * 80)
print(context[:500])
print("-" * 80)
print()

# Crear el prompt
print("💬 Paso 6: Creando prompt...")
from common.assistant_prompt import assistant_prompt

prompt_template = assistant_prompt()
prompt_text = prompt_template.invoke({"question": question, "context": context})
print(f"✅ Prompt creado\n")

print("Estructura del prompt:")
print("-" * 80)
print(str(prompt_text)[:800])
print("...")
print("-" * 80)
print()

# Probar con el LLM
print("🤖 Paso 7: Enviando al LLM...")
print("⚠️  Esto puede tardar varios segundos...\n")

try:
    # Usar la función response completa
    result = response(question)
    print("✅ Respuesta recibida del LLM:\n")
    print("="*80)
    print(result)
    print("="*80)
except Exception as e:
    print(f"❌ Error al obtener respuesta: {e}")
    import traceback
    traceback.print_exc()

print("\n🏁 Debug completado")
