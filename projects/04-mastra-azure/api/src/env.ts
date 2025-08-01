// src/env.ts
import { z } from "zod";
import * as dotenv from "dotenv";

dotenv.config(); // carga las variables desde .env

const envSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  PORT: z.string().regex(/^\d+$/).transform(Number).default("4000"),

  AZURE_RESOURCE_NAME: z.string().min(1, "AZURE_RESOURCE_NAME is required"),
  AZURE_API_KEY: z.string().min(1, "AZURE_API_KEY is required"),
  AZURE_API_VERSION: z.string().min(1, "AZURE_API_VERSION is required"),
});

const _env = envSchema.safeParse(process.env);

if (!_env.success) {
  console.error("❌ Invalid environment variables:", _env.error.flatten().fieldErrors);
  process.exit(1);
}

export const env = _env.data;