from providers.ollama_provider import OllamaProvider
from providers.openai_provider import OpenAIProvider
from providers.gemini_provider import GeminiProvider


class ProviderFactory:

    @staticmethod
    def get_provider(provider_name):

        if provider_name == "openai":
            return OpenAIProvider()
        if provider_name == "gemini":
            return GeminiProvider()

        return OllamaProvider()