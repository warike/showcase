import express from 'express';
import type { Express } from 'express';
import healthRoutes from "@/routes/v1/health.route";
import chatRoutes from "@/routes/v1/chat.route";

const app: Express = express();

app.use(express.json());
app.use("/health", healthRoutes);
app.use("/v1/chat", chatRoutes);

export default app;