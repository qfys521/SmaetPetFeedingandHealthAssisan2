export class MonitoringBean{
  constructor(userId?: string, monitoringTime?: string, temperature?: string, humidity?: string, pm25?: string, co2?: string,
    tvoc?: string, noiseLevel?: string, lightIntensity?: string, airQuality?: string) {
    this.userId = userId;
    this.monitoringTime = monitoringTime;
    this.temperature = temperature;
    this.humidity = humidity;
    this.pm25 = pm25;
    this.co2 = co2;
    this.tvoc = tvoc;
    this.noiseLevel = noiseLevel;
    this.lightIntensity = lightIntensity;
    this.airQuality = airQuality;
  }
    userId?: string;
    monitoringTime?: string;
    temperature?: string;
    humidity?: string;
    pm25?: string;
    co2?: string;
    tvoc?: string;
    noiseLevel?: string;
    lightIntensity?:string
    airQuality?: string;


}