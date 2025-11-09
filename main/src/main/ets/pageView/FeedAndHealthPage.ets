import { FeedingSchedulesBean } from "../model/FeedingSchedulesBean"
import { ResponseBean } from "../model/ResponseBean"
import { HttpUtil } from "../tools/HttpUtil"
import { JSON } from "@kit.ArkTS"
import { DataListBean } from "../model/DataListBean"
import { PetHealthHistory } from "../model/PetHealthHistoryBean"
import { McBarChart, McPieChart, Options } from '@mcui/mccharts'
import { prompt, promptAction } from "@kit.ArkUI"
import { image } from "@kit.ImageKit"
import { fileIo } from "@kit.CoreFileKit"
import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { systemShare } from "@kit.ShareKit"

@Component
export struct FeedAndHealthPage {
  @State currentTab: string = 'feed'
  @State feedSchedule: FeedingSchedulesBean[] = []
  @State healthHistory: PetHealthHistory[] = []
  @State lineOption: Options = new Options({
    title: {
      show: true,
      text: '基础属性',
      left: 40,
      top: 15

    },
    xAxis: {
      name: '日期',
      data: [],
      nameTextStyle: {
        fontWeight: FontWeight.Bolder,
        fontSize: "30"
      }
    },
    yAxis: [
      {
        name: '体温 (℃)',
        axisLabel: {
          fontWeight: FontWeight.Bolder,
          fontSize: "30"
        }
      },
      {
        name: "体重 (kg)",
        axisLabel: {
          fontWeight: FontWeight.Bolder,
          fontSize: "30"
        }
      }
    ],
    series: [
      {
        name: '体温',
        type: 'line',
        smooth: false,
        data: [],
      }, {
      name: '体重',
      type: 'line',
      smooth: false,
      data: [],
      axisLabel: {
        fontWeight: FontWeight.Bolder,
        fontSize: "30"
      },
      yAxisIndex: 1
    }
    ]
  })
  @State pieOption: Options = new Options({
    title: {
      show: true,
      text: '健康状态',
      left: 40,
      top: 15
    },
    series: [
      {
        data: []
      }
    ]
  })
  @State showDialog: boolean = false
  @State scheduleTime: string = '20:00:00'
  @State foodAmount: number = 150
  @State isActive: boolean = true
  @State schedulesInfo: string = '这里是信息'
  @State pixmap: image.PixelMap | undefined = undefined
  @State isShowButton:boolean = true
  dialogController: CustomDialogController = new CustomDialogController({
    builder: PostDataDialog({
      cancel: () => {
        
        this.showDialog = false
        
      },
      confirm: (data: PostPetFeedData) => {
        this.postPetFeedSchedule(data)
      },
    }),
  });

  aboutToAppear(): void {
    this.getFeedSchedule()
    this.getPetHealth()

    
    setTimeout(() => {
      this.updateLineChart()
      this.updatePieChart()
    }, 1000)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      
      Image($r("app.media.bg2"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .objectRepeat(ImageRepeat.NoRepeat)

      
      Column() {
        
        Column() {
          Row() {
            Text('喂养 & 健康总览')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222')
          }

          Text('近期数据统计')
            .fontColor('#666')
            .fontSize(14)
        }
        .width('100%')
        .padding({
          top: 24,
          left: 20,
          right: 20,
          bottom: 12
        })

        
        Tabs({ barPosition: BarPosition.Start }) {
          TabContent() {
            if (!this.feedSchedule || this.feedSchedule.length === 0) {
              Column() {
                Text('暂无喂食计划')
                  .fontSize(16)
                  .fontColor('#888')
                  .margin({ top: 40 })
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)

            } else {
              Scroll() {
                List() {
                  ForEach(this.feedSchedule, (item: FeedingSchedulesBean) => {
                    ListItem() {
                      Column() {
                        Row() {
                          Text(item.deviceName)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                        }

                        Row() {
                          Column() {
                            Text(`时间：${item.scheduleTime}`)
                            Text(`喂食量：${item.foodAmount} g`)
                          }
                          .layoutWeight(1)

                          Column() {
                            Circle()
                              .width(12)
                              .height(12)
                              .fill(item.isActive ? '#00BFA5' : '#CCCCCC')
                            Text(item.isActive ? '启用中' : '已停用')
                              .fontSize(12)
                              .fontColor(item.isActive ? '#00BFA5' : '#999')
                          }
                        }
                        .padding({ top: 8 })
                      }
                      .padding(16)
                      .margin({ top: 6, bottom: 6 })
                      .backgroundColor('rgba(255,255,255,0.3)')
                      .borderRadius(12)
                      .shadow({
                        radius: 3,
                        color: '#0000001A',
                        offsetX: 1,
                        offsetY: 1
                      })
                    }
                  })
                }
                .padding({
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 30
                })
                .height("100%")
                .width('100%')
              }
              .width('100%')
              .height('100%')
            }
          }.tabBar('喂养管理')

          TabContent() {
            Column() {
              Row() {
                Scroll() {
                  Column() {
                    Row() {
                      Column({ space: 3 }) {
                        McBarChart({
                          options: this.lineOption
                        })
                          .height("100%")
                          .width("100%")
                      }
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.Center)
                    .height(150)
                    .margin({ top: 20, bottom: 30, left: -10 })

                    Row() {
                      Column({ space: 3 }) {
                        McPieChart({
                          options: this.pieOption
                        })
                          .height("100%")
                          .width("100%")
                      }
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.Center)
                    .height(150)
                    .margin({ top: 20, bottom: 30, left: -10 })

                  }
                  .width('100%')
                  .backgroundColor($r('sys.color.interactive_select'))
                  .borderRadius(10)
                  .margin(10)
                }

              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding(16)

              Row(){
                SaveButton({ text: SaveDescription.DOWNLOAD_AND_SHARE })
                  .onClick(() => {
                    this.isShowButton = false
                    let permissions: Array<Permissions> = [
                      'ohos.permission.WRITE_MEDIA',
                      'ohos.permission.READ_MEDIA',
                      'ohos.permission.CUSTOM_SCREEN_CAPTURE',
                      'ohos.permission.MEDIA_LOCATION'
                    ];

                    
                    reqPermissionsFromUser(permissions, this.getUIContext().getHostContext() as common.UIAbilityContext);

                    
                    setTimeout(() =>{
                      this.getUIContext().getComponentSnapshot().get(
                        "root",
                        async (error: Error, pixmap: image.PixelMap) => {
                          if (error) {
                            
                            return;
                          }

                          
                          const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
                          await savePixmapToGallery(context, pixmap);
                        },
                        { waitUntilRenderFinished: true }
                      );
                    } , 500)
                    setTimeout(() =>{
                      this.isShowButton = true
                    } , 3000)
                  })
                  .backgroundColor('#00BFA5')
                  .fontColor('#FFF')
                  .borderRadius(20)
              }
              .visibility(this.isShowButton ? Visibility.Visible : Visibility.None);


            }
            .width('100%')
            .height('100%')
          }.tabBar('健康分析')
        }
        .barWidth('100%')
        .barHeight(48)
        .barBackgroundColor('rgba(255,255,255,0.9)')
        .onChange((index: number) => {
          this.currentTab = index === 0 ? 'feed' : 'health'
        })
        .width('100%')
        .height('100%')
      }

      if (this.currentTab === 'feed') {
        Button('+')
          .width(52)
          .height(52)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#00BFA5')
          .fontColor('#fff')
          .borderRadius(26)
          .shadow({
            radius: 6,
            color: '#00000022',
            offsetX: 0,
            offsetY: 3
          })
          .position({ x: '85%', y: '88%' })
          .onClick(() => {
            this.showDialog = true
            if (this.showDialog) {
              this.dialogController.open()
            }

          })
      }


    }
    .width('100%')
    .height('100%')
    .id("root")
  }

  formatTime(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');

    
    return `${year}-${month}-${day} ${hour}:${minute}`;
  }

  getTimeByOffset(s: number): string {
    const now = new Date();
    now.setSeconds(now.getSeconds() + s);
    return this.formatTime(now);
  }

  updateLineChart() {
    const dates =
      this.healthHistory.map(item => `${item.recordDate?.split("-")[1]}-${item.recordDate?.split("-")[2]}` ?? '')
    const temperatures = this.healthHistory.map(item => Number(item.bodyTemperature ?? 0))
    const weights = this.healthHistory.map(item => Number(item.bodyWeight ?? 0))

    /*
    体重 (bodyWeight)
    体温 (bodyTemperature)

     */
    this.lineOption.setVal({
      xAxis: {
        data: dates, axisLabel: {
          fontSize: 35
        }
      },
      series: [
        {
          name: '体温',
          type: 'line',
          smooth: false,
          data: temperatures,
          nameTextStyle: {
            fontWeight: FontWeight.Bolder,
            fontSize: "30"
          }
        },
        {
          name: "体重",
          type: 'line',
          smooth: false,
          data: weights,
          yAxisIndex: 1,
          axisLabel: {
            fontWeight: FontWeight.Bolder,
            fontSize: "30"
          }
        }
      ]
    })
  }

  updatePieChart() {
    /*
    食欲水平 (appetiteLevel)：Excellent / Normal / Poor
    精力水平 (energyLevel)：High / Normal / Low
    疫苗状态 (vaccinationStatus)：Up-to-date / Overdue
    驱虫状态 (dewormingStatus)：Completed / Pending
     */
    const appetiteLevel = this.healthHistory.map(item => item.appetiteLevel).length ?? 0
    const energyLevel = this.healthHistory.map(item => item.energyLevel).length ?? 0
    const vaccinationStatus = this.healthHistory.map(item => item.vaccinationStatus).length ?? 0
    const dewormingStatus = this.healthHistory.map(item => item.dewormingStatus).length ?? 0

    this.pieOption.setVal({
      series: [
        {
          data: [
            { value: appetiteLevel, name: "食欲水平" },
            { value: energyLevel, name: "精力水平" },
            { value: vaccinationStatus, name: "疫苗状态" },
            { value: dewormingStatus, name: "驱虫状态" }
          ]
        }
      ]
    })
  }

  
  getNowTime(): string {
    const now = new Date();
    return this.formatTime(now);
  }

  getFeedSchedule() {
    let result = new HttpUtil().httpRequestGet<ResponseBean<FeedingSchedulesBean[]>>(
      "https://place.wxtcc.com.cn/officelease/pets/feedingSchedules",
      [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "petId", value: "1" }
      ]
    )

    result.then((value: ResponseBean<FeedingSchedulesBean[]>) => {
      
      
      this.feedSchedule = value.data!
    })
  }

  getPetHealth() {
    let result = new HttpUtil().httpRequestGet<ResponseBean<DataListBean<PetHealthHistory>>>(
      "https://place.wxtcc.com.cn/officelease/pets/getPetHealthHistory",
      [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "petId", value: "1" },
        { key: "startTime", value: this.getTimeByOffset(-1 * 60 * 60 * 24 * 7) },
        { key: "endTime", value: this.getNowTime() },
        { key: "page", value: "1" },
        { key: "size", value: "50" }
      ]
    )

    result.then((value: ResponseBean<DataListBean<PetHealthHistory>>) => {
      this.healthHistory = value.data!.list!
    })


  }

  postPetFeedSchedule(data: PostPetFeedData) {
    const result = new HttpUtil().httpRequestPost<ResponseBean<string>>(
      "https://place.wxtcc.com.cn/officelease/pets/addFeedingDevices",
      "",
      [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "petId", value: "1" },
        { key: "deviceId", value: "1" },
        { key: "scheduleTime", value: data.scheduleTime },
        { key: "foodAmount", value: data.foodAmount },
        { key: "isActive", value: String(data.isActive) },
        { key: "scheduleIndo", value: data.schedulesInfo }
      ]
    )

    result.then((value: ResponseBean<string>) => {
      this.getUIContext().getPromptAction().showToast({
        message: "数据成功提交，\n服务器可能会有3~5分钟延迟~"
      })
      
      setTimeout(() => {
        this.aboutToAppear()
      }, 2000)
    })
  }
}


export class PostPetFeedData {
  constructor(scheduleTime: string, foodAmount: string, isActive: boolean, schedulesInfo: string) {
    this.scheduleTime = scheduleTime
    this.foodAmount = foodAmount
    this.isActive = isActive
    this.schedulesInfo = schedulesInfo
  }

  scheduleTime: string = ''
  foodAmount: string = ''
  isActive: boolean = true
  schedulesInfo: string = ''
}

@CustomDialog
struct PostDataDialog {
  @State scheduleTime: string = ''
  @State foodAmount: string = ''
  @State isActive: boolean = true
  @State schedulesInfo: string = ''
  cancel: () => void = () => {
  }
  confirm: (data: PostPetFeedData) => void = (data: PostPetFeedData) => {
  }
  controller: CustomDialogController

  build() {
    Column({ space: 20 }) {
      Text('🐾 喂食计划设置')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })

      
      Column() {
        Text('🕐 喂食时间：').fontSize(16)
        TextInput({ placeholder: '例如 08:00:00' })
          .width('90%')
          .height(40)
          .backgroundColor('#f2f2f2')
          .borderRadius(8)
          .onChange((value) => {
            this.scheduleTime = value
          })
      }

      
      Column() {
        Text('🍚 喂食量（g）：').fontSize(16)
        TextInput({ placeholder: '请输入喂食量（克）' })
          .width('90%')
          .height(40)
          .type(InputType.Number)
          .backgroundColor('#f2f2f2')
          .borderRadius(8)
          .onChange((value) => {
            this.foodAmount = value
          })
      }

      
      Row({ space: 10 }) {
        Text('✅ 是否启用：').fontSize(16)
        Toggle({ type: ToggleType.Switch, isOn: this.isActive })
          .onChange((value) => {
            this.isActive = value
          })
      }
      .alignItems(VerticalAlign.Center)

      
      Column() {
        Text('📝 备注 / 补充信息：').fontSize(16)
        TextArea({ placeholder: '填写补充说明...' })
          .width('90%')
          .height(100)
          .backgroundColor('#f2f2f2')
          .borderRadius(8)
          .onChange((value) => {
            this.schedulesInfo = value
          })
      }

      
      Row({ space: 20 }) {
        
        Button('❌ 取消添加')
          .width('40%')
          .height(45)
          .backgroundColor('#CCCCCC')
          .fontColor('#000')
          .borderRadius(10)
          .onClick(() => {
            
            this.controller.close();
            if (this.cancel) {
              this.cancel();
            }
            this.scheduleTime = ''
            this.foodAmount = ''
            this.isActive = true
            this.schedulesInfo = ''
            prompt.showToast({ message: '已取消添加' })
          })

        
        Button('💾 保存计划')
          .width('40%')
          .height(45)
          .backgroundColor('#007DFF')
          .fontColor('#fff')
          .borderRadius(10)
          .onClick(() => {
            if (!this.scheduleTime || !this.foodAmount) {
              prompt.showToast({ message: '请填写喂食时间和喂食量' })
              return
            }
            prompt.showToast({
              message: `已保存：${this.scheduleTime} / ${this.foodAmount}g / ${this.isActive ? '启用' : '停用'}`
            })

            this.controller.close();
            if (this.confirm) {
              const data = new PostPetFeedData(
                this.scheduleTime,
                this.foodAmount,
                this.isActive,
                this.schedulesInfo
              )
              this.confirm(data);
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 30 })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#ffffff')
  }
}

function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  try {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          
        } else {
          
          return;
        }
      }
      
    }).catch((err: BusinessError) => {
      
    })
  } catch (e) {
    
  }
}

async function savePixmapToGallery(context: common.UIAbilityContext, pixmap: image.PixelMap): Promise<void> {
  const helper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

  try {
    
    const uri: string = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');

    
    const file: fileIo.File = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);

    
    const imagePacker: image.ImagePacker = image.createImagePacker();
    const packOpts: image.PackingOption = { format: 'image/jpeg', quality: 90 };
    const buffer: ArrayBuffer = await imagePacker.packing(pixmap, packOpts);

    
    await fileIo.write(file.fd, buffer);
    await fileIo.close(file.fd);

    promptAction.showToast({ message: '截图已保存到相册 🎉' });

    
    await shareImage(context, uri);

  } catch (error) {
    const err = error as BusinessError;
    
    promptAction.showToast({ message: '保存失败，请重试' });
  }
}
async function shareImage(context: common.UIAbilityContext, fileUriPath: string) {
  try {
    
    const utdType = 'general.image';

    
    const sharedData = new systemShare.SharedData({
      utd: utdType,
      uri: fileUriPath,
      title: '宠物健康分析截图',
      description: '这是从宠物喂养与健康分析页生成的截图'
    });

    
    const controller = new systemShare.ShareController(sharedData);
    await controller.show(context, {
      selectionMode: systemShare.SelectionMode.SINGLE,
      previewMode: systemShare.SharePreviewMode.DETAIL
    });

  } catch (err) {
    
  }
}