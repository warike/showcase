import express from "express";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { registerTools } from "./modules/tools"; 
import { registerPrompts } from "./modules/prompts";
import { setupStreamableHTTPEndpoint } from "./modules/transport";

// Create server instance
const server = new McpServer({
    name: "mcp-weather-link",
    version: "1.0.0",
    capabilities: {
    tools:     { listChanged: true },
    resources: { listChanged: true },
    prompts:   { listChanged: true }
    }
});
const app = express();

// Register tools and prompts
registerTools(server);
registerPrompts(server);

// Setup endpoints
setupStreamableHTTPEndpoint(app, server);

const port = parseInt(process.env.PORT || "4000", 10);
app.listen(port, () => {
    console.log(`MCP server is running on port ${port}`);
});