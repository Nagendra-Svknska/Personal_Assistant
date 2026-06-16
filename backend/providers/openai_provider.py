# providers/openai_provider.py
from openai import OpenAI
from providers.base_provider import BaseProvider
import os
from openai import RateLimitError

class OpenAIProvider(BaseProvider):

    def __init__(self):
        print("Initializing OpenAIProvider with API key:", os.getenv("OPENAI_API_KEY"))
        self.client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

    def generate(self, prompt):

        try:

            response = self.client.chat.completions.create(
                model="gpt-5",
                messages=[
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            )

            return response.choices[0].message.content
        except RateLimitError:
            return """OpenAI API quota exceeded.Please use other available models."""