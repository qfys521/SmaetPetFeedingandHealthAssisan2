import { ResponseBean } from '../model/ResponseBean'
import { UserBean } from '../model/UserBean'
import { DataSave } from '../tools/DataSave'
import { HttpUtil } from '../tools/HttpUtil'
import { JSON } from '@kit.ArkTS'
import { PostUserDataDialog } from '../dialog/PostUserDataDialog'
import { PostUserData } from '../model/PostUserData'
import { LoginSaveBean } from '../model/LoginSaveBean'

@Entry
@Component
struct Index {
  // ===== 状态与配置 =====
  @State username: string = ""
  @State password: string = ""
  @State isSelect: boolean = false
  @State isReadUserAgreement: boolean = false
  @State isReadPrivacyPolicy: boolean = false
  @State showRegisterDialog: boolean = false

  private registerDialogController: CustomDialogController = new CustomDialogController({
    builder: PostUserDataDialog({
      cancel: () => {
        this.showRegisterDialog = false
      },
      confirm: (data: PostUserData) => {

        this.showRegisterDialog = false

        this.registerUser(data)
        // 清空输入框
        this.username = ""
        this.password = ""

        // 清除保存的登录数据
        this.config.set<LoginSaveBean>('loginSave', {
          username: "",
          password: "",
          isSelect: false,
          isReadUserAgreement: false,
          isReadPrivacyPolicy: false
        })

        this.promptAction.showToast({ message: "注册成功，请使用新账号登录" })
      }
    }),
    autoCancel: false
  })

  promptAction = this.getUIContext().getPromptAction()
  router = this.getUIContext().getRouter()
  config: DataSave = new DataSave(this.getUIContext().getHostContext()!, 'loginData')

  // ===== 生命周期 =====
  aboutToAppear() {
    const saveData = this.config.get<LoginSaveBean>('loginSave')
    if (saveData) {
      this.username = saveData.username
      this.password = saveData.password
      this.isSelect = saveData.isSelect
      this.isReadUserAgreement = saveData.isReadUserAgreement
      this.isReadPrivacyPolicy = saveData.isReadPrivacyPolicy

      if (this.username && this.password && this.isSelect && this.isReadUserAgreement && this.isReadPrivacyPolicy) {
        this.login()
      }
    }
  }

  login() {
    console.info("开始执行 login 方法")
    console.info(`当前输入 - username: "${this.username}", password: "${this.password}", isSelect: ${this.isSelect}, isReadUserAgreement: ${this.isReadUserAgreement}, isReadPrivacyPolicy: ${this.isReadPrivacyPolicy}`)

    if (this.username === "" || this.password === "") {
      console.warn("用户名或密码为空")
      this.promptAction.showToast({ message: "用户名或密码不能为空" })
      return
    }

    // 本地测试登录
    if (this.username === 'admin' && this.password === 'password') {
      console.info("本地测试登录成功")
      this.router.replaceUrl({ url: 'pages/MainPage' })
      return
    }

    try {
      console.info("发送网络请求登录...")
      let result = new HttpUtil().httpRequestPost<ResponseBean<UserBean>>(
        "https://place.wxtcc.com.cn/officelease/pets/petsUserLogin",
        "",
        [
          { key: "userName", value: this.username },
          { key: "psd", value: this.password },
        ]
      )

      result.then((value: ResponseBean<UserBean>) => {
        console.info("登录接口返回数据:", JSON.stringify(value))

        if (Number(value.code) !== 1) {
          console.error(`登录失败 - code: ${value.code}, message: ${value.message}`)
          this.promptAction.showToast({
            message: `登录失败 (${value.code}): ${value.message}`
          })
          return
        }

        console.info("登录成功，准备跳转到主页面")
        this.promptAction.showToast({ message: "登录成功" })
        this.router.replaceUrl({ url: 'pages/MainPage' })

        let saveData: LoginSaveBean = {
          username: this.isSelect ? this.username : "",
          password: this.isSelect ? this.password : "",
          isSelect: this.isSelect,
          isReadUserAgreement: this.isReadUserAgreement,
          isReadPrivacyPolicy: this.isReadPrivacyPolicy,
          userEmail: value.data?.email ?? "",
          userPhone: value.data?.phoneNumber ?? "",
          homeAddress: value.data?.homeAddress ?? "",
          key: value.data?.key ?? "",
          userId: value.data?.id ?? ""
        }

        console.info("保存登录数据到本地:", JSON.stringify(saveData))
        this.config.set<LoginSaveBean>('loginSave', saveData)

        // 清空输入框
        this.username = ""
        this.password = ""
        console.info("已清空输入框")
      }).catch((err: string) => {
        console.error("登录请求异常:", JSON.stringify(err))
        this.promptAction.showToast({ message: "网络请求失败，请稍后重试" })
      })
    } catch (error) {
      console.error("登录方法捕获异常:", error)
    }
  }

  registerUser(data: PostUserData) {
    console.info("开始执行 registerUser 方法", JSON.stringify(data))

    let result = new HttpUtil().httpRequestPost<ResponseBean<string>>(
      "https://place.wxtcc.com.cn/officelease/pets/setUserinfo",
      "",
      [
        { key: "email", value: data.email },
        { key: "phoneNumber", value: data.phoneNumber },
        { key: "homeAddress", value: data.homeAddress },
        { key: "password", value: data.password },
        { key: "type", value: '0' },
        { key: "userName", value: data.userName }
      ]
    )

    result.then((response: ResponseBean<string>) => {
      console.info("注册接口返回:", JSON.stringify(response))
      if (Number(response.code) === 1) {
        this.promptAction.showToast({ message: '注册成功' })
        console.info("注册成功")
      } else {
        this.promptAction.showToast({ message: `注册失败 (${response.code}): ${response.message}` })
        console.error(`注册失败 - code: ${response.code}, message: ${response.message}`)
      }
    }).catch((err: string) => {
      console.error("注册请求异常:", err)
      this.promptAction.showToast({ message: '注册失败，err:' + err })
    })
  }


  // ===== UI 构建 =====
  build() {
    Column() {
      Column() {
        Column({ space: 30 }) {
          Row() {
            SymbolGlyph($r('sys.symbol.person')).fontSize(24).fontColor([Color.White])
            TextInput({ text: this.username, placeholder: "请输入用户名:" })
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .height(40)
              .borderWidth({ bottom: 1 })
              .borderColor(Color.White)
              .backgroundColor("#99d3d3d3")
              .padding({ bottom: 5 })
              .onChange((value: string) => this.username = value)
          }

          Row() {
            SymbolGlyph($r('sys.symbol.lock')).fontSize(24).fontColor([Color.White])
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
              .onChange((value: string) => this.password = value)
          }
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
            if (!this.isSelect || !this.isReadUserAgreement || !this.isReadPrivacyPolicy) {
              AlertDialog.show({
                title: '提示',
                message: '请阅读并同意“用户协议”和“隐私政策”后再勾选复选框',
                autoCancel: true
              })
              return
            }
            this.login()
          })

        Row() {
          Checkbox()
            .width(20)
            .height(20)
            .select(this.isSelect)
            .onChange((value: boolean) => this.isSelect = value)

          Text('已阅读并同意 ').fontColor(Color.White)
          Text('用户协议')
            .fontColor(Color.Blue)
            .onClick(() => {
              AlertDialog.show({
                title: '用户协议',
                message: $r("app.string.UserAgreement"),
                autoCancel: true,
                primaryButton: { enabled: true, value: "同意", action: () => this.isReadUserAgreement = true },
                secondaryButton: { enabled: true, value: "拒绝", action: () => this.isReadUserAgreement = false }
              })
            })

          Text(' 与 ').fontColor(Color.White)

          Text('隐私政策')
            .fontColor(Color.Blue)
            .onClick(() => {
              AlertDialog.show({
                title: '隐私政策',
                message: $r("app.string.PrivacyPolicy"),
                autoCancel: true,
                primaryButton: { enabled: true, value: "同意", action: () => this.isReadPrivacyPolicy = true },
                secondaryButton: { enabled: true, value: "拒绝", action: () => this.isReadPrivacyPolicy = false }
              })
            })
        }
        .width('100%')
        .margin({ top: 15 })

        Row() {
          Text("还没有账号？").fontColor(Color.White).fontSize(16)
          Text("点击注册")
            .fontColor("#ff10a6f6")
            .fontWeight(FontWeight.Bold)
            .fontSize(16)
            .onClick(() => {
              this.showRegisterDialog = true
              this.registerDialogController.open()
            })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20 })
      }
      .backgroundImage($r('app.media.bg1'))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .height('100%')
    }
  }


}
