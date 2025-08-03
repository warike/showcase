export type WL_CurrentData ={
    station_id: number;
    station_id_uuid: string;
    sensors: Array<WL_Sensor>;
    generated_at: number;
}

export type WL_Sensor = {
    lsid: number;
    sensor_type: number;
    data_structure_type: number;
    data: Array<WL_SensorData>;
}

export type WL_SensorData = {
    ts: number;
    tz_offset: number;
    temp_out: number;
    temp_in: number;
    hum_out: number;
    hum_in: number;
    wind_speed: number;
    wind_speed_10_min_avg: number;
    wind_dir: number;
    wind_gust_10_min: number;
    bar: number;
    bar_trend: number;
    rain_rate_in: number;
    rain_day_in: number;
    rain_month_in: number;
    rain_year_in: number;
    dew_point: number;
    heat_index: number;
    wind_chill: number;
    uv: number | null;
    solar_rad: number;
    forecast_desc: string;
    forecast_rule: number;
    et_day: number;
    et_month: number;
    et_year: number;
}
    