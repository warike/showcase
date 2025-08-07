// src/env.ts
import { z } from "zod";
import * as dotenv from "dotenv";

dotenv.config()

const envSchema = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  PORT: z.string().regex(/^\d+$/).transform(Number).default(4000),

  // Azure OpenAI
  AZURE_ENDPOINT: z.url().nonempty(),
  AZURE_API_KEY: z.string().nonempty(),

});

const _env = envSchema.safeParse(process.env);

if (!_env.success) {
  console.error("❌ Invalid environment variables:", _env.error.flatten().fieldErrors);
  process.exit(1);
}

export const env = _env.data;