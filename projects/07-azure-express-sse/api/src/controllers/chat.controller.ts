import { env } from "@/env";
import type { Request, Response } from "express";
import { get } from "lodash";

export const chat = async (req: Request, res: Response) => {
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");

    const payload = {
        input: req.body.input,
        model: req.body.model || "o4-mini",
        stream: true
    };

    try {
        const azureRes = await fetch(env.AZURE_ENDPOINT, {
            method: "POST",
            headers: {
                "Content-Type": "application/json;",
                "Authorization": `Bearer ${env.AZURE_API_KEY}`
            },
            body: JSON.stringify(payload)
        });

        if (!azureRes.ok || !azureRes.body) {
            const err = await azureRes.text();
            res.write(`event: error\ndata: ${err}\n\n`);
            res.end();
            return;
        }

        
        const reader = azureRes.body.getReader();
        const decoder = new TextDecoder("utf-8");

        while (true) {
            const { done, value } = await reader.read();
            if (done) break;

            const chunk = decoder.decode(value, { stream: true });

            for (const line of chunk.split("\n")) {
                if (line.startsWith("data: ")) {
                    const json = line.replace(/^data:\s*/, "");
                    const output = get(JSON.parse(json), "type", null)

                    if(output === "response.completed"){
                        res.write("event: done\ndata: [DONE]\n\n");
                        res.end();
                        return;
                    }
                    res.write(`data: ${json}\n\n`);
                }
            }
        }
    } catch (err) {
        console.error("Streaming error:", err);
        res.write(`event: error\ndata: ${JSON.stringify(err)}\n\n`);
        res.end();
    }
};