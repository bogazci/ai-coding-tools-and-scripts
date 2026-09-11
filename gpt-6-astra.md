gpt-6-astra
https://ybopenai.openai.azure.com/openai/responses?api-version=2025-04-01-preview
adfa35bb16a349e7bb1fe60839d41758


yavuzbogazci-1749
Models + endpoints
gpt-6-astra

All resources




Project
yavuzbogazci-1749


YB
Try the new Microsoft Foundry experience
Build and deploy your AI solutions faster, safer, and with the reliability you expect.Learn more
Start building



Overview
Model catalog
Playgrounds
AI Services
Build and customize

Agents
PREVIEW
Templates
Fine-tuning
Content Understanding
Prompt flow
Observe and optimize

Tracing
PREVIEW
Monitoring
Protect and govern

Evaluation
Guardrails + controls
Risks + alerts
PREVIEW
Governance
PREVIEW
My assets

Models + endpoints
Data + indexes
Web apps

More
Management center


gpt-6-astra

Help

Details

Consume

Metrics


Open in playground


Request quota


Edit


Delete
Endpoint
Target URI
https://ybopenai.openai.azure.com/openai/responses?api-version=2025-04-01-preview

Authentication type
Key
Key
••••••••••••••••••••••••••••••••



Deployment info
Name
gpt-6-astra
Provisioning state
Succeeded
Deployment type
Global Standard
Created on
2026-09-11T09:52:24.8917664Z
Created by
fcbb7378-6244-4c5d-b062-e8f174dab791
Modified on
Sep 11, 2026 11:52 AM
Modified by
fcbb7378-6244-4c5d-b062-e8f174dab791
Version upgrade policy
Once a new default version is available
Rate limit (Tokens per minute)
250.000
Rate limit (Requests per minute)
250
Model name
gpt-6-astra
Model version
2026-09-03
Life cycle status
GenerallyAvailable
Date created
Sep 3, 2026 2:00 AM
Date updated
Sep 3, 2026 2:00 AM
Model retirement date
Jan 11, 2028 1:00 AM
Monitoring & safety
Content filter
DefaultV2
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
    azure_endpoint="https://ybopenai.openai.azure.com/",
    api_key=subscription_key
)

2. Install dependencies
Install the Azure Open AI SDK using pip (Requires: Python >=3.8):

pip install openai

3. Run a basic code sample
This sample demonstrates a basic call to the chat completion API. The call is synchronous.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.openai.azure.com/"
model_name = "gpt-6-astra"
deployment = "gpt-6-astra"

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

4. Explore more samples
Run a multi-turn conversation
This sample demonstrates a multi-turn conversation with the chat completion API. When using the model for a chat application, you'll need to manage the history of that conversation and send the latest messages to the model.

import os
from openai import AzureOpenAI

endpoint = "https://ybopenai.openai.azure.com/"
model_name = "gpt-6-astra"
deployment = "gpt-6-astra"

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
    max_completion_tokens=16384,
    model=deployment
)

print(response.choices[0].message.content)

