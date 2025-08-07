import { env } from "@/env";
import { tools } from "@/utils/tools";
import { getWeather } from "@/utils/weather";
import type { Request, Response } from "express";
import { get } from "lodash";

export const chat = async (req: Request, res: Response) => {
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");

    const userMessages = [
        { role: "user", content: req.body.input }
    ];

    const model = req.body.model || "o4-mini";

    const payload = {
        input: JSON.stringify(userMessages),
        model,
        tools,
        tool_choice: "auto",
        stream: true
    };

    try {
        const initialRequest = await fetch(env.AZURE_ENDPOINT, {
            method: "POST",
            headers: {
                "Content-Type": "application/json;",
                "Authorization": `Bearer ${env.AZURE_API_KEY}`
            },
            body: JSON.stringify(payload)
        });

        if (!initialRequest.ok || !initialRequest.body) {
            const err = await initialRequest.text();
            res.write(`event: error\ndata: ${err}\n\n`);
            res.end();
            return;
        }

        const decoder = new TextDecoder("utf-8");
        let reader = initialRequest.body.getReader();
        let toolTriggered = false;
        let updatedMessages = [...userMessages];

        while (true) {
            const { done, value } = await reader.read();
            if (done) break;

            const chunk = decoder.decode(value, { stream: true });
            const lines = chunk.split("\n");

            for (const line of lines) {
                if (!line.startsWith("data: ")) continue;
                const json = line.replace(/^data:\s*/, "");
                if (json === "[DONE]") {
                    res.write("event: done\ndata: [DONE]\n\n");
                    res.end();
                    return;
                }

                const parsed = JSON.parse(json);
                const outputs = get(parsed, "response.output", []);
                const type = get(parsed, "type");

                if (type === "response.completed" && outputs.length > 0) {
                    for (const output of outputs) {
                        const status = get(output, "status");
                        const outputType = get(output, "type");
                        if (status === "completed" && outputType === "function_call") {
                            const name = get(output, "name");
                            const params = JSON.parse(get(output, "arguments"));
                            const callId = get(output, "call_id");

                            if (name === "getWeather") {
                                toolTriggered = true;
                                const toolResponse = await getWeather(params);

                                updatedMessages = [
                                    ...userMessages,
                                    output,
                                    {
                                        type: "function_call_output",
                                        call_id: callId,
                                        output: toolResponse
                                    }
                                ];
                            }
                        }
                    }

                    if (toolTriggered) {
                        await reader.cancel(); // Stop the first stream
                        break; // exit first stream loop
                    }
                }

                res.write(`data: ${json}\n\n`);
            }
        }

        if (toolTriggered) {
            const secondPayload = {
                input: JSON.stringify(updatedMessages),
                model,
                tools,
                stream: true
            };

            const secondRequest = await fetch(env.AZURE_ENDPOINT, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json;",
                    "Authorization": `Bearer ${env.AZURE_API_KEY}`
                },
                body: JSON.stringify(secondPayload)
            });

            if (!secondRequest.ok || !secondRequest.body) {
                const err = await secondRequest.text();
                res.write(`event: error\ndata: ${err}\n\n`);
                res.end();
                return;
            }

            reader = secondRequest.body.getReader();
            while (true) {
                const { done, value } = await reader.read();
                if (done) break;

                const chunk = decoder.decode(value, { stream: true });
                for (const line of chunk.split("\n")) {
                    if (!line.startsWith("data: ")) continue;
                    const json = line.replace(/^data:\s*/, "");
                    if (json === "[DONE]") {
                        res.write("event: done\ndata: [DONE]\n\n");
                        res.end();
                        return;
                    }
                    res.write(`data: ${json}\n\n`);
                }
            }

            res.write("event: done\ndata: [DONE]\n\n");
            res.end();
        } else {
            res.write("event: done\ndata: [DONE]\n\n");
            res.end();
        }

    } catch (err) {
        console.error("Streaming error:", err);
        res.write(`event: error\ndata: ${JSON.stringify(err)}\n\n`);
        res.end();
    }
};