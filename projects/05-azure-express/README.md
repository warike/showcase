### Building a Chat Endpoint with Express and Azure AI Foundry

#### Why it is important?

This project provides a practical guide for creating a chat API endpoint using **Express.js** that connects to a large language model (LLM) hosted on **Azure AI Foundry**. It demonstrates a straightforward approach for bridging a frontend application with a model provider, highlighting the simplicity of a direct HTTP request approach and setting the stage for more advanced solutions like Server-Sent Events (**SSE**).

-----

  * **Context:** This project focuses on building a simple but effective API flow. It involves setting up a basic **Express.js** server, defining routes, and creating a controller that handles incoming HTTP requests. The controller then transforms the request and forwards it to the **Azure OpenAI** service via a direct `fetch` call. The response from Azure is then sent back to the client. The core goal is to establish the fundamental communication loop between a client and the AI model without relying on complex frameworks or SDKs.

  * **Technology stack:**

      * **Backend Framework:** Express.js
      * **Language:** TypeScript
      * **Cloud Provider:** Azure AI Foundry
      * **Package Manager:** pnpm
      * **Tools:** `dotenv`, `zod`, `curl`

  * **Learnings & Insights:** The project emphasizes the importance of understanding the foundational principles of internet communication, particularly the **HTTP protocol**. It shows that a direct `fetch` call can be an effective way to interact with a model provider. A key insight is that while this simple approach works for service-to-service communication, it introduces latency that is often unacceptable for direct human interaction. This realization motivates the need for more sophisticated solutions, such as **Server-Sent Events (SSE)**, which will be explored in future posts to address this latency challenge.

  * **Status:** Completed.

  * **Resources:** [Code & Details](https://medium.com/agranimo/create-chat-endpoint-with-express-047cf7771059)

-----