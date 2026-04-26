==Azure AI Foundry Endpoints==
===Meta-Llama-3-1-405B-Instruct-bnh===
https://Meta-Llama-3-1-405B-Instruct-bnh.eastus.models.ai.azure.com
FbyJ3PUlM3ANN062GMhiGcNcYVqRmkmy
https://Meta-Llama-3-1-405B-Instruct-bnh.eastus.models.ai.azure.com/swagger.json

from openai import OpenAI

client = OpenAI(
    base_url=f"{endpoint}",
    api_key=api_key
)

pip install openai

from openai import OpenAI

endpoint = "https://Meta-Llama-3-1-405B-Instruct-bnh.eastus.models.ai.azure.com/openai/v1/"
model_name = "Meta-Llama-3.1-405B-Instruct"
deployment_name = "Meta-Llama-3-1-405B-Instruct-bnh"

api_key = "<your-api-key>"

client = OpenAI(
    base_url=f"{endpoint}",
    api_key=api_key
)

completion = client.chat.completions.create(
    model=deployment_name,
    messages=[
        {
            "role": "user",
            "content": "What is the capital of France?",
        }
    ],
)

print(completion.choices[0].message)


===gpt-5-nano====
https://ybopenai.openai.azure.com/openai/deployments/gpt-5-nano/chat/completions?api-version=2025-01-01-preview
adfa35bb16a349e7bb1fe60839d41758

import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    azure_endpoint="https://ybopenai.openai.azure.com/",
    api_key=subscription_key
)

pip install openai

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.openai.azure.com/"
model_name = "gpt-5-nano"
deployment = "gpt-5-nano"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_completion_tokens=16384,
    model=deployment
)

print(response.choices[0].message.content)


===gpt-5-mini===
https://ybopenai.openai.azure.com/openai/responses?api-version=2025-04-01-preview
adfa35bb16a349e7bb1fe60839d41758

import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    azure_endpoint="https://ybopenai.openai.azure.com/",
    api_key=subscription_key
)

pip install openai

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.openai.azure.com/"
model_name = "gpt-5-mini"
deployment = "gpt-5-mini"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_completion_tokens=16384,
    model=deployment
)

print(response.choices[0].message.content)

===text-embedding-3-large===
https://yavuz-m4tobvdx-northcentralus.openai.azure.com/openai/deployments/text-embedding-3-large/embeddings?api-version=2023-05-15
EwmNrUxUrmJncfG1Ac6d2ulFYzYeQOtk4DhRmxA3fcMUilYwMlqTJQQJ99ALACHrzpqXJ3w3AAAAACOGBgPR


endpoint = "https://yavuz-m4tobvdx-northcentralus.openai.azure.com/"
model_name = "text-embedding-3-large"
deployment = "text-embedding-3-large"

api_version = "2024-02-01"

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    endpoint=endpoint,
    credential=AzureKeyCredential("<API_KEY>")
)

pip install openai

import os
from openai import AzureOpenAI

endpoint = "https://yavuz-m4tobvdx-northcentralus.openai.azure.com/"
model_name = "text-embedding-3-large"
deployment = "text-embedding-3-large"

api_version = "2024-02-01"

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    endpoint=endpoint,
    credential=AzureKeyCredential("<API_KEY>")
)

response = client.embeddings.create(
    input=["first phrase","second phrase","third phrase"],
    model=deployment
)

for item in response.data:
    length = len(item.embedding)
    print(
        f"data[{item.index}]: length={length}, "
        f"[{item.embedding[0]}, {item.embedding[1]}, "
        f"..., {item.embedding[length-2]}, {item.embedding[length-1]}]"
    )
print(response.usage)

===whisper===
https://yavuz-m4tobvdx-northcentralus.openai.azure.com/openai/deployments/whisper/audio/translations?api-version=2024-06-01
EwmNrUxUrmJncfG1Ac6d2ulFYzYeQOtk4DhRmxA3fcMUilYwMlqTJQQJ99ALACHrzpqXJ3w3AAAAACOGBgPR

===gpt-5.2===
https://yavuz-mggj7w5e-eastus2.cognitiveservices.azure.com/openai/responses?api-version=2025-04-01-preview
7F0pP8mCr4CsEtwI4jqXVBN4NvJ8hsEn04AQtFeUGkhIPVSuOa6vJQQJ99BJACHYHv6XJ3w3AAAAACOGlsAI

import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    azure_endpoint="https://yavuz-mggj7w5e-eastus2.cognitiveservices.azure.com/",
    api_key=subscription_key
)

pip install openai

import os
from openai import AzureOpenAI

endpoint = "https://yavuz-mggj7w5e-eastus2.cognitiveservices.azure.com/"
model_name = "gpt-5.2"
deployment = "gpt-5.2"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_completion_tokens=16384,
    model=deployment
)

print(response.choices[0].message.content)


===DeepSeek-V3.2===
https://ybopenai.services.ai.azure.com/models/chat/completions?api-version=2024-05-01-preview
Use parameter model = "DeepSeek-V3.2" to use this deployment in your request to use this deployment. Learn about model deployment routing .
https://ai.azure.com/doc/azure/ai-foundry/foundry-models/concepts/endpoints
adfa35bb16a349e7bb1fe60839d41758

from openai import OpenAI

client = OpenAI(
    base_url=f"{endpoint}",
    api_key=api_key
)

pip install openai

from openai import OpenAI

endpoint = "https://ybopenai.services.ai.azure.com/openai/v1/"
model_name = "DeepSeek-V3.2"
deployment_name = "DeepSeek-V3.2"

api_key = "<your-api-key>"

client = OpenAI(
    base_url=f"{endpoint}",
    api_key=api_key
)

completion = client.chat.completions.create(
    model=deployment_name,
    messages=[
        {
            "role": "user",
            "content": "What is the capital of France?",
        }
    ],
)

print(completion.choices[0].message)


===DeepSeek-R1===
https://ybopenai.services.ai.azure.com/models/chat/completions?api-version=2024-05-01-preview
Use parameter model = "DeepSeek-R1" to use this deployment in your request to use this deployment. Learn about model deployment routing .
https://ai.azure.com/doc/azure/ai-foundry/foundry-models/concepts/endpoints
adfa35bb16a349e7bb1fe60839d41758

from openai import OpenAI

client = OpenAI(
    base_url=f"{endpoint}",
    api_key=api_key
)

pip install openai

from openai import OpenAI

endpoint = "https://ybopenai.services.ai.azure.com/openai/v1/"
model_name = "DeepSeek-R1"
deployment_name = "DeepSeek-R1"

api_key = "<your-api-key>"

client = OpenAI(
    base_url=f"{endpoint}",
    api_key=api_key
)

completion = client.chat.completions.create(
    model=deployment_name,
    messages=[
        {
            "role": "user",
            "content": "What is the capital of France?",
        }
    ],
)

print(completion.choices[0].message)



==claude-opus-4-5==
https://yavuz-mggj7w5e-eastus2.services.ai.azure.com/anthropic/v1/messages
Use parameter model = "claude-opus-4-5" to use this deployment in your request to use this deployment. Learn about model deployment routing .
7F0pP8mCr4CsEtwI4jqXVBN4NvJ8hsEn04AQtFeUGkhIPVSuOa6vJQQJ99BJACHYHv6XJ3w3AAAAACOGlsAI

Rate limit (Tokens per minute)
100.000
Rate limit (Requests per minute)
100
SDK Anthoripc SDK
1. Authentication using API Key
For Messages API Endpoints, deploy the Model to generate the endpoint URL and an API key to authenticate against the service. In this sample endpoint and key are strings holding the endpoint URL and the API Key.

To create a client with the Anthropic SDK using an API key, initialize the client by passing your API key to the SDK's configuration. This allows you to authenticate and interact seamlessly:

from anthropic import AnthropicFoundry

client = AnthropicFoundry(
    api_key=api_key,
    base_url=endpoint
)

2. Install dependencies
Install the Anthropic SDK using pip (Requires: Python >=3.8):

pip install anthropic

3. Run a basic code sample
This sample demonstrates a basic call to the Messages API. The call is synchronous.

from anthropic import AnthropicFoundry

endpoint = "https://yavuz-mggj7w5e-eastus2.services.ai.azure.com/anthropic/"
deployment_name = "claude-opus-4-5"
api_key = "YOUR_API_KEY"

client = AnthropicFoundry(
    api_key=api_key,
    base_url=endpoint
)

message = client.messages.create(
    model=deployment_name,
    messages=[
        {"role": "user", "content": "What is the capital of France?"}
    ],
    max_tokens=1024,
)

print(message.content)




gpt-4o
https://ybopenai.cognitiveservices.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2025-01-01-preview
adfa35bb16a349e7bb1fe60839d41758

Language
Python
SDK
Azure OpenAI SDK
Authentication type
Key Authentication

Open in VS Code
Get Started
Below are example code snippets for a few use cases. For additional information about Azure OpenAI SDK, see full documentation  and samples .

1. Authentication using API Key
For OpenAI API Endpoints, deploy the Model to generate the endpoint URL and an API key to authenticate against the service. In this sample endpoint and key are strings holding the endpoint URL and the API Key.

The API endpoint URL and API key can be found on the Deployments + Endpoint page once the model is deployed.

To create a client with the OpenAI SDK using an API key, initialize the client by passing your API key to the SDK's configuration. This allows you to authenticate and interact with OpenAI's services seamlessly:

import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    azure_endpoint="https://ybopenai.cognitiveservices.azure.com/",
    api_key=subscription_key,
)

2. Install dependencies
Install the Azure Open AI SDK using pip (Requires: Python >=3.8):

pip install openai

3. Run a basic code sample
This sample demonstrates a basic call to the chat completion API. The call is synchronous.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4o"
deployment = "gpt-4o"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_tokens=4096,
    temperature=1.0,
    top_p=1.0,
    model=deployment
)

print(response.choices[0].message.content)

4. Explore more samples
Run a multi-turn conversation
This sample demonstrates a multi-turn conversation with the chat completion API. When using the model for a chat application, you'll need to manage the history of that conversation and send the latest messages to the model.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4o"
deployment = "gpt-4o"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        },
        {
            "role": "assistant",
            "content": "Paris, the capital of France, is known for its stunning architecture, art museums, historical landmarks, and romantic atmosphere. Here are some of the top attractions to see in Paris:\n\n1. The Eiffel Tower: The iconic Eiffel Tower is one of the most recognizable landmarks in the world and offers breathtaking views of the city.\n2. The Louvre Museum: The Louvre is one of the worlds largest and most famous museums, housing an impressive collection of art and artifacts, including the Mona Lisa.\n3. Notre-Dame Cathedral: This beautiful cathedral is one of the most famous landmarks in Paris and is known for its Gothic architecture and stunning stained glass windows.\n\nThese are just a few of the many attractions that Paris has to offer. With so much to see and do, its no wonder that Paris is one of the most popular tourist destinations in the world.",
        },
        {
            "role": "user",
            "content": "What is so great about #1?",
        }
    ],
    max_tokens=4096,
    temperature=1.0,
    top_p=1.0,
    model=deployment
)

print(response.choices[0].message.content)

Stream the output
For a better user experience, you will want to stream the response of the model so that the first token shows up early and you avoid waiting for long responses.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4o"
deployment = "gpt-4o"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    stream=True,
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_tokens=4096,
    temperature=1.0,
    top_p=1.0,
    model=deployment,
)

for update in response:
    if update.choices:
        print(update.choices[0].delta.content or "", end="")

client.close()



gpt-4.1

https://ybopenai.cognitiveservices.azure.com/openai/deployments/gpt-4.1/chat/completions?api-version=2025-01-01-preview
adfa35bb16a349e7bb1fe60839d41758
Language
Python
SDK
Azure OpenAI SDK
Authentication type
Key Authentication

Open in VS Code
Get Started
Below are example code snippets for a few use cases. For additional information about Azure OpenAI SDK, see full documentation  and samples .

1. Authentication using API Key
For OpenAI API Endpoints, deploy the Model to generate the endpoint URL and an API key to authenticate against the service. In this sample endpoint and key are strings holding the endpoint URL and the API Key.

The API endpoint URL and API key can be found on the Deployments + Endpoint page once the model is deployed.

To create a client with the OpenAI SDK using an API key, initialize the client by passing your API key to the SDK's configuration. This allows you to authenticate and interact with OpenAI's services seamlessly:

import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    azure_endpoint="https://ybopenai.cognitiveservices.azure.com/",
    api_key=subscription_key,
)

2. Install dependencies
Install the Azure Open AI SDK using pip (Requires: Python >=3.8):

pip install openai

3. Run a basic code sample
This sample demonstrates a basic call to the chat completion API. The call is synchronous.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4.1"
deployment = "gpt-4.1"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_completion_tokens=13107,
    temperature=1.0,
    top_p=1.0,
    frequency_penalty=0.0,
    presence_penalty=0.0,
    model=deployment
)

print(response.choices[0].message.content)

4. Explore more samples
Run a multi-turn conversation
This sample demonstrates a multi-turn conversation with the chat completion API. When using the model for a chat application, you'll need to manage the history of that conversation and send the latest messages to the model.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4.1"
deployment = "gpt-4.1"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        },
        {
            "role": "assistant",
            "content": "Paris, the capital of France, is known for its stunning architecture, art museums, historical landmarks, and romantic atmosphere. Here are some of the top attractions to see in Paris:\n\n1. The Eiffel Tower: The iconic Eiffel Tower is one of the most recognizable landmarks in the world and offers breathtaking views of the city.\n2. The Louvre Museum: The Louvre is one of the worlds largest and most famous museums, housing an impressive collection of art and artifacts, including the Mona Lisa.\n3. Notre-Dame Cathedral: This beautiful cathedral is one of the most famous landmarks in Paris and is known for its Gothic architecture and stunning stained glass windows.\n\nThese are just a few of the many attractions that Paris has to offer. With so much to see and do, its no wonder that Paris is one of the most popular tourist destinations in the world.",
        },
        {
            "role": "user",
            "content": "What is so great about #1?",
        }
    ],
    max_completion_tokens=13107,
    temperature=1.0,
    top_p=1.0,
    frequency_penalty=0.0,
    presence_penalty=0.0,
    model=deployment
)

print(response.choices[0].message.content)

Stream the output
For a better user experience, you will want to stream the response of the model so that the first token shows up early and you avoid waiting for long responses.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4.1"
deployment = "gpt-4.1"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    stream=True,
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_completion_tokens=13107,
    temperature=1.0,
    top_p=1.0,
    frequency_penalty=0.0,
    presence_penalty=0.0,
    model=deployment,
)

for update in response:
    if update.choices:
        print(update.choices[0].delta.content or "", end="")

client.close()

gpt-4.1-mini
https://ybopenai.cognitiveservices.azure.com/openai/deployments/gpt-4.1-mini/chat/completions?api-version=2025-01-01-preview
adfa35bb16a349e7bb1fe60839d41758

nguage
Python
SDK
Azure OpenAI SDK
Authentication type
Key Authentication

Open in VS Code
Get Started
Below are example code snippets for a few use cases. For additional information about Azure OpenAI SDK, see full documentation  and samples .

1. Authentication using API Key
For OpenAI API Endpoints, deploy the Model to generate the endpoint URL and an API key to authenticate against the service. In this sample endpoint and key are strings holding the endpoint URL and the API Key.

The API endpoint URL and API key can be found on the Deployments + Endpoint page once the model is deployed.

To create a client with the OpenAI SDK using an API key, initialize the client by passing your API key to the SDK's configuration. This allows you to authenticate and interact with OpenAI's services seamlessly:

import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_version="2024-12-01-preview",
    azure_endpoint="https://ybopenai.cognitiveservices.azure.com/",
    api_key=subscription_key,
)

2. Install dependencies
Install the Azure Open AI SDK using pip (Requires: Python >=3.8):

pip install openai

3. Run a basic code sample
This sample demonstrates a basic call to the chat completion API. The call is synchronous.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4.1-mini"
deployment = "gpt-4.1-mini"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_completion_tokens=13107,
    temperature=1.0,
    top_p=1.0,
    frequency_penalty=0.0,
    presence_penalty=0.0,
    model=deployment
)

print(response.choices[0].message.content)

4. Explore more samples
Run a multi-turn conversation
This sample demonstrates a multi-turn conversation with the chat completion API. When using the model for a chat application, you'll need to manage the history of that conversation and send the latest messages to the model.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4.1-mini"
deployment = "gpt-4.1-mini"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        },
        {
            "role": "assistant",
            "content": "Paris, the capital of France, is known for its stunning architecture, art museums, historical landmarks, and romantic atmosphere. Here are some of the top attractions to see in Paris:\n\n1. The Eiffel Tower: The iconic Eiffel Tower is one of the most recognizable landmarks in the world and offers breathtaking views of the city.\n2. The Louvre Museum: The Louvre is one of the worlds largest and most famous museums, housing an impressive collection of art and artifacts, including the Mona Lisa.\n3. Notre-Dame Cathedral: This beautiful cathedral is one of the most famous landmarks in Paris and is known for its Gothic architecture and stunning stained glass windows.\n\nThese are just a few of the many attractions that Paris has to offer. With so much to see and do, its no wonder that Paris is one of the most popular tourist destinations in the world.",
        },
        {
            "role": "user",
            "content": "What is so great about #1?",
        }
    ],
    max_completion_tokens=13107,
    temperature=1.0,
    top_p=1.0,
    frequency_penalty=0.0,
    presence_penalty=0.0,
    model=deployment
)

print(response.choices[0].message.content)

Stream the output
For a better user experience, you will want to stream the response of the model so that the first token shows up early and you avoid waiting for long responses.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.cognitiveservices.azure.com/"
model_name = "gpt-4.1-mini"
deployment = "gpt-4.1-mini"

subscription_key = "<your-api-key>"
api_version = "2024-12-01-preview"

client = AzureOpenAI(
    api_version=api_version,
    azure_endpoint=endpoint,
    api_key=subscription_key,
)

response = client.chat.completions.create(
    stream=True,
    messages=[
        {
            "role": "system",
            "content": "You are a helpful assistant.",
        },
        {
            "role": "user",
            "content": "I am going to Paris, what should I see?",
        }
    ],
    max_completion_tokens=13107,
    temperature=1.0,
    top_p=1.0,
    frequency_penalty=0.0,
    presence_penalty=0.0,
    model=deployment,
)

for update in response:
    if update.choices:
        print(update.choices[0].delta.content or "", end="")

client.close()

whisper
https://yavuz-m4tobvdx-northcentralus.openai.azure.com/openai/deployments/whisper/audio/translations?api-version=2024-06-01
EwmNrUxUrmJncfG1Ac6d2ulFYzYeQOtk4DhRmxA3fcMUilYwMlqTJQQJ99ALACHrzpqXJ3w3AAAAACOGBgPR


claude-opus-4-5
https://yavuz-mggj7w5e-eastus2.services.ai.azure.com/anthropic/v1/messages
7F0pP8mCr4CsEtwI4jqXVBN4NvJ8hsEn04AQtFeUGkhIPVSuOa6vJQQJ99BJACHYHv6XJ3w3AAAAACOGlsAI

Language
Python
SDK
Anthropic SDK
Authentication type
Key Authentication

Open in VS Code
Get Started
1. Authentication using API Key
For Messages API Endpoints, deploy the Model to generate the endpoint URL and an API key to authenticate against the service. In this sample endpoint and key are strings holding the endpoint URL and the API Key.

To create a client with the Anthropic SDK using an API key, initialize the client by passing your API key to the SDK's configuration. This allows you to authenticate and interact seamlessly:

from anthropic import AnthropicFoundry

client = AnthropicFoundry(
    api_key=api_key,
    base_url=endpoint
)

2. Install dependencies
Install the Anthropic SDK using pip (Requires: Python >=3.8):

pip install anthropic

3. Run a basic code sample
This sample demonstrates a basic call to the Messages API. The call is synchronous.

from anthropic import AnthropicFoundry

endpoint = "https://yavuz-mggj7w5e-eastus2.services.ai.azure.com/anthropic/"
deployment_name = "claude-opus-4-5"
api_key = "YOUR_API_KEY"

client = AnthropicFoundry(
    api_key=api_key,
    base_url=endpoint
)

message = client.messages.create(
    model=deployment_name,
    messages=[
        {"role": "user", "content": "What is the capital of France?"}
    ],
    max_tokens=1024,
)

print(message.content)

Rate limit (Tokens per minute)
100.000
Rate limit (Requests per minute)
100

gpt-4o-mini-tts
https://yavuz-mggj7w5e-eastus2.openai.azure.com/openai/deployments/gpt-4o-mini-tts/audio/speech?api-version=2025-03-01-preview


7F0pP8mCr4CsEtwI4jqXVBN4NvJ8hsEn04AQtFeUGkhIPVSuOa6vJQQJ99BJACHYHv6XJ3w3AAAAACOGlsAI

Language
REST
SDK
curl
Authentication type
Key Authentication
Get Started
1. Authentication using API Key
For Serverless API Endpoints, deploy the Model to generate the endpoint URL and an API key to authenticate against the service. In this sample endpoint and key are strings holding the endpoint URL and the API Key. The API endpoint URL and API key can be found on the Deployments + Endpoint page once the model is deployed.

If you're using bash:

export AZURE_API_KEY="<your-api-key>"

If you're in powershell:

$Env:AZURE_API_KEY = "<your-api-key>"

If you're using Windows command prompt:

set AZURE_API_KEY = <your-api-key>

2. Run a basic code sample
Paste the following into a shell

curl -X POST "https://yavuz-mggj7w5e-eastus2.openai.azure.com/openai/deployments/gpt-4o-mini-tts/audio/speech?api-version=2025-03-01-preview" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AZURE_API_KEY" \
  -d '{
      "model": "gpt-4o-mini-tts",
      "input": "The quick brown fox jumped over the lazy dog",
      "voice": "alloy"
    }'

