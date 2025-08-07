import { weatherSchema } from "@/types/weather";
import type { Weather } from "@/types/weather";
  
type Props = { location : string };
export const getWeather = async ({ location }: Props): Promise<Weather> => {
  const rawData = {
    location,
    temperature: "22°C",
    condition: "Partly cloudy"
  };

  return weatherSchema.parse(rawData);
};