
export interface WL_Station {
  active: boolean;
  city: string;
  company_name: string;
  country: string;
  elevation: number;
  firmware_version: string;
  gateway_id: number;
  gateway_id_hex: string;
  gateway_type: string;
  latitude: number;
  longitude: number;
  private: boolean;
  product_number: string;
  recording_interval: number;
  region: string;
  registered_date: number; // Unix timestamp
  relationship_type: string;
  station_id: number;
  station_id_uuid: string;
  station_name: string;
  subscription_type: string;
  time_zone: string;
  user_email: string;
  username: string;
}

export interface WL_Stations {
  generated_at: number; // Unix timestamp
  stations: WL_Station[];
}

