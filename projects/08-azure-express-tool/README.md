### AI Function Calling with Express and Azure OpenAI

#### Why it's important?

This project demonstrates how to enable an AI model to **proactively use external tools** (functions) to better respond to user requests. By allowing the model to decide when and how to call a predefined function, the application becomes more powerful and dynamic. The implementation showcases a two-step process: first, the model identifies the need for a function call; then, the API executes the function and sends the result back to the model for a final, comprehensive response.

-----

  * **Context:** This guide focuses on extending a simple Express API to handle complex, multi-step interactions with an Azure AI model. Building upon a previous streaming implementation, this solution enables the model to identify and trigger "tool" functions, such as `getWeather`. The API acts as an intermediary, executing the function call, and then sends the results back to the model to generate a final, coherent response, all while maintaining a streamlined streaming experience for the client.

  * **Technology stack:**

      * **Framework:** Express.js
      * **Cloud Provider:** Azure AI Foundry
      * **Language:** JavaScript (Node.js)
      * **Tools:** `fetch`, `TextDecoder`, `curl`

  * **Learnings & Insights:**

      * **Conversation Format:** To enable function calling, the interaction with the model must be structured as a conversation with distinct roles (`user`, `assistant`, `function_call_output`). The API manages this conversation state.
      * **Two-Request Workflow:** The process involves a two-part conversation. The first request includes the user's message and available tools. If the model decides to use a tool, the API executes the function locally and then sends a second request with the function's output, allowing the model to formulate the final answer.
      * **Tool Definition:** Functions must be described to the model using a specific schema that includes the function's name, description, and required parameters. This allows the model to "reason" about when and how to use them.
      * **Operational Excellence:** Implementing such a solution highlights the importance of backend functionalities like observability and cost control, as the number of requests and tokens can increase, especially in multi-step workflows.

  * **Status:** Completed.

  * **Resources:** [Code & Details](https://medium.com/warike)