import router from '@ohos.router'
import { DataSave } from '../tools/DataSave'
import { HttpUtil } from '../tools/HttpUtil'
import { ResponseBean } from '../model/ResponseBean'
import { LoginSaveBean } from '../model/LoginSaveBean'
import { PostUserDataModifyDialog } from '../dialog/PostUserDataModifyDialog'

@Component
export struct MyPage {
  @State username: string = ''
  @State phone: string = ''
  @State email: string = ''
  @State homeAddress: string = ''
  @State password: string = ''
  @State userKey: string = ''
  @State showEditDialog: boolean = false
  private modifyDialogController: CustomDialogController = new CustomDialogController({
    builder: PostUserDataModifyDialog({
      cancel: () => {
        this.showEditDialog = false
        this.modifyDialogController.close()
      },
      confirm: (data: LoginSaveBean) => {

        this.showEditDialog = false

        this.saveUserInfo(data)
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
        this.modifyDialogController.close()
      }
    }),
    autoCancel: false
  })

  // 用于暂存编辑数据
  @State editingData: LoginSaveBean = {
    username: '',
    password: '',
    userEmail: '',
    userPhone: '',
    homeAddress: '',
    isSelect: true,
    isReadUserAgreement: true,
    isReadPrivacyPolicy: true
  }

  promptAction = this.getUIContext().getPromptAction()
  config: DataSave = new DataSave(this.getUIContext().getHostContext()!, 'loginData')

  aboutToAppear(): void {
    this.loadUserInfo()
  }

  // === 加载用户信息 ===
  loadUserInfo(): void {
    const saveData = this.config.get<LoginSaveBean>('loginSave')
    if (saveData) {
      this.username = saveData.username ?? '未设置'
      this.phone = saveData.userPhone ?? '未设置'
      this.email = saveData.userEmail ?? '未设置'
      this.homeAddress = saveData.homeAddress ?? '未设置'
      this.password = saveData.password ?? ''
    }
    this.userKey = this.config.get<LoginSaveBean>('loginSave').key ?? ""
  }

  // === 弹出编辑对话框 ===
  openEditDialog(): void {
    this.editingData = {
      username: this.username,
      userPhone: this.phone,
      userEmail: this.email,
      homeAddress: this.homeAddress,
      password: '',
      isSelect: true,
      isReadUserAgreement: true,
      isReadPrivacyPolicy: true
    }
    this.showEditDialog = true
    this.modifyDialogController.open()
  }

  // === 保存用户信息 ===
  saveUserInfo(data: LoginSaveBean): void {
    if (!this.userKey) {
      this.promptAction.showToast({ message: '用户未登录或缺少Key，请重新登录' })
      return
    }

    // 简单校验
    if (!data.username || !data.userPhone) {
      this.promptAction.showToast({ message: '用户名和手机号不能为空' })
      return
    }

    this.promptAction.showToast({ message: '正在提交，请稍候…' })

    new HttpUtil().httpRequestPost<ResponseBean<string>>(
      'https://place.wxtcc.com.cn/officelease/pets/setUserinfo',
      '',
      [
        { key: 'email', value: data.userEmail! },
        { key: 'phoneNumber', value: data.userPhone },
        { key: 'homeAddress', value: data.homeAddress! },
        { key: 'password', value: data.password },
        { key: 'type', value: '1' },
        { key: 'key', value: data.key! },
        { key: 'userName', value: data.username }
      ]
    )
      .then((res: ResponseBean<string>) => {
        if (Number(res.code) === 1) {
          this.promptAction.showToast({ message: '修改成功' })

          // 更新本地数据
          this.config.set('LoginSaveBean', data)

          // 更新显示
          this.username = data.username
          this.phone = data.userPhone!
          this.email = data.userEmail!
          this.homeAddress = data.homeAddress!
          this.password = data.password

          this.showEditDialog = false
        } else {
          this.promptAction.showToast({ message: `修改失败 (${res.code}): ${res.message}` })
        }
      })
      .catch(() => {
        this.promptAction.showToast({ message: '修改失败，请检查网络' })
      })
  }

  logout(): void {
    this.promptAction.showDialog({
      title: '确认退出',
      message: '确定要退出登录吗？',
      buttons: [
        { text: '取消', color: '#0066CC' },
        { text: '确定', color: '#0066CC' }
      ]
    }).then(result => {
      if (result.index === 1) {
        this.config.clearAll()
        router.clear()
        router.replaceUrl({ url: 'pages/Index' })
      }
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景与标题
      Image($r('app.media.bg2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
      Text('个人中心')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, left: 25 })

      Column({ space: 25 }) {
        Column() {
          // Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.End }) {
          //
          //   Button('编辑')
          //     .fontSize(14)
          //     .backgroundColor(Color.Transparent)
          //     .fontColor('#0066CC')
          //     .borderColor('#0066CC')
          //     .borderWidth(1)
          //     .borderRadius(15)
          //     .padding({ left: 15, right: 15, top: 5, bottom: 5 })
          //     .onClick(() =>
          //     {
          //      this.openEditDialog()
          //     })
          // }
          // .width('100%')

          Row() {
            Image($r('app.media.touxiang1'))
              .width(90)
              .height(90)
              .borderRadius(45)
              .margin({ right: 20 })
              .onClick(() =>{
                this.openEditDialog()
              })

            Column({ space: 8 }) {
              Text(`用户名：${this.username}`)
              Text(`手机号：${this.phone}`)
              Text(`邮箱：${this.email}`)
              Text(`地址：${this.homeAddress}`)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .padding(20)
        }
        .width('90%')
        .backgroundColor('#99ffffff')
        .borderRadius(20)
        .shadow({ radius: 12, color: '#1a000000', offsetY: 6 })
        .alignSelf(ItemAlign.Center)

        Button('退出登录')
          .width('90%')
          .height(50)
          .backgroundColor('#ff4757')
          .fontColor(Color.White)
          .borderRadius(25)
          .onClick(() => this.logout())
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ top: '15%' })
      .width('100%')


    }
  }
}
