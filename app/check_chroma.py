#!/usr/bin/env python3
"""
Script para verificar qué documentos hay en ChromaDB
"""
import chromadb
from chromadb.config import Settings
import os

# Detectar si estamos dentro de Docker o en local
# Dentro del contenedor, usar 'chroma', fuera usar 'localhost'
chroma_host = os.environ.get('CHROMA_HOST', 'localhost')

print(f"🔌 Conectando a ChromaDB en: {chroma_host}:8000")

# Conectar a ChromaDB
client = chromadb.HttpClient(
    host=chroma_host,
    port=8000,
    settings=Settings(allow_reset=True, anonymized_telemetry=False)
)

try:
    # Obtener la colección
    collection = client.get_collection('vectordb')

    # Contar documentos
    count = collection.count()
    print(f"\n📊 Total de documentos en ChromaDB: {count}")

    if count > 0:
        # Obtener todos los documentos (límite de 10 para ver)
        results = collection.get(limit=10, include=['documents', 'metadatas'])

        print(f"\n📄 Primeros {min(count, 10)} documentos:\n")

        for i, (doc, metadata) in enumerate(zip(results['documents'], results['metadatas']), 1):
            print(f"--- Documento {i} ---")
            print(f"Fuente: {metadata.get('source', 'N/A')}")
            print(f"Contenido (primeros 200 chars): {doc[:200]}...")
            print()

        # Probar una búsqueda
        print("\n🔍 Probando búsqueda con tu pregunta:")
        query = "error específico que aparece al exportar a Excel desde Wigos GUI en Windows 11"

        search_results = collection.query(
            query_texts=[query],
            n_results=5,
            include=['documents', 'metadatas', 'distances']
        )

        print(f"\nResultados de búsqueda para: '{query}'\n")

        if search_results['documents'][0]:
            for i, (doc, metadata, distance) in enumerate(zip(
                search_results['documents'][0],
                search_results['metadatas'][0],
                search_results['distances'][0]
            ), 1):
                print(f"--- Resultado {i} (distancia: {distance:.4f}) ---")
                print(f"Fuente: {metadata.get('source', 'N/A')}")
                print(f"Contenido: {doc[:300]}...")
                print()
        else:
            print("❌ No se encontraron resultados")
    else:
        print("\n⚠️  ChromaDB está vacío. El documento no se indexó correctamente.")
        print("\nPosibles causas:")
        print("1. El documento no se procesó correctamente")
        print("2. Error al cargar el archivo")
        print("3. El nombre de la colección es diferente")

except Exception as e:
    print(f"\n❌ Error al conectar a ChromaDB: {e}")
    print("\nVerifica que ChromaDB esté corriendo:")
    print("  docker ps | grep chroma")
