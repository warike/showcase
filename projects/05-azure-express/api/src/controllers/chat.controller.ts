import { env } from "@/env";
import type { Request, Response } from "express";

export const chat = async (req: Request, res: Response) => {
    try {
        const payload = {
            input: req.body.input,
            model: req.body.model || "o4-mini"
        };

        const azureRes = await fetch(env.AZURE_ENDPOINT, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${env.AZURE_API_KEY}`
            },
            body: JSON.stringify(payload)
        });

        const data = await azureRes.json();

        if (!azureRes.ok) {
            return res.status(azureRes.status).json({ error: data });
        }

        return res.status(200).json(data);
    } catch (error) {
        console.error("Error calling Azure OpenAI:", error);
        return res.status(500).json({ error: "Internal server error" });
    }
};