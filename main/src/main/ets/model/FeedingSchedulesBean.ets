/*
            "id":1,
            "petId":1,
            "deviceId":1,
            "scheduleTime":"08:00:00",
            "foodAmount":150,
            "isActive":true,
            "createdAt":"2024-01-01T04:00:00.000+00:00",
            "updatedAt":"2025-11-02T08:30:08.000+00:00",
            "petName":"小白",
            "petBreed":"金毛寻回犬",
            "deviceName":"智能喂食器A1"
 */
export class FeedingSchedulesBean{
  constructor(id?:string, petId?:string, deviceId?:string, scheduleTime?:string, foodAmount?:string, isActive?:string,
    createdAt?:string, updatedAt?:string, petName?:string, petBreed?:string, deviceName?:string) {
    this.id = id
    this.petId = petId
    this.deviceId = deviceId
    this.scheduleTime = scheduleTime
    this.foodAmount = foodAmount
    this.isActive = isActive
    this.createdAt = createdAt
    this.updatedAt = updatedAt
    this.petName = petName
    this.petBreed = petBreed
    this.deviceName = deviceName
  }
  id?:string
  petId?:string
  deviceId?:string
  scheduleTime?:string
  foodAmount?:string
  isActive?:string
  createdAt?:string
  updatedAt?:string
  petName?:string
  petBreed?:string
  deviceName?:string

}