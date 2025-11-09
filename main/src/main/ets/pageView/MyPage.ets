import { DataSave } from "../tools/DataSave"


@Component
export struct MyPage{
  config:DataSave = new DataSave(this.getUIContext().getHostContext()!, 'loginData')


  build(){
    Column(){
      Text('MyPage')
        .align(Alignment.Center)
      Button("退出登录")
        .align(Alignment.Center)
        .onClick(()=>{
          this.config.deleted('username')
          this.config.deleted('password')
          this.config.deleted('isSelect')
          this.config.deleted('isReadUserAgreement')
          this.config.deleted('isReadPrivacyPolicy')

          // this.getUIContext().getHostContext()?.getApplicationContext().killAllProcesses()
          this.getUIContext().getRouter().replaceUrl({
            url: 'pages/Index'
          })
          this.getUIContext().getPromptAction().showToast({
            message: "退出成功"
          })
        })
    }


  }
}