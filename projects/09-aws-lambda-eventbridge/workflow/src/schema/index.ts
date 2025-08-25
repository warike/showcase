import { z } from 'zod';

export const dataSchema = z.object({

  email: z.email(),
  language: z.string(),
  
  expected_period: z.number().min(1).max(20).int().transform(String),
  exposure_time: z.number().min(1).max(20).int().transform(String),
  city_name: z.string(),

  created_at: z.date(),
  expired_at: z.number().default(Math.floor(Date.now() / 1000) + (24 * 60 * 60)),
});

export type Data = z.infer<typeof dataSchema>;