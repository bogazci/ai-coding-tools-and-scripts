
claude-fable-5-1
https://yavuz-mggj7w5e-eastus2.services.ai.azure.com/anthropic/v1/messages
7F0pP8mCr4CsEtwI4jqXVBN4NvJ8hsEn04AQtFeUGkhIPVSuOa6vJQQJ99BJACHYHv6XJ3w3AAAAACOGlsAI

https://learn.microsoft.com/de-de/azure/foundry/foundry-models/concepts/endpoints?tabs=python#routing
yavuzbogazci-1749
Models + endpoints
claude-fable-5-1

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
claude-fable-5-1

Help

Details

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
https://yavuz-mggj7w5e-eastus2.services.ai.azure.com/anthropic/v1/messages

Use parameter model = "claude-fable-5-1" to use this deployment in your request to use this deployment. Learn about model deployment routing .
Authentication type
Key
Key
••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••



Deployment info
Name
claude-fable-5-1
Provisioning state
Succeeded
Deployment type
Global Standard
Created on
2026-09-11T09:51:39.6315292Z
Created by
fcbb7378-6244-4c5d-b062-e8f174dab791
Modified on
Sep 11, 2026 11:51 AM
Modified by
fcbb7378-6244-4c5d-b062-e8f174dab791
Version upgrade policy
Once a new default version is available
Rate limit (Tokens per minute)
250.000
Rate limit (Requests per minute)
250
Model name
claude-fable-5-1
Model version
1
Life cycle status
Preview
Date created
Aug 25, 2026 2:00 AM
Date updated
Aug 25, 2026 2:00 AM
Model retirement date
Dec 5, 2027 1:00 AM
Monitoring & safety
Content filter
To configure Foundry content filters with claude-fable-5-1, please use Azure AI Content Safety API, as integrated content filters are not yet available. Learn more. 
Language
Python
SDK
Anthropic SDK
Authentication type
Key Authentication

No code samples found

Please check out the Azure inference documentation for additional reference.

View Documentation 

Zu Hauptinhalt wechseln
Microsoft Ignite
17.-20. November 2026

Learn
Anmelden
Azure
Teile dieses Themas wurden möglicherweise maschinell oder mit KI übersetzt.

Suche
Nach Titel suchen
Was ist Microsoft Foundry?
Produkt- und Fähigkeitsübersicht
Fähigkeitsreferenz
Übersicht
Endpunkte
Codex
Webhooks
Claude Code
Claude-Desktop
LearnAzureMicrosoft Foundry
Endpunkte für Microsoft Foundry-Modelle
Microsoft Foundry Models bietet Zugriff auf eine Vielzahl von Modellen von vielen Anbietern über einen einzelnen Endpunkt und einen Satz von Anmeldeinformationen. Mit dieser Funktion können Sie zwischen Modellen wechseln und sie in Ihrer Anwendung verwenden, ohne Codeänderungen vorzunehmen.

In diesem Artikel wird erläutert, wie die Foundry-Dienste Modelle organisieren und wie Sie den Ableitungsendpunkt verwenden, um darauf zuzugreifen.

Voraussetzungen
Ein Azure-Abonnement. Wenn Sie kein Konto haben, erstellen Sie ein kostenloses Konto.
Eine Microsoft Foundry-Ressource. Wenn Sie nicht über eine Ressource verfügen, erstellen Sie eine Ressource, und stellen Sie ein Modell bereit.
Mindestens eine Modellbereitstellung in Ihrer Ressource.
Die neueste Version des OpenAI SDK für Ihre Sprache (Python, JavaScript, C# oder Java) oder einen REST-Client wie curlz. B. .
Um die schlüssellose Authentifizierung zu verwenden, sind die erforderlichen Microsoft Entra ID Rollenzuweisungen für die Ressource erforderlich.
Bereitstellungen
Foundry verwendet Deployments als Aliase für den Zugriff auf Modelle. Eine Bereitstellung gibt einem Modell einen Namen und eine Reihe von Konfigurationen. Sie greifen auf ein Modell zu, indem Sie in Ihren Anfragen dessen Bereitstellungsnamen verwenden.

Eine Bereitstellung definiert Folgendes:

Ein Modellname
Eine Modellversion
Bereitstellungs- oder Kapazitätstyp1
Konfiguration der Inhaltsfilterung1
Eine Ratenbegrenzungskonfiguration1
1 Diese Konfigurationen können sich je nach ausgewähltem Modell ändern.

Eine Foundry-Ressource kann viele Modellimplementierungen aufweisen. Sie zahlen nur für Rückschlüsse, die für Modellbereitstellungen ausgeführt wurden. Bereitstellungen sind Azure Ressourcen, sodass sie Azure Richtlinien unterliegen.

Weitere Informationen zum Erstellen von Bereitstellungen finden Sie unter Hinzufügen und Konfigurieren von Modellbereitstellungen.

Azure OpenAI-Inference-Endpunkt
Die Azure OpenAI-API macht die vollständigen Funktionen von OpenAI-Modellen verfügbar und unterstützt weitere Features wie Assistenten, Threads, Dateien und Batcheinschluss. Sie können es auch verwenden, um auf Nicht-OpenAI-Modelle zuzugreifen.

Azure OpenAI-Endpunkte haben das Format https://<resource-name>.openai.azure.com. Endpunkte sind Bereitstellungen zugeordnet, und jede Bereitstellung verfügt über eine eigene URL. Sie können jedoch denselben Authentifizierungsmechanismus verwenden, um mehrere Bereitstellungen zu nutzen. Weitere Informationen finden Sie auf der Referenzseite für Azure OpenAI-API.

Eine Illustration, die zeigt, wie Azure OpenAI-Bereitstellungen eine eindeutige URL für jede Bereitstellung enthalten.

Bereitstellungs-URLs werden durch Verketten der Azure OpenAI-Basis-URL und der Route /deployments/<model-deployment-name>gebildet. Wenn Sie die OpenAI v1-API verwenden, rufen Sie die /openai/v1/ Route auf der Basis-URL auf, https://<resource-name>.openai.azure.com/openai/v1/und übergeben Sie den Bereitstellungsnamen im model Feld Ihrer Anforderung. Die /openai/v1/-Route verwendet implizite Versionierung, sodass Sie kein api-version übergeben.

In den folgenden Beispielen wird die Antwort-API verwendet, die die neuesten Rückschlussfunktionen unterstützt.

 Hinweis

Die Antwort-API funktioniert mit Azure OpenAI-Modellen und mit Foundry-Modellen, die von Azure verkauft werden, die es unterstützen, z. B. DeepSeek-, Llama- und Grok-Modelle. Wenn eine Bereitstellung die Antwort-API nicht unterstützt, wird die Anforderung zurückgegeben 400 Model not supported. Verwenden Sie in diesem Fall die Chatabschluss-API, indem Sie stattdessen aufrufen client.chat.completions.create .

Verwenden der API-Schlüsselauthentifizierung
Sie können Rückschlussanforderungen mit einem API-Schlüssel aus Ihrer Foundry-Ressource authentifizieren. API-Schlüssel sind schnell einzurichten, aber sie gewähren vollzugriff auf die Ressource, sind schwer auf bestimmte Benutzer oder Aktionen zu beschränken und erfordern eine manuelle Drehung, um sicher zu bleiben. Verwenden Sie für Produktionsworkloads stattdessen die schlüssellose Authentifizierung mit Microsoft Entra ID.

Im folgenden Beispiel deepseek-v3-0324 ist der Name einer Modellbereitstellung in der Microsoft Foundry-Ressource. Ersetzen Sie ihn durch Ihren eigenen Bereitstellungsnamen, und speichern Sie Ihren API-Schlüssel in der AZURE_INFERENCE_CREDENTIAL Umgebungsvariable.

Python
Javascript
C#
Java
REST
Installieren Sie das openai Paket mithilfe von pip:

Bash
pip install openai --upgrade
Erstellen Sie einen Client, der auf den Azure OpenAI v1-Endpunkt verweist, und generieren Sie dann eine Antwort. Die /openai/v1/-Route verwendet implizite Versionierung, sodass Sie kein api-version übergeben. Geben Sie Ihren Deployment-Namen im Feld model ein:

Python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://<resource>.openai.azure.com/openai/v1/",
    api_key=os.environ["AZURE_INFERENCE_CREDENTIAL"],
)

response = client.responses.create(
    model="deepseek-v3-0324",  # Replace with your model deployment name.
    input="Explain the Riemann hypothesis in one paragraph.",
)

print(response.output_text)
Weitere Informationen zur Verwendung des Azure OpenAI-Endpunkts finden Sie unter Azure OpenAI SDK-Sprachunterstützung.

Verwenden der schlüssellosen Authentifizierung
Bereitgestellte Foundry Models unterstützen die schlüssellose Autorisierung mit Microsoft Entra ID. Die schlüssellose Autorisierung verbessert die Sicherheit, vereinfacht die Benutzererfahrung, verringert die Betriebskomplexität und bietet eine robuste Complianceunterstützung. Verwenden Sie schlüssellose Autorisierung, wenn Ihre Organisation sichere und skalierbare Identitätsverwaltungslösungen verwendet.

Um die schlüssellose Authentifizierung zu verwenden, konfigurieren Sie Ihre Ressource, und gewähren Sie Benutzern Zugriff auf die Durchführung von Rückschlüssen. Nachdem Sie die Ressource konfiguriert und Zugriff gewährt haben, authentifizieren Sie sich wie folgt:

Python
C#
Javascript
Java
REST
Installieren Sie das OpenAI SDK mit einem Paket-Manager wie pip:

Bash
pip install openai
Installieren Sie für Microsoft Entra ID Authentifizierung auch Folgendes:

Bash
pip install azure-identity
Verwenden des Pakets, um das Modell zu nutzen. Das folgende Beispiel zeigt, wie Sie einen Client erstellen und mithilfe von Microsoft Entra ID und Ihrer Modellbereitstellung einen Testaufruf für die Responses-API ausführen.

Ersetzen Sie <resource> durch den Namen Ihrer Foundry-Ressource. Suchen Sie es im Azure-Portal oder indem Sie az cognitiveservices account list ausführen. Ersetzen Sie deepseek-v3-0324 durch Ihren tatsächlichen Bereitstellungsnamen.

Python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(), 
    "https://ai.azure.com/.default"
)

client = OpenAI(
    base_url="https://<resource>.openai.azure.com/openai/v1/",
    api_key=token_provider,
)

response = client.responses.create(
    model="deepseek-v3-0324",  # Replace with your model deployment name.
    input="What is Azure AI?",
)

print(response.output_text)
Erwartete Ausgabe

Output
Azure AI is a comprehensive suite of artificial intelligence services and tools from Microsoft that enables developers to build intelligent applications. It includes services for natural language processing, computer vision, speech recognition, and machine learning capabilities.
Referenz: OpenAI Python SDK und DefaultAzureCredential-Klasse.

Verwandte Inhalte
Wie sie Textantworten mit Microsoft Foundry Models generieren
Azure OpenAI in Microsoft Foundry Models v1 API
Foundry Models und Funktionalitäten
Bereitstellungstypen in Foundry-Modellen
Sofortiger Zugriff auf Modelle in Microsoft Foundry (Vorschau)
Hinweis: Der Autor hat diesen Artikel mit Unterstützung von KI erstellt. Weitere Informationen
Zusätzliche Ressourcen
Dokumentation

Azure OpenAI SDK language support - Microsoft Foundry

Compare Azure OpenAI SDK support for Python, C#, JavaScript, Java, and Go, with current examples for authentication and model inference.

How to migrate from Azure AI Inference SDK to OpenAI SDK - Microsoft Foundry

Migrate your app from the Azure AI Inference SDK to the OpenAI SDK for better compatibility and unified API access to Foundry Models.

Deploy models using Azure CLI and Bicep - Microsoft Foundry

Learn how to add and configure Microsoft Foundry Models in your Foundry resource for use in inference applications using Azure CLI and Bicep templates.

4 weitere anzeigen
Last updated on 21.08.2026
In diesem Artikel
Voraussetzungen
Bereitstellungen
Azure OpenAI-Inference-Endpunkt
Verwandte Inhalte
War diese Seite hilfreich?



Cookies verwalten
KI-Haftungsausschluss
Frühere Versionen
Blog
Mitwirken
Datenschutz
Consumer Health Privacy
Nutzungsbedingungen
Impressum
Marken
© Microsoft 2026
