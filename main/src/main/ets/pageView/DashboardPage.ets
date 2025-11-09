import { DataListBean } from '../model/DataListBean'
import { MonitoringBean } from '../model/MonitoringBean'
import { ResponseBean } from '../model/ResponseBean'
import { HttpUtil } from '../tools/HttpUtil'
import { PetBean } from '../model/PetBean'
import { FeedingRecordBean } from '../model/FeedingRecordBean'
import { JSON } from '@kit.ArkTS'


@Component
export struct DashboardPage {
  @State env: MonitoringBean = new MonitoringBean()
  @State pet: PetBean = new PetBean()
  @State feed: FeedingRecordBean[] = []
  @State isRefreshing: boolean = false
  promptAction = this.getUIContext().getPromptAction()

  aboutToAppear(): void {
      this.getEnvData()
      this.getUserPet()
      this.getPetData()
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r("app.media.bg2"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .objectRepeat(ImageRepeat.NoRepeat)
      Text('首页')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.getTitleColor())
        .margin({ top: 20, left: 20, bottom: 20 })
        .alignSelf(ItemAlign.Start)
      Refresh({
        refreshing: $$this.isRefreshing, // 双向绑定刷新状态
        offset: 80 // 触发刷新的下拉距离（单位vp）
      }) {
        Column() {
          /*
          ├─ 首页 Dashboard
          │   ├─ 环境与设备监测（温度、设备状态）
          │   ├─ 今日喂食与健康摘要（进食、体重、活动）
          │   ├─ 快捷操作区（远程投喂 / 刷新）
           */

          Column() {
            Text('环境与设备监测')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 10, left: 10 })
            Row() {
              //光照
              Column({ space: 3 }) {
                Image($r('app.media.guangzhao'))
                  .width(50)
                Text('光照')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
                Text(this.env.lightIntensity ? this.env.lightIntensity : '--')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getValueColor())
              }

              //温度
              Column({ space: 3 }) {
                Image($r('app.media.wendu'))
                  .width(50)
                Text('温度')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
                Text(this.env.temperature ? this.env.temperature : '--')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getValueColor())
              }

              //湿度
              Column({ space: 3 }) {
                Image($r('app.media.shidu'))
                  .width(50)
                Text('湿度')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
                Text(this.env.humidity ? this.env.humidity : '--')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getValueColor())
              }

              //烟雾浓度
              Column({ space: 3 }) {
                Image($r('app.media.yanwu'))
                  .width(50)
                Text('空气质量')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
                Text(this.env.airQuality ? this.env.airQuality : '--')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getValueColor())
              }
            }
            .width('90%')
            .justifyContent(FlexAlign.SpaceBetween)
            .height(100)
            .margin({ top: 20, bottom: 20 })

          }
          .width('100%')
          .backgroundColor($r('sys.color.interactive_select'))
          .borderRadius(10)
          .margin(10)

          Column() {
            Text('今日喂食与健康摘要')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 10, left: 10 })
            // 今日喂食与健康摘要组件
            Row() {
              Column({ space: 3 }) {
                Image($r('app.media.goupen'))
                  .width(50)
                Text('喂食次数')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
                Text((this.feed.length??'--').toString())
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getValueColor())
              }
              .margin({ left: 50, right: 50 })

              //烟雾浓度
              Column({ space: 3 }) {
                Image($r('app.media.health'))
                  .width(50)
                Text('健康状态')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
                Text(this.pet.healthStatus??'--')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getValueColor())
              }
              .margin({ left: 50, right: 50 })
            }
            .width('90%')
            .justifyContent(FlexAlign.Center)
            .height(100)
            .margin({ top: 20, bottom: 20 })

          }
          .width('100%')
          .backgroundColor($r('sys.color.interactive_select'))
          .borderRadius(10)
          .margin(10)

          Column() {
            Text('快捷操作区')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 10, left: 10 })
            Row() {
              Column({ space: 3 }) {
                Image($r('app.media.kaiguan'))
                  .width(50)
                  .onClick(() => {
                    this.isRefreshing = true
                    
                      this.putFeeding()
                    this.promptAction.showToast({
                      message: "\n已成功向服务器发送喂食请求,\n数据同步可能会有5分钟延迟\n"
                    })
                    setTimeout(() => {
                      this.aboutToAppear()
                    }, 3000)
                  })

                Text('一键开饭')
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.getTextColor())
              }

            }
            .width('90%')
            .justifyContent(FlexAlign.Center)
            .height(100)
            .margin({ top: 20, bottom: 20 })
          }
          .width('100%')
          .backgroundColor($r('sys.color.interactive_select'))
          .borderRadius(10)
          .margin(10)
        }
      }
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 2000)
      })
      .width('100%')
      .height('100%')
      .padding({ top: '20%' })
    }
    .width('100%')
    .height('100%')

  }

  formatTime(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');

    // 按照你指定的格式：yyyy-HH-dd hh:mm
    return `${year}-${month}-${day} ${hour}:${minute}`;
  }

  getTimeByOffset(s: number): string {
    const now = new Date();
    now.setSeconds(now.getSeconds() + s);
    return this.formatTime(now);
  }

  // 获取当前时间
  getNowTime(): string {
    const now = new Date();
    return this.formatTime(now);
  }


  getEnvData() {
    let result = new HttpUtil().httpRequestGet<ResponseBean<DataListBean<MonitoringBean>>>(
      "https://place.wxtcc.com.cn/officelease/pets/getMonitoring",
      [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "userId", value: "1" },
        { key: "page", value: "1" },
        { key: "size", value: "15" },
        { key: "startTime", value: this.getTimeByOffset(-1 * 60 * 60) },
        { key: "endTime", value: this.getNowTime() }
      ]
    )

    result.then((value: ResponseBean<DataListBean<MonitoringBean>>) => {
      this.env = value!.data!.list![0]
      console.info(`[EnvData] ${JSON.stringify(value)}`)
    })
  }


  getUserPet() {
    let result = new HttpUtil().httpRequestGet<ResponseBean<PetBean[]>>(
      "https://place.wxtcc.com.cn/officelease/pets/getPets",
      [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "userId", value: "1" }
      ]
    )
    result.then((value: ResponseBean<PetBean[]>) => {
      this.pet = value.data![0]
      console.info(`[UserPet] ${JSON.stringify(value)}`)

    })
  }

  getPetData() {

    let result = new HttpUtil().httpRequestGet<ResponseBean<DataListBean<FeedingRecordBean>>>(
      "https://place.wxtcc.com.cn/officelease/pets/getFeedingRecord",
     [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "petId", value: "1" },
        { key: "startTime", value: this.getTimeByOffset(-1 * 60 * 60 * 24) },
        { key: "endTime", value: this.getNowTime() },
        { key: "page", value: "1" },
        { key: "size", value: "50" }
      ]
    )
    result.then((value: ResponseBean<DataListBean<FeedingRecordBean>>) => {
      console.info(JSON.stringify(
        [
          { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
          { key: "petId", value: "1" },
          { key: "startTime", value: this.getTimeByOffset(-1 * 60 * 60 * 24) },
          { key: "endTime", value: this.getNowTime() },
          { key: "page", value: "1" },
          { key: "size", value: "50" }
        ]
      ))
      console.info(`[PetData] ${JSON.stringify(value)}`)
      if (value.data!.list!.length === 0) {
        const d = new FeedingRecordBean()
        this.feed = [d ]
      }else {
        this.feed = value.data!.list!
      }

    })
  }

  putFeeding() {
    let result = new HttpUtil().httpRequestPost<ResponseBean<string>>(
      "https://place.wxtcc.com.cn/officelease/pets/putFeeding",
      "",
      [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "petId", value: "1" },
        { key: "plannedAmount", value: "150" },
        { key: "deviceId", value: "1" }
      ]

    )

    result.then((_: ResponseBean<string>) => {
        this.getPetData()
    })
  }

  private getTextColor(): ResourceColor {
    return '#333333' // 深灰色，在大多数背景下都清晰可见
  }

  private getTitleColor(): ResourceColor {
    return '#1a1a1a' // 更深的黑色，用于标题
  }

  private getValueColor(): ResourceColor {
    return '#0066CC' // 蓝色，用于数值显示
  }
}

