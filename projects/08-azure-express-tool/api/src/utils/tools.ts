
export const tools = [
    {
        type: "function",
        name: "getWeather",
        description: "Gets the current weather in a given city",
        parameters: {
            type: "object",
            properties: {
                location: {
                    type: "string",
                    description: "City and country e.g. Arica, Chile"
                }
            },
            required: [
                "location"
            ],
            additionalProperties: false
        }
    }
];
