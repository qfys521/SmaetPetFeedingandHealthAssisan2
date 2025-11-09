import router from '@ohos.router';
import { DataSave } from '../tools/DataSave';

@Component
export struct MyPage {
  @State username: string = ''
  @State phone: string = ''
  @State email: string = ''
  @State showEditDialog: boolean = false
  @State tempUsername: string = ''
  @State tempPhone: string = ''
  @State tempEmail: string = ''

  promptAction = this.getUIContext().getPromptAction()
  config: DataSave = new DataSave(this.getUIContext().getHostContext()!, 'loginData')

  aboutToAppear(): void {
    this.loadUserInfo()
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景图
      Image($r("app.media.bg2"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .objectRepeat(ImageRepeat.NoRepeat)

      Text('个人中心')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.getTitleColor())
        .margin({ top: 20, left: 20, bottom: 20 })
        .alignSelf(ItemAlign.Start)

      Column({ space: 20 }) {
        // 用户信息卡片 - 可点击整个卡片
        Column() {
          // 卡片标题和编辑按钮
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Text('个人信息')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getTitleColor())

            Button('编辑')
              .fontSize(14)
              .backgroundColor(Color.Transparent)
              .fontColor('#0066CC')
              .borderColor('#0066CC')
              .borderWidth(1)
              .borderRadius(15)
              .padding({ left: 15, right: 15, top: 5, bottom: 5 })
              .onClick(() => {
                this.showEditDialog = true
                this.tempUsername = this.username
                this.tempPhone = this.phone
                this.tempEmail = this.email
              })
          }
          .width('90%')
          .margin({ top: 20, bottom: 10 })

          // 用户信息内容
          Row() {
            // 头像
            Image($r('app.media.touxiang1'))
              .width(120)
              .height(120)
              .borderRadius(60)
              .margin({ right: 25 })

            Column({ space: 15 }) {
              // 用户名
              Column({ space: 5 }) {
                Text('用户名')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(this.username || '未设置')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')

              // 手机号
              Column({ space: 5 }) {
                Text('手机号')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(this.phone || '未设置')
                  .fontSize(16)
                  .fontColor(this.getValueColor())
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')

              // 邮箱
              Column({ space: 5 }) {
                Text('邮箱')
                  .fontSize(14)
                  .fontColor('#666666')
                Text(this.email || '未设置')
                  .fontSize(16)
                  .fontColor(this.getValueColor())
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('90%')
          .padding(15)
          .margin({ bottom: 20 })
        }
        .width('95%')
        .backgroundColor($r('sys.color.interactive_select'))
        .borderRadius(20)
        .shadow({ radius: 12, color: '#1a000000', offsetX: 0, offsetY: 6 })
        .onClick(() => {
          // 点击整个卡片也可以触发编辑
          this.showEditDialog = true
          this.tempUsername = this.username
          this.tempPhone = this.phone
          this.tempEmail = this.email
        })

        // 退出登录按钮
        Button('退出登录')
          .width('95%')
          .height(55)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#ff4757')
          .fontColor(Color.White)
          .borderRadius(27)
          .margin({ top: 30 })
          .onClick(() => {
            this.logout()
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ top: '15%' })

      // 编辑信息弹窗
      if (this.showEditDialog) {
        Column() {
          // 半透明背景
          Blank()
            .width('100%')
            .height('100%')
            .backgroundColor('#000000')
            .opacity(0.5)
            .onClick(() => {
              this.showEditDialog = false
            })

          // 编辑卡片
          Column({ space: 20 }) {
            Text('编辑个人信息')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getTitleColor())
              .margin({ top: 20 })

            Column({ space: 15 }) {
              // 用户名输入
              Column({ space: 5 }) {
                Text('用户名')
                  .fontSize(14)
                  .fontColor('#666666')
                  .alignSelf(ItemAlign.Start)
                TextInput({ text: this.tempUsername, placeholder: '请输入用户名' })
                  .fontSize(16)
                  .width('100%')
                  .backgroundColor('#f8f8f8')
                  .borderRadius(10)
                  .padding(12)
                  .onChange((value: string) => {
                    this.tempUsername = value
                  })
              }

              // 手机号输入
              Column({ space: 5 }) {
                Text('手机号')
                  .fontSize(14)
                  .fontColor('#666666')
                  .alignSelf(ItemAlign.Start)
                TextInput({ text: this.tempPhone, placeholder: '请输入手机号' })
                  .fontSize(16)
                  .width('100%')
                  .backgroundColor('#f8f8f8')
                  .borderRadius(10)
                  .padding(12)
                  .onChange((value: string) => {
                    this.tempPhone = value
                  })
              }

              // 邮箱输入
              Column({ space: 5 }) {
                Text('邮箱')
                  .fontSize(14)
                  .fontColor('#666666')
                  .alignSelf(ItemAlign.Start)
                TextInput({ text: this.tempEmail, placeholder: '请输入邮箱' })
                  .fontSize(16)
                  .width('100%')
                  .backgroundColor('#f8f8f8')
                  .borderRadius(10)
                  .padding(12)
                  .onChange((value: string) => {
                    this.tempEmail = value
                  })
              }
            }
            .width('100%')

            // 按钮区域
            Row({ space: 15 }) {
              Button('取消')
                .layoutWeight(1)
                .height(45)
                .fontSize(16)
                .backgroundColor('#f0f0f0')
                .fontColor('#333333')
                .borderRadius(22)
                .onClick(() => {
                  this.showEditDialog = false
                })

              Button('保存')
                .layoutWeight(1)
                .height(45)
                .fontSize(16)
                .backgroundColor('#0066CC')
                .fontColor(Color.White)
                .borderRadius(22)
                .onClick(() => {
                  this.saveUserInfo()
                  this.showEditDialog = false
                })
            }
            .width('100%')
            .margin({ bottom: 20 })
          }
          .width('85%')
          .padding({ left: 20, right: 20 })
          .backgroundColor(Color.White)
          .borderRadius(25)
          .shadow({ radius: 20, color: '#33000000', offsetX: 0, offsetY: 10 })
          .position({ x: '7.5%', y: '25%' })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })
      }
    }
    .width('100%')
    .height('100%')
  }

  // 加载用户信息
  loadUserInfo(): void {
    this.username = this.config.get<string>('username') || '未设置'
    this.phone = this.config.get<string>('user-phone') || '未设置'
    this.email = this.config.get<string>('user-email') || '未设置'
  }

  // 保存用户信息
  saveUserInfo(): void {
    if (this.tempUsername.trim() === '') {
      this.promptAction.showToast({ message: '用户名不能为空' })
      return
    }

    // 调用修改用户信息接口
    this.doPostModifyUserInfo({
      username: this.tempUsername,
      phone: this.tempPhone,
      email: this.tempEmail
    })

    this.username = this.tempUsername
    this.phone = this.tempPhone
    this.email = this.tempEmail

    // 保存到本地存储
    this.config.set('username', this.tempUsername)
    this.config.set('user-phone', this.tempPhone)
    this.config.set('user-email', this.tempEmail)

    this.promptAction.showToast({ message: '个人信息更新成功' })
  }

  // 退出登录
  logout(): void {
    this.promptAction.showDialog({
      title: '确认退出',
      message: '确定要退出登录吗？',
      buttons: [
        {
          text: '取消',
          color: '#0066CC'
        },
        {
          text: '确定',
          color: '#0066CC'
        }
      ]
    }).then(result => {
      if (result.index === 1) {
        this.config.clearAll()
        router.clear()
        router.replaceUrl({ url: 'pages/Index' })
      }
    })
  }

  // 修改用户信息接口
  private doPostModifyUserInfo(userInfo: UserModifyInfo): void {
    // 这里实现具体的修改用户信息请求
    // 示例：
    // let result = new HttpUtil().httpRequestPost<ResponseBean<string>>(
    //   "https://your-api.com/modifyUserInfo",
    //   JSON.stringify(userInfo),
    //   [
    //     { key: "key", value: "your-api-key" },
    //     { key: "userId", value: "1" }
    //   ]
    // )
    // result.then((response: ResponseBean<string>) => {
    //   if (response.code === 200) {
    //     this.promptAction.showToast({ message: '修改成功' })
    //   } else {
    //     this.promptAction.showToast({ message: '修改失败：' + response.message })
    //   }
    // })
  }

  private getTextColor(): ResourceColor {
    return '#333333'
  }

  private getTitleColor(): ResourceColor {
    return '#1a1a1a'
  }

  private getValueColor(): ResourceColor {
    return '#0066CC'
  }
}

// 用户修改信息接口
interface UserModifyInfo {
  username: string
  phone: string
  email: string
}