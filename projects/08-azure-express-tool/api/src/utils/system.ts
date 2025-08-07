import os from "os";
import { execSync } from "child_process";
import { env } from "@/env";

export const getLocalIP = (): string => {
    try {
        const interfaces = os.networkInterfaces();
        for (const name of Object.keys(interfaces)) {
            for (const iface of interfaces[name] || []) {
                if (iface.family === "IPv4" && !iface.internal) {
                    return iface.address;
                }
            }
        }
    } catch (err) {
        if (env.NODE_ENV === "production")
        console.warn("Failed to get local IP:", err);
    }
    return "unavailable";
};

export const getEC2Metadata = (): { instanceId: string; publicIP: string } => {
    try {
        const instanceId = execSync(
            "curl -s --connect-timeout 0.5 http://169.254.169.254/latest/meta-data/instance-id"
        ).toString().trim();

        const publicIP = execSync(
            "curl -s --connect-timeout 0.5 http://169.254.169.254/latest/meta-data/public-ipv4"
        ).toString().trim();

        return {
            instanceId: instanceId || "unavailable",
            publicIP: publicIP || "unavailable",
        };
    } catch (err) {
        // show warning in production environment
        if (env.NODE_ENV === "production")
            console.warn("Failed to get EC2 metadata:", err);
        return { instanceId: "unavailable", publicIP: "unavailable" };
    }
};