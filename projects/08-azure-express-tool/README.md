### Streaming Responses with Express and Azure OpenAI

#### Why it's important?

This project shows how to create a more responsive user experience in web applications by implementing data streaming instead of the traditional request-response model. It specifically focuses on using Server-Sent Events (SSE) with an Express API connected to a model hosted in Azure AI Foundry, which significantly reduces the perceived latency for the user by sending data as soon as it's available.

-----

  * **Context:** This project demonstrates how to move beyond the traditional request-response pattern to enable data streaming from an Express API to a client. The solution uses Server-Sent Events (SSE) to maintain a single, long-lived HTTP connection, allowing for a continuous flow of tokens from an Azure AI model. This approach improves user experience by delivering a partial response almost immediately, even though the total generation time remains the same. The guide includes the necessary code for setting up the Express API, configuring the request to the Azure AI endpoint for streaming, and processing the streamed response.
  * **Technology stack:**
      * **Framework:** Express.js
      * **Cloud Provider:** Azure AI Foundry
      * **Language:** JavaScript (Node.js)
      * **Tools:** `fetch`, `TextDecoder`, `curl`
  * **Learnings & Insights:**
      * The **request-response** model creates a poor user experience due to high latency, as the user must wait for the entire response to be generated.
      * **Server-Sent Events (SSE)** provide a simple and efficient way to stream data from a server to a client over a single HTTP connection, which is ideal for one-way communication and is easier to implement than WebSockets.
      * To enable streaming with Azure AI, you must explicitly set `"stream": true` in the request payload.
      * Appropriate response headers (`Content-Type: text/event-stream`, `Cache-Control: no-cache`, `Connection: keep-alive`) are crucial for ensuring clients like EventSource can correctly handle the stream.
      * Processing the streamed data involves reading the response body in chunks, decoding it, and formatting each part into valid SSE events.
  * **Status:** Completed.
  * **Resources:** [Code & Details](https://medium.com/@warike-tech)