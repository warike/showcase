import type { WL_CurrentData } from "@/types/current-data";
import type { WL_Stations } from "@/types/station";

export const WL_API_BASE = "https://api.weatherlink.com/v2";
export const USER_AGENT = "weather-app/1.0";

// Helper function for making Weather Link API requests
// source: https://weatherlink.github.io/v2-api/api-reference

export async function makeWLRequest<T>(url: string, api_secret: string, apiKey?: string): Promise<T | null> {
  const headers = {
     "x-api-secret": api_secret,
  };
  try {
    const urlWithApiKey = apiKey ? `${url}?api-key=${apiKey}` : url;
    const response = await fetch(urlWithApiKey, { headers });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return (await response.json()) as T;
  } catch (error) {
    console.error("Error making Weather Link request:", error);
    return null;
  }
}

export const formatCurrentWeatherData = (data: WL_CurrentData) => {
  const sensor = data.sensors?.[0];
  const sensorData = sensor?.data?.[0];

  if (!sensorData) {
    return "No current weather data available from this station.";
  }

  const timestamp = new Date(sensorData.ts * 1000).toLocaleString();

  const sections = [
    `**Current Weather Conditions**`,
    `Station ID: ${data.station_id}`,
    `Last Updated: ${timestamp}`,
    ``,
    `**Temperature:**`,
    `• Outdoor: ${sensorData.temp_out}°C`,
    `• Indoor: ${sensorData.temp_in}°C`,
    `• Dew Point: ${sensorData.dew_point}°C`,
    `• Heat Index: ${sensorData.heat_index}°C`,
    `• Wind Chill: ${sensorData.wind_chill}°C`,
    ``,
    `**Humidity:**`,
    `• Outdoor: ${sensorData.hum_out}%`,
    `• Indoor: ${sensorData.hum_in}%`,
    ``,
    `**Wind:**`,
    `• Current Speed: ${sensorData.wind_speed} mph`,
    `• 10-Min Average: ${sensorData.wind_speed_10_min_avg} mph`,
    `• Direction: ${sensorData.wind_dir}°`,
    `• 10-Min Gust: ${sensorData.wind_gust_10_min} mph`,
    ``,
    `**Precipitation:**`,
    `• Current Rate: ${sensorData.rain_rate_in} in/hr`,
    `• Today: ${sensorData.rain_day_in} in`,
    `• This Month: ${sensorData.rain_month_in} in`,
    `• This Year: ${sensorData.rain_year_in} in`,
  ];
  // Add evapotranspiration data
  sections.push(
    ``,
    `**Evapotranspiration:**`,
    `• Today: ${sensorData.et_day} in`,
    `• This Month: ${sensorData.et_month} in`,
    `• This Year: ${sensorData.et_year} in`
  );
   // Add forecast if available
   if (sensorData.forecast_desc) {
    sections.push(``, `**Forecast:**`, sensorData.forecast_desc);
  }

  return sections.join("\n");
}

export const formatStationsData = (data: WL_Stations) => {
  if (!data.stations || data.stations.length === 0) {
    return "No station data available.";
  }

  const generatedAt = new Date(data.generated_at * 1000).toLocaleString();
  const sections = [
    `**Weather Stations**`,
    `Last Updated: ${generatedAt}`,
    `Total Stations: ${data.stations.length}`,
    ``,
  ];

  data.stations.forEach((station, index) => {
    sections.push(
      `**Station ${index + 1}: ${station.station_name}**`,
      `• ID: ${station.station_id}`,
      `• Location: ${station.city}, ${station.region}, ${station.country}`,
      `• Coordinates: ${station.latitude.toFixed(4)}°N, ${station.longitude.toFixed(4)}°E`,
      `• Elevation: ${station.elevation} meters`,
      `• Status: ${station.active ? 'Active' : 'Inactive'}`,
      `• Type: ${station.gateway_type}`,
      `• Recording Interval: ${station.recording_interval} minutes`,
      `• Time Zone: ${station.time_zone}`,
      `• Private: ${station.private ? 'Yes' : 'No'}`,
      `• Registered: ${new Date(station.registered_date * 1000).toLocaleDateString()}`,
      ``
    );
  });

  return sections.join("\n");
}