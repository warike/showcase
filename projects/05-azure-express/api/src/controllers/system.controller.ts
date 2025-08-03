import os from "os";
import type { Request, Response } from "express";
import { getEC2Metadata, getLocalIP } from "@/utils/system";

export const healthCheck = async (_req: Request, res: Response) => {

    const hostname = os.hostname() || "unavailable";
    const localIP = getLocalIP();
    const { instanceId, publicIP } = getEC2Metadata();

    res.status(200).json({
        success: true,
        status: "system is running",
        hostname,
        localIP,
        publicIP,
        instanceId,
    });
};
