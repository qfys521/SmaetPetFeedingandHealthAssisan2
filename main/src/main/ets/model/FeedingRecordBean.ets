export class FeedingRecordBean {
  scheduledTime?: string
  actualTime?: string
  plannedAmount?: string
  actualAmount?: string
  feedStatus?: string
  feedNotes?: string
  petBreed?: string
  petName?: string
  deviceName?: string

  constructor(
    scheduledTime?: string,
    actualTime?: string,
    plannedAmount?: string,
    actualAmount?: string,
    feedStatus?: string,
    feedNotes?: string,
    petBreed?: string,
    petName?: string,
    deviceName?: string,
  ) {
    this.scheduledTime = scheduledTime
    this.actualTime = actualTime
    this.plannedAmount = plannedAmount
    this.actualAmount = actualAmount
    this.feedStatus = feedStatus
    this.feedNotes = feedNotes
    this.petBreed = petBreed
    this.petName = petName
    this.deviceName = deviceName

  }
}