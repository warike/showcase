import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import { Request, Response } from "express";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";

const transports: { [sessionId: string]: SSEServerTransport } = {};

export function setupStreamableHTTPEndpoint(app: any, server: McpServer) {
  app.post("/mcp", async (req: Request, res: Response) => {
    try {
      const transport: StreamableHTTPServerTransport = new StreamableHTTPServerTransport({
        sessionIdGenerator: undefined,
      });
      res.on('close', () => {
        console.log('Request closed');
        transport.close();
        server.close();
      });
      await server.connect(transport);
      await transport.handleRequest(req, res, req.body);
    } catch (error) {
      console.error('Error handling MCP Stateless request:', error);
      if (!res.headersSent) {
        res.status(500).json({
          jsonrpc: '2.0',
          error: {
            code: -32603,
            message: 'Stateless - Internal server error',
          },
          id: null,
        });
      }
    }
  });
  app.get('/mcp', async (req: Request, res: Response) => {
    res.writeHead(405).end(JSON.stringify({
      jsonrpc: "2.0",
      error: {
        code: -32000,
        message: "Method not allowed."
      },
      id: null
    }));
  });
  app.delete('/mcp', async (req: Request, res: Response) => {
    res.writeHead(405).end(JSON.stringify({
      jsonrpc: "2.0",
      error: {
        code: -32000,
        message: "Method not allowed."
      },
      id: null
    }));
  });
}

export function setupSSEEndpoint(app: any, server: McpServer) {
  app.get("/sse", async (_: Request, res: Response) => {
    const transport = new SSEServerTransport("/messages", res);
    transports[transport.sessionId] = transport;
    res.on("close", () => {
      delete transports[transport.sessionId];
    });

    try {
      await server.connect(transport);
    } catch (error) {
      console.error(`Error connecting transport to MCP server. Session ID: ${transport.sessionId}`, error);
    }
  });
}
export function setupMessageEndpoint(app: any) {
    app.post("/messages", async (req: Request, res: Response) => {
      const sessionId = req.query.sessionId as string;
      const transport = transports[sessionId] ?? Object.values(transports)[0];
  
      if (transport) {
        try {
          await transport.handlePostMessage(req, res);
        } catch (error) {
          console.error(`Error handling message for Session ID: ${sessionId}`, error);
          res.status(500).send("Internal Server Error");
        }
      } else {
        console.error(`No transport found for Session ID: ${sessionId}`);
        res.status(400).send("No transport found for sessionId");
      }
    });
  }