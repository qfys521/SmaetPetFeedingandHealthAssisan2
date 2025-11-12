export interface LoginSaveBean {
  username: string
  password: string
  isSelect: boolean
  isReadUserAgreement: boolean
  isReadPrivacyPolicy: boolean
  userEmail?: string
  userPhone?: string
  homeAddress?: string
  key?:string
  userId?:string
}
