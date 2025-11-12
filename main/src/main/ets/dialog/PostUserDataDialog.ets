import { PostUserData } from '../model/PostUserData'
import { prompt } from '@kit.ArkUI'

@CustomDialog
export struct PostUserDataDialog {
  @State userName: string = ''
  @State email: string = ''
  @State phoneNumber: string = ''
  @State homeAddress: string = ''
  @State password: string = ''
  cancel: () => void = () => {
  }
  confirm: (data: PostUserData) => void = (data: PostUserData) => {
  }
  controller: CustomDialogController

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Text('👤 用户注册')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        // 用户名
        Column() {
          Text('用户名：').fontSize(16)
          TextInput({ placeholder: '请输入用户名' })
            .width('90%')
            .height(40)
            .backgroundColor('#f2f2f2')
            .borderRadius(8)
            .onChange((v) => this.userName = v)
        }

        // 邮箱
        Column() {
          Text('📧 邮箱地址：').fontSize(16)
          TextInput({ placeholder: '请输入邮箱地址' })
            .width('90%')
            .height(40)
            .type(InputType.Email)
            .backgroundColor('#f2f2f2')
            .borderRadius(8)
            .onChange((v) => this.email = v)
        }

        // 电话
        Column() {
          Text('电话号码：').fontSize(16)
          TextInput({ placeholder: '请输入电话号码' })
            .width('90%')
            .height(40)
            .type(InputType.Number)
            .backgroundColor('#f2f2f2')
            .borderRadius(8)
            .onChange((v) => this.phoneNumber = v)
        }

        // 地址
        Column() {
          Text('家庭地址：').fontSize(16)
          TextArea({ placeholder: '请输入家庭地址' })
            .width('90%')
            .height(100)
            .backgroundColor('#f2f2f2')
            .borderRadius(8)
            .onChange((v) => this.homeAddress = v)
        }

        // 密码
        Column() {
          Text('密码：').fontSize(16)
          TextInput({ placeholder: '请输入密码' })
            .width('90%')
            .height(40)
            .type(InputType.Password)
            .backgroundColor('#f2f2f2')
            .borderRadius(8)
            .onChange((v) => this.password = v)
        }

        // 按钮行
        Row({ space: 20 }) {
          Button('取消')
            .width('40%')
            .height(45)
            .backgroundColor('#ccc')
            .fontColor('#000')
            .borderRadius(10)
            .onClick(() => {
              this.controller.close()
              if (this.cancel) {
                this.cancel()
              }
              this.userName = ''
              this.email = ''
              this.phoneNumber = ''
              this.homeAddress = ''
              this.password = ''
              prompt.showToast({ message: '已取消注册' })
            })

          Button('注册')
            .width('40%')
            .height(45)
            .backgroundColor('#007bff')
            .fontColor('#fff')
            .borderRadius(10)
            .onClick(() => {
              if (!this.userName || !this.email || !this.password) {
                prompt.showToast({ message: '请填写必填项：用户名、邮箱、密码' })
                return
              }

              const data = new PostUserData(
                this.userName,
                this.email,
                this.phoneNumber,
                this.homeAddress,
                this.password
              )
              prompt.showToast({ message: `注册成功：${this.userName}` })
              this.controller.close()
              if (this.confirm) {
                this.confirm(data)
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: 30 })
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}
