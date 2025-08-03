import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import z from "zod";

export function registerPrompts(server: McpServer) {
  
   // Define a greeting prompt
    server.prompt(
        "greeting",
        {
        name: z.string(),
        time_of_day: z.enum(["morning", "afternoon", "evening", "night"])
        },
        ({ name, time_of_day }) => ({
            messages: [{
                role: "user",
                content: {
                type: "text",
                text: `Hello ${name}! Good ${time_of_day}. How are you today?`
                }
            }]
        })
    );
}