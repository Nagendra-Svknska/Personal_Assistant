from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from providers.provider_factory import ProviderFactory
from providers.ollama_provider import OllamaProvider
from dotenv import load_dotenv

load_dotenv()
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)




class ChatRequest(BaseModel):
    message: str
    provider: str


@app.post("/chat")
def chat(request: ChatRequest):

    print("MESSAGE:", request.message)

    # provider = OllamaProvider()

    provider_name = request.provider

    provider = ProviderFactory.get_provider(provider_name)

    response = provider.generate(request.message)

    return {
        "response": response
    }