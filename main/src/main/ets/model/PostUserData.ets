// model/PostUserData.ets
export class PostUserData {
  userName: string
  email: string
  phoneNumber: string
  homeAddress: string
  password: string

  constructor(
    userName: string,
    email: string,
    phoneNumber: string,
    homeAddress: string,
    password: string
  ) {
    this.userName = userName
    this.email = email
    this.phoneNumber = phoneNumber
    this.homeAddress = homeAddress
    this.password = password
  }
}
