import { LoginSaveBean } from '../model/LoginSaveBean'
import { DataSave } from '../tools/DataSave'

@Component
@CustomDialog
export struct PostUserDataModifyDialog {
  // ===== 对外传入的回调 =====
  cancel: () => void = () => {
  }
  confirm: (data: LoginSaveBean) => void = (data: LoginSaveBean) => {
  }
  controller: CustomDialogController
  // ===== 临时输入数据 =====
  @State tempEmail: string = ""
  @State tempPhone: string = ""
  @State tempAddress: string = ""
  @State tempPassword: string = ""
  config: DataSave = new DataSave(this.getUIContext().getHostContext()!, 'loginData')
  loginData = this.config.get<LoginSaveBean>("loginSave")

  // ===== UI 构建 =====
  build() {
    Scroll() {
      Column({ space: 15 }) {
        Text("修改用户信息").fontSize(22).fontWeight(FontWeight.Bold)

        TextInput({ text: this.loginData.username, placeholder: "用户名" })
          .enabled(false)


        TextInput({ text: this.loginData.userEmail, placeholder: "邮箱" })
          .onChange(value => this.tempEmail = value)

        TextInput({ text: this.loginData.userPhone, placeholder: "手机号" })
          .onChange(value => this.tempPhone = value)

        TextInput({ text: this.loginData.homeAddress, placeholder: "家庭地址" })
          .onChange(value => this.tempAddress = value)

        TextInput({ text: this.loginData.password, placeholder: "新密码" })
          .type(InputType.Password)
          .onChange(value => this.tempPassword = value)

        Row({ space: 10 }) {
          Button("取消")
            .backgroundColor("#ccc")
            .onClick(() => this.cancel())

          Button("保存")
            .backgroundColor("#007bff")
            .fontColor(Color.White)
            .onClick(() => {

              let data: LoginSaveBean = {
                username: this.loginData.username,
                userEmail: this.tempEmail,
                userPhone: this.tempPhone,
                homeAddress: this.tempAddress,
                password: this.tempPassword,
                isSelect: true,
                isReadUserAgreement: true,
                isReadPrivacyPolicy: true,
                key: this.loginData.key ?? ""
              }
              this.confirm(data)
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 10 })
      }
      .padding(20)
      .width('90%')
      .backgroundColor(Color.White)
      .borderRadius(10)
    }
  }
}
