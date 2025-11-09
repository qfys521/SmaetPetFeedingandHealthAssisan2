export class ResponseBean<T> {
  code?: string
  message?: string
  data?: T
  timestamp?: string
  executeTime?: string

  constructor(code?: string, message?: string, data?: T, timestamp?: string, executeTime?: string) {
    this.code = code
    this.message = message
    this.data = data
    this.timestamp = timestamp
    this.executeTime = executeTime
  }
}