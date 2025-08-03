import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

export function registerResources(server: McpServer) {
  
    // Register a simple resource
    server.resource(
        "hello-world",
        "hello://world",
        async (uri) => ({
            contents: [{
                uri: uri.href,
                text: "This is a resources"
            }]
        })
    );
}