import { formatCurrentWeatherData, formatStationsData, makeWLRequest, WL_API_BASE } from "./helper";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import type { WL_CurrentData } from "@/types/current-data";
import { WL_Stations } from "@/types/station";

// Helper function for making Weather Link API requests
// source: https://weatherlink.github.io/v2-api/api-reference

export function registerTools(server: McpServer) {  
  // Register a tool specifically for testing resumability
  server.tool(
      "get-stations-current-data",
      "Get current data for a specific station",
      {
          stationId: z.string().describe("Weather station ID"),
          apiKeySecret: z.string().describe("API key secret for Weather Link API"),
          apiKey: z.string().describe("API key for Weather Link API"),
      },
      async ({ stationId, apiKeySecret, apiKey }) => {

        const currentUrl = `${WL_API_BASE}/current/${stationId}`;
        try {
            const currentData = await makeWLRequest<WL_CurrentData>(
                currentUrl,
                apiKeySecret,
                apiKey
            );
            if(!currentData) {
                return {
                    content: [
                        {
                            type: "text",
                            text: `Failed to retrieve current data for: ${stationId}. This station may not be supported by the WeatherLink API.`,
                        },
                    ],
                };
            }
            const formattedWeather = formatCurrentWeatherData(currentData);
            return {
                content: [
                    {
                        type: "text",
                        text: formattedWeather
                    },
                ],
            };
        } catch (error) {
          console.error(`Error requesting current data for: ${stationId}`, error);
          const errorMessage = error instanceof Error ? error.message : `Failed to retrieve current data for: ${stationId}. This station may not be supported by the WeatherLink API.`;

          return {
              content: [
                  {
                      type: "text",
                      text: errorMessage,
                  },
              ],
          };
        }
          
      }
  );

  server.tool(
    "get-all-stations",
    "Get all stations form the user, retrieving station-id, location and other details.",
    {
        apiKeySecret: z.string().describe("API key secret for Weather Link API"),
        apiKey: z.string().describe("API key for Weather Link API"),
    },
    async ({ apiKeySecret, apiKey }) => {

      const currentUrl = `${WL_API_BASE}/stations`;
      try {
          const stations = await makeWLRequest<WL_Stations>(
              currentUrl,
              apiKeySecret,
              apiKey
          );
          if(!stations) {
              return {
                  content: [
                      {
                          type: "text",
                          text: `Failed to retrieve stations data: This query may not be supported by the WeatherLink API.`,
                      },
                  ],
              };
          }

          const formattedStations = formatStationsData(stations);

          return {
              content: [
                  {
                      type: "text",
                      text: formattedStations
                  },
              ],
          };
      } catch (error) {
        console.error(`Error requesting stations`, error);
        const errorMessage = error instanceof Error ? error.message : `Failed to retrieve stations data. This query may not be supported by the WeatherLink API.`;

        return {
            content: [
                {
                    type: "text",
                    text: errorMessage,
                },
            ],
        };
      }
        
    }
);
}