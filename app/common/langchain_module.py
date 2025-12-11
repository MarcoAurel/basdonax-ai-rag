from langchain.chains import RetrievalQA
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from langchain_community.llms import Ollama
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from common.chroma_db_settings import Chroma
from common.assistant_prompt import assistant_prompt
import os
import argparse

# Configuración del modelo
use_cloud_api = os.environ.get("USE_CLOUD_API", "false").lower() == "true"
cloud_provider = os.environ.get("CLOUD_PROVIDER", "groq")
model = os.environ.get("MODEL") if not use_cloud_api else os.environ.get("MODEL_NAME", "llama-3.1-70b-versatile")

# For embeddings model, the example uses a sentence-transformers model
# https://www.sbert.net/docs/pretrained_models.html
# "The all-mpnet-base-v2 model provides the best quality, while all-MiniLM-L6-v2 is 5 times faster and still offers good quality."
embeddings_model_name = os.environ.get("EMBEDDINGS_MODEL_NAME", "all-MiniLM-L6-v2")
target_source_chunks = int(os.environ.get('TARGET_SOURCE_CHUNKS',5))

from common.constants import CHROMA_SETTINGS


def parse_arguments():
    parser = argparse.ArgumentParser(description='privateGPT: Ask questions to your documents without an internet connection, '
                                                 'using the power of LLMs.')
    parser.add_argument("--hide-source", "-S", action='store_true',
                        help='Use this flag to disable printing of source documents used for answers.')

    parser.add_argument("--mute-stream", "-M",
                        action='store_true',
                        help='Use this flag to disable the streaming StdOut callback for LLMs.')

    return parser.parse_args()


def get_llm(callbacks):
    """Obtiene el LLM según la configuración (local u API en la nube)"""

    if use_cloud_api:
        # Usar API en la nube
        if cloud_provider == "groq":
            from langchain_groq import ChatGroq
            api_key = os.environ.get("GROQ_API_KEY")
            if not api_key:
                raise ValueError("GROQ_API_KEY no está configurada. Por favor agrega tu API key en el archivo .env")
            return ChatGroq(
                model=model,
                groq_api_key=api_key,
                temperature=0,
                callbacks=callbacks
            )

        elif cloud_provider == "openai":
            from langchain_openai import ChatOpenAI
            api_key = os.environ.get("OPENAI_API_KEY")
            if not api_key:
                raise ValueError("OPENAI_API_KEY no está configurada. Por favor agrega tu API key en el archivo .env")
            return ChatOpenAI(
                model=model,
                openai_api_key=api_key,
                temperature=0,
                callbacks=callbacks
            )

        elif cloud_provider == "anthropic":
            from langchain_anthropic import ChatAnthropic
            api_key = os.environ.get("ANTHROPIC_API_KEY")
            if not api_key:
                raise ValueError("ANTHROPIC_API_KEY no está configurada. Por favor agrega tu API key en el archivo .env")
            return ChatAnthropic(
                model=model,
                anthropic_api_key=api_key,
                temperature=0,
                callbacks=callbacks
            )

        elif cloud_provider == "google":
            from langchain_google_genai import ChatGoogleGenerativeAI
            api_key = os.environ.get("GOOGLE_API_KEY")
            if not api_key:
                raise ValueError("GOOGLE_API_KEY no está configurada. Por favor agrega tu API key en el archivo .env")
            return ChatGoogleGenerativeAI(
                model=model,
                google_api_key=api_key,
                temperature=0,
                callbacks=callbacks,
                transport="rest"  # Usar REST en lugar de gRPC para evitar problemas con event loop
            )

        else:
            raise ValueError(f"Proveedor no soportado: {cloud_provider}")
    else:
        # Usar Ollama local
        return Ollama(model=model, callbacks=callbacks, temperature=0, base_url='http://ollama:11434')


def response(query:str) -> str:
    # Parse the command line arguments
    args = parse_arguments()
    embeddings = HuggingFaceEmbeddings(model_name=embeddings_model_name)

    db = Chroma(client=CHROMA_SETTINGS, embedding_function=embeddings)

    retriever = db.as_retriever(search_kwargs={"k": target_source_chunks})
    # activate/deactivate the streaming StdOut callback for LLMs
    callbacks = [] if args.mute_stream else [StreamingStdOutCallbackHandler()]

    # Obtener el LLM según configuración
    llm = get_llm(callbacks)

    prompt = assistant_prompt()


    def format_docs(docs):
        return "\n\n".join(doc.page_content for doc in docs)


    rag_chain = (
        {"context": retriever | format_docs, "question": RunnablePassthrough()}
        | prompt
        | llm
        | StrOutputParser()
    )

    return rag_chain.invoke(query)