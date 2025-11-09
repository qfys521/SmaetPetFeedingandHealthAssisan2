import { DataSave } from '../tools/DataSave'

@Entry
@Component
struct Index {

  aboutToAppear() {
    this.username = this.config.get<string>('username')
    this.password = this.config.get<string>('password')
    this.isSelect = this.config.get<boolean>('isSelect')
    this.isReadUserAgreement = this.config.get<boolean>('isReadUserAgreement')
    this.isReadPrivacyPolicy = this.config.get<boolean>('isReadPrivacyPolicy')

    if (this.username && this.password && this.isSelect && this.isReadUserAgreement && this.isReadPrivacyPolicy) {
      this.login()

    }
  }
  promptAction = this.getUIContext().getPromptAction()
  router = this.getUIContext().getRouter()

  @State username: string = ""
  @State password: string = ""
  @State isSelect: boolean = false
  @State isReadUserAgreement: boolean = false
  @State isReadPrivacyPolicy: boolean = false
  config:DataSave = new DataSave(this.getUIContext().getHostContext()! , 'loginData')



  login() {
   try {
     if (this.username != "" && this.password != "") {
       this.promptAction.showToast({ message: "登陆成功" })
       this.router.replaceUrl({
         url: 'pages/MainPage'
       }).catch((error:string) => {
          console.error(error)
       })
       this.config.set<string>('username' , this.username)
       this.config.set<string>('password' , this.password)
       this.config.set<boolean>('isSelect' , this.isSelect)
       this.config.set<boolean>('isReadUserAgreement' , this.isReadUserAgreement)
       this.config.set<boolean>('isReadPrivacyPolicy' , this.isReadPrivacyPolicy)
     } else {
       this.promptAction.showToast({ message: "用户名或密码不能为空" })
     }
   }catch (error){
     console.error(error)
   }
  }

  build() {
    Column() {
      Column() {

        Column({ space: 30 }) {
          Row() {
            SymbolGlyph($r('sys.symbol.person'))
              .fontSize(24)
              .fontColor([Color.White])

            TextInput({ text: this.username, placeholder: "请输入用户名:" })
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(40)
              .borderWidth({ bottom: 1 })
              .borderColor(Color.White)
              .backgroundColor("#99d3d3d3")
              .padding({ bottom: 5 })
              .onChange((value: string) => {
                this.username = value;
              }
              )
          }
          .width('100%')
          .height(40)
          .borderWidth({ bottom: 1 })
          .borderColor(Color.White)
          .padding({ bottom: 5 })

          Row() {
            SymbolGlyph($r('sys.symbol.lock'))
              .fontSize(24)
              .fontColor([Color.White])

            TextInput({ text: this.password, placeholder: "请输入密码:" })
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Bold)
              .type(InputType.Password)
              .backgroundColor("#99d3d3d3")
              .showPasswordIcon(false)
              .width('100%')
              .height(40)
              .borderWidth({ bottom: 1 })
              .borderColor(Color.White)
              .padding({ bottom: 5 })
              .onChange((value: string) => {
                this.password = value;
              })
          }
          .width('100%')
          .height(40)
          .borderWidth({ bottom: 1 })
          .borderColor(Color.White)
          .padding({ bottom: 5 })
        }
        .margin({ top: 500, bottom: 40 })

        Button("登录")
          .type(ButtonType.Normal)
          .width('100%')
          .borderRadius(8)
          .backgroundColor(Color.White)
          .fontColor("#ff10a6f6")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            if ((!this.isSelect) || (!this.isReadUserAgreement) || (!this.isReadPrivacyPolicy)) {
              AlertDialog.show({
                title: '提示',
                message: '请阅读并同意"我已阅读 用户协议 与 隐私政策"后勾选按钮',
                autoCancel: true
              })
              return
            }
            this.login()
          })

        Row() {
          Row() {
            Checkbox()
              .width(20)
              .height(20)
              .select(this.isSelect)
              .onChange((value: boolean) => {
                this.isSelect = value
              })
            //已阅读并同意 用户协议 与 隐私策略
            Text('已阅读并同意 ')
              .fontColor(Color.White)
            Text('用户协议')
              .fontColor(Color.Blue)
              .onClick(() => {
                AlertDialog.show({
                  title: '用户协议',
                  message: $r("app.string.UserAgreement" ),
                  autoCancel: true,
                  primaryButton:{
                    enabled:true,
                    value: "同意",
                    action: () => {
                      this.isReadUserAgreement = true
                    }
                  },
                  secondaryButton:{
                    enabled:true,
                    value: "拒绝",
                    action: () => {
                      this.isReadUserAgreement = false
                    }
                  }
                })
              })
            Text(' 与 ')
              .fontColor(Color.White)
            Text('隐私政策')
              .fontColor(Color.Blue)
              .onClick(() => {
                AlertDialog.show({
                  title: '隐私政策',
                  message: $r("app.string.PrivacyPolicy" ),
                  autoCancel: true,
                  primaryButton:{
                    enabled:true,
                    value: "同意",
                    action: () => {
                      this.isReadPrivacyPolicy = true
                    }
                  },
                  secondaryButton:{
                    enabled:true,
                    value: "拒绝",
                    action: () => {
                      this.isReadPrivacyPolicy = false
                    }
                }
                })
              })
          }
        }
        .width('100%')
        .margin({ top: 15 })
      }
      .backgroundImage($r('app.media.bg1'))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .height('100%')
    }
  }
}

