export class UserBean {
  id?: string
  userName?: string
  email?: string
  phoneNumber?: string
  homeAddress?: string
  key?: string

  constructor(init?: Partial<UserBean>) {
    if (init) {
      this.id = init.id
      this.userName = init.userName
      this.email = init.email
      this.phoneNumber = init.phoneNumber
      this.homeAddress = init.homeAddress
      this.key = init.key
    }
  }
}
