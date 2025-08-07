import { z } from "zod";

export const weatherSchema = z.object({
  location: z.string(),
  temperature: z.string().optional(),
  condition: z.string(),
});


export type Weather = z.infer<typeof weatherSchema>;