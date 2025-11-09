import { PetBean } from '../model/PetBean'
import { PetHealthHistory } from '../model/PetHealthHistoryBean'
import { HttpUtil } from '../tools/HttpUtil'
import { ResponseBean } from '../model/ResponseBean'
import { DataListBean } from '../model/DataListBean'
import { JSON } from '@kit.ArkTS'
import { prompt } from '@kit.ArkUI'

@Component
export struct ProfilePage {
  @State pet: PetBean = new PetBean()
  @State healthList: PetHealthHistory[] = []
  @State isLoading: boolean = false
  @State showEditDialog: boolean = false

  dialogController: CustomDialogController = new CustomDialogController({
    builder: EditPetInfoDialog({
      cancel: () => {
        this.showEditDialog = false
      },
      confirm: (data: PetData) => {
        this.postSavePetData(data)
      },
    }),
  });

  promptAction = this.getUIContext().getPromptAction()

  aboutToAppear(): void {
    this.getPetInfo()
    this.getPetHealthRecords()
  }

  build() {
    Row(){

      Stack({ alignContent: Alignment.TopStart }) {
        // 背景图
        Image($r("app.media.bg2"))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .objectRepeat(ImageRepeat.NoRepeat)


        // 主体内容
        Column(){
          Column() {
            Text('宠物档案')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.getTitleColor())
              .margin({ top: 20 })
            Text('宠物管理与基础信息')
              .fontColor(this.getSubTextColor())
              .fontSize(14)
          }
          .padding({ bottom:"16px" })
          if (this.pet.petName){
            Column() {
              Text('基础资料')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 10, left: 10 })

              // 改为Grid网格布局
              Grid() {
                GridItem() { this.buildInfoRow('名字', this.pet.petName) }
                GridItem() { this.buildInfoRow('出生日期', this.pet.birthDate) }
                GridItem() { this.buildInfoRow('种类', this.pet.petSpecies) }
                GridItem() { this.buildInfoRow('体重(kg)', this.pet.currentWeight?.toString()) }
                GridItem() { this.buildInfoRow('性别', this.pet.petGender) }
                GridItem() { this.buildInfoRow('健康状态', this.pet.healthStatus) }
              }
              .columnsTemplate('2fr 2fr') // 设置2列布局
              .rowsGap(12)                // 行间距
              .columnsGap(20)             // 列间距
              .padding(10)
              .onClick(() =>{
                this.showEditDialog = true
                if (this.showEditDialog) {
                  this.dialogController.open()
                }
              })

            }
            .width('90%')
            .height('20%')
            .backgroundColor($r('sys.color.interactive_select'))
            .borderRadius(10)
            .margin(10)
          }
          Scroll() {
            Column() {
              // 医疗与疫苗信息
              Column() {
                Text('医疗记录与疫苗信息')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 10, left: 10 })

                // 列表显示宠物健康记录
                ForEach(this.healthList, (record: PetHealthHistory) => {
                  Column() {
                    Text(`记录日期：${record.recordDate ?? '--'}`)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(this.getTextColor())
                    this.buildInfoRow('体重(kg)', record.bodyWeight)
                    this.buildInfoRow('体温(℃)', record.bodyTemperature)
                    this.buildInfoRow('心率', record.heartRate)
                    this.buildInfoRow('食欲', record.appetiteLevel)
                    this.buildInfoRow('精力', record.energyLevel)
                    this.buildInfoRow('疫苗接种', record.vaccinationStatus)
                    this.buildInfoRow('上次接种日期', record.lastVaccinationDate)
                    this.buildInfoRow('驱虫状态', record.dewormingStatus)
                    this.buildInfoRow('上次驱虫日期', record.lastDewormingDate)
                    this.buildInfoRow('兽医备注', record.vetNotes)
                  }
                  .width('95%')
                  .backgroundColor('#99ffffff')
                  .borderRadius(8)
                  .padding(10)
                  .margin({ bottom: 10 })
                })
              }
              .width('90%')
              .backgroundColor($r('sys.color.interactive_select'))
              .borderRadius(10)
              .margin(10)

              // 行为特征与偏好
              Column() {
                Text('行为特征与偏好')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 10, left: 10 })
                Text('🐾 喜欢安静、怕陌生人，对鸡肉过敏。')
                  .fontColor(this.getTextColor())
                  .fontSize(14)
                  .margin({ left: 15, top: 5, bottom: 10 })
              }
              .width('90%')
              .backgroundColor($r('sys.color.interactive_select'))
              .borderRadius(10)
              .margin(10)
            }
          }
          .width('100%')
          .height('80%')
          // .padding({ top: '10%' })
        }
      }
      .width('100%')
      .height('100%')
    }

  }

  // ==================
  // 封装UI辅助函数
  // ==================
@Builder
  buildInfoRow(label: string, value?: string): void {
    Row() {
      Text(`${label}：`)
        .fontColor(this.getTextColor())
        .fontWeight(FontWeight.Medium)
        .fontSize(14)
      Text(value ?? '--')
        .fontColor(this.getValueColor())
        .fontWeight(FontWeight.Bold)
        .fontSize(14)
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
  }

  // ==================
  // 网络请求部分
  // ==================

  getPetInfo() {
    this.isLoading = true
    let result = new HttpUtil().httpRequestGet<ResponseBean<PetBean[]>>(
      "https://place.wxtcc.com.cn/officelease/pets/getPets",
      [
        { key: "key", value: "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "userId", value: "1" }
      ]
    )
    result.then((value: ResponseBean<PetBean[]>) => {
      if (value?.data?.length) {
        this.pet = value.data[0]
        console.info(`[PetInfo] ${JSON.stringify(this.pet)}`)

      }
      console.info(`[PetInfo] ${JSON.stringify(value)}`)
    }).finally(() => {
      this.isLoading = false
    })
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

  getPetHealthRecords() {
    this.isLoading = true
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
      const list = value?.data?.list ?? []
      this.healthList = list
      console.info(`[HealthRecord] ${JSON.stringify(value)}`)
    }).finally(() => {
      this.isLoading = false
    })
  }
  postSavePetData(petData: PetData) {
    let result = new HttpUtil().httpRequestPost<ResponseBean<string>>(
      "https://place.wxtcc.com.cn/officelease/pets/updatePets",
      "" ,
      [
        { key: "key", value:  "803fb55ae18f4ebebe0370cac63492ff" },
        { key: "petName", value: petData.petName || "" },
        { key: "petSpecies", value: petData.petSpecies || "" },
        { key: "petBreed", value: petData.petBreed || "" },
        { key: "petGender", value: petData.petGender || "" },
        { key: "birthDate", value: petData.birthDate || "" },
        { key: "currentweight", value: petData.currentWeight?.toString() || "" },
        { key: "healthstatus", value: petData.healthStatus || "" },
        { key: "id", value: "1" },
        { key: "userId", value: "1" }
      ]
    )
    result.then((value: ResponseBean<string>) => {
      this.promptAction.showToast({ message: "🐾 宠物信息已保存成功！" })
      setTimeout(() => {
        this.getPetInfo()
      }, 1500)
    })
  }


  // ==================
  // 样式封装
  // ==================
  private getTextColor(): ResourceColor {
    return '#444444'
  }

  private getTitleColor(): ResourceColor {
    return '#1a1a1a'
  }

  private getSubTextColor(): ResourceColor {
    return '#777777'
  }

  private getValueColor(): ResourceColor {
    return '#0066CC'
  }
}

export class PetData {
  constructor(
    petName?: string,
    birthDate?: string,
    petSpecies?: string,
    petBreed?: string,
    currentWeight?: string,
    petGender?: string,
    healthStatus?: string,

  ) {
    this.petName = petName
    this.birthDate = birthDate
    this.petSpecies = petSpecies
    this.petBreed = petBreed
    this.currentWeight = currentWeight
    this.petGender = petGender
    this.healthStatus = healthStatus

  }

  petName?: string = ''
  birthDate?: string = ''
  petSpecies?: string = ''
  petBreed?: string = ''
  currentWeight?: string = ''
  petGender?: string = ''
  healthStatus?: string = ''

}

@CustomDialog
struct EditPetInfoDialog {
  @State petName: string = ''
  @State birthDate: string = ''
  @State petSpecies: string = ''
  @State petBreed: string = ''
  @State currentWeight: string = ''
  @State petGender: string = ''
  @State healthStatus: string = ''

  cancel: () => void = () => {}
  confirm: (data: PetData) => void = (data: PetData) => {}
  controller: CustomDialogController

  build() {
    Column({ space: 18 }) {
      Text('✏️ 编辑宠物基础信息')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10 })

      this.inputField('🐶 名字', '请输入宠物名字', (v) => this.petName = v)
      this.inputField('🎂 出生日期', '例如 2023-05-10', (v) => this.birthDate = v)
      this.inputField('🐕 种类', '例如 金毛 / 猫咪', (v) => this.petSpecies = v)
      this.inputField('🐾 品种', '例如 比熊 / 英短 / 田园猫', (v) => this.petBreed = v)
      this.inputField('⚖️ 体重(kg)', '请输入数字', (v) => this.currentWeight = v, InputType.Number)
      this.inputField('🚻 性别', '雄性 / 雌性', (v) => this.petGender = v)
      this.inputField('❤️ 健康状态', '良好 / 需要关注', (v) => this.healthStatus = v)

      Row({ space: 20 }) {
        Button('取消')
          .width('40%')
          .height(44)
          .backgroundColor('#ccc')
          .fontColor('#000')
          .borderRadius(10)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })

        Button('保存')
          .width('40%')
          .height(44)
          .backgroundColor('#007DFF')
          .fontColor('#fff')
          .borderRadius(10)
          .onClick(() => {
            if (!this.petName) {
              prompt.showToast({ message: '请输入宠物名字' })
              return
            }
            const data = new PetData()
            data.petName = this.petName
            data.birthDate = this.birthDate
            data.petSpecies = this.petSpecies
            data.petBreed = this.petBreed
            data.currentWeight = this.currentWeight
            data.petGender = this.petGender
            data.healthStatus = this.healthStatus

            this.controller.close()
            this.confirm(data)
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#fff')
    .borderRadius(12)
  }

  @Builder
  inputField(label: string, placeholder: string, onChange: (v: string) => void, type: InputType = InputType.Normal) {
    Column() {
      Text(label).fontSize(16)
      TextInput({ placeholder: placeholder })
        .width('90%')
        .height(40)
        .type(type)
        .backgroundColor('#f5f5f5')
        .borderRadius(6)
        .onChange(onChange)
    }
  }
}
