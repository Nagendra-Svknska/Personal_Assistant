import os

from google import genai

from providers.base_provider import BaseProvider


class GeminiProvider(BaseProvider):

    def __init__(self):

        self.client = genai.Client(
            api_key=os.getenv(
                "GEMINI_API_KEY"
            )
        )

    def generate(self, prompt):

        response = self.client.models.generate_content(
            model="gemini-2.5-flash",
            contents=prompt
        )

        return response.text