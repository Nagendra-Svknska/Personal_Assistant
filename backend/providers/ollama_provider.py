import requests

from providers.base_provider import BaseProvider


class OllamaProvider(BaseProvider):

    def __init__(
        self,
        model="qwen2.5-coder:7b",
        url="http://localhost:11434/api/generate"
    ):
        self.model = model
        self.url = url

    def generate(self, prompt):

        try:
            response = requests.post(
                self.url,
                json={
                    "model": self.model,
                    "prompt": prompt,
                    "stream": False
                }
            )

            response.raise_for_status()

            return response.json()["response"]
        except Exception:
            return """
    Ollama is not available.

    You are currently using the cloud deployment.
    Please switch to Gemini or OpenAI.
    """