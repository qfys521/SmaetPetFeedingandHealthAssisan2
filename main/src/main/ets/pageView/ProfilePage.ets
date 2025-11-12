import { PetBean } from '../model/PetBean'
import { PetHealthHistory } from '../model/PetHealthHistoryBean'
import { HttpUtil } from '../tools/HttpUtil'
import { ResponseBean } from '../model/ResponseBean'
import { DataListBean } from '../model/DataListBean'
import { JSON } from '@kit.ArkTS'
import { prompt } from '@kit.ArkUI'
import { DataSave } from '../tools/DataSave'
import { LoginSaveBean } from '../model/LoginSaveBean'

// 定义类型接口
interface DateRangeOption {
  value: string;
  label: string;
}

interface SpecificDateOption {
  value: string;
  label: string;
}

// 新增：定义Select选项接口
interface SelectOptionItem {
  value: string;
  content: string;
}

@Component
export struct ProfilePage {
  @State pet: PetBean = new PetBean()
  @State healthList: PetHealthHistory[] = []
  @State isLoading: boolean = false
  @State showEditDialog: boolean = false

  // 日期筛选相关状态
  @State selectedDateRange: string = '7' // 默认最近7天
  @State selectedSpecificDate: string = '' // 选中的具体日期

  // 修复：使用明确的类型声明
  @State dateRangeOptions: DateRangeOption[] = [
    { value: '1', label: '最近1天' },
    { value: '3', label: '最近3天' },
    { value: '7', label: '最近7天' },
    { value: '30', label: '最近30天' },
    { value: '90', label: '最近90天' },
  ]

  @State specificDateOptions: SpecificDateOption[] = [] // 具体日期选项
  config: DataSave = new DataSave(this.getUIContext().getHostContext()!, 'loginData')
  userKey:string = this.config.get<LoginSaveBean>("loginSave").key??""

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
    Row() {
      Stack({ alignContent: Alignment.TopStart }) {
        // 背景图
        Image($r("app.media.bg2"))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .objectRepeat(ImageRepeat.NoRepeat)

        // 主体内容
        Column() {
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
          .padding({ bottom: "16px" })

          // 重新设计的紧凑基础资料卡片
          if (this.pet.petName) {
            this.buildPetProfileCard()
          }

          // 日期筛选器 - 放在基础资料下面
          this.buildDateFilter()

          Scroll() {
            Column({ space: 12 }) {
              // 医疗与疫苗信息
              Column() {
                Text('医疗记录与疫苗信息')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 10, left: 10 , bottom: 10})



                // 列表显示宠物健康记录 - 根据选中的具体日期过滤
                if (this.getFilteredHealthRecords().length === 0) {
                  this.buildNoRecords()
                } else {
                  ForEach(this.getFilteredHealthRecords(), (record: PetHealthHistory) => {
                    this.buildHealthRecordCard(record)
                  }, (record: PetHealthHistory, index: number) => `${record.recordDate}-${index}`)
                }
              }
              .width('90%')
              .backgroundColor($r('sys.color.interactive_select'))
              .borderRadius(10)
              .margin({ top: 5, bottom: 5 })

              // 行为特征与偏好
              Column() {
                Text('行为特征与偏好')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 10, left: 10 })
                  .fontColor(Color.White)
                Text('🐾 喜欢安静、怕陌生人，对鸡肉过敏。')
                  .fontColor(this.getTextColor())
                  .fontSize(14)
                  .fontColor(Color.White)
                  .margin({ left: 15, top: 5, bottom: 10 })
              }
              .width('90%')
              .backgroundColor($r('sys.color.interactive_select'))
              .borderRadius(10)
              .margin({ top: 5, bottom: 5 })
            }
          }
          .width('100%')
          .layoutWeight(1) // 添加权重确保Scroll可以滚动
        }
      }
      .width('100%')
      .height('100%')
    }
  }

  // 基础资料卡片 - 紧凑版本
  @Builder
  buildPetProfileCard(): void {
    Column({ space: 8 }) {
      // 标题和编辑按钮
      Row() {
        Text('🐾 基础资料')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')

        Button('编辑')
          .width("20%")
          .height(24)
          .fontSize(11)
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.showEditDialog = true
            if (this.showEditDialog) {
              this.dialogController.open()
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 12, right: 12 })

      // 紧凑的宠物信息布局
      Grid() {
        // 第一行
        GridItem() { this.buildCompactProfileItem('名字', this.pet.petName, '📝') }
        GridItem() { this.buildCompactProfileItem('种类', this.pet.petSpecies, '🐕') }
        GridItem() { this.buildCompactProfileItem('性别', this.pet.petGender, '🚻') }

        // 第二行
        GridItem() { this.buildCompactProfileItem('出生', this.pet.birthDate, '🎂') }
        GridItem() { this.buildCompactProfileItem('体重', this.pet.currentWeight!.toString() ? `${this.pet.currentWeight!.toString()}kg` : '--', '⚖️') }
        GridItem() { this.buildCompactProfileItem('健康', this.pet.healthStatus, '❤️') }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .rowsGap(8)
      .columnsGap(8)
      .padding({ left: 12, right: 12, bottom: 12 })
    }
    .width('90%')
    .height('15%')
    .borderRadius(12)
    .shadow({ radius: 6, color: '#1a000000', offsetX: 0, offsetY: 1 })
    .margin({ top: 5, bottom: 20 })
  }

  // 紧凑的基础资料项组件
  @Builder
  buildCompactProfileItem(label: string, value: string | undefined, icon: string): void {
    Column({ space: 2 }) {
      Row({ space: 4 }) {
        Text(icon)
          .fontSize(10)
        Text(label)
          .fontSize(18)
          .fontColor('#666666')
          .fontWeight(FontWeight.Medium)
          .fontSize(18)

      }
      .justifyContent(FlexAlign.Start)
      .width('100%')

      Text(value || '--')
        .fontSize(12)
        .fontColor('#1a1a1a')
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(14)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding(4)
  }

  // 日期筛选器组件 - 修改为垂直布局，字体调小
  @Builder
  buildDateFilter(): void {
    Column({ space: 8 }) {
      // 时间范围选择 - 占一整行
      Row() {
        Text('时间范围:')
          .fontSize(12)
          .fontColor(this.getTextColor())
          .margin({ right: 8 })

        Select(this.dateRangeOptions.map((option: DateRangeOption): SelectOptionItem => {
          return {
            value: option.value,
            content: option.label
          }
        }))
          .selected(this.getSelectedIndex(this.dateRangeOptions, this.selectedDateRange))
          .onSelect((index: number) => {
            this.selectedDateRange = this.dateRangeOptions[index].value
            this.selectedSpecificDate = '' // 清空具体日期选择
            this.getPetHealthRecords()
          })
          .fontColor(this.getTextColor())
          .borderRadius(6)
          .padding(6)
          .width('70%')
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .width('90%')
      .height(32)

      // 具体日期选择（仅在时间范围选择后显示）- 占一整行
      if (this.specificDateOptions.length > 0) {
        Row() {
          Text('具体日期:')
            .fontSize(12)
            .fontColor(this.getTextColor())
            .margin({ right: 8 })

          Select(this.specificDateOptions.map((option: SpecificDateOption): SelectOptionItem => {
            return {
              value: option.value,
              content: option.label
            }
          }))
            .selected(this.getSelectedIndex(this.specificDateOptions, this.selectedSpecificDate))
            .onSelect((index: number) => {
              this.selectedSpecificDate = this.specificDateOptions[index].value
            })
            .fontColor(this.getTextColor())
            .borderRadius(6)
            .padding(6)
            .width('70%')
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .width('90%')
        .height(32)
      }
    }
    .width('90%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 10, right: 10, top: 5})
    .backgroundColor($r('sys.color.interactive_select'))
    .borderRadius(10)
    .margin(10)
  }

  // 辅助方法：获取选中项的索引
  private getSelectedIndex(options: DateRangeOption[] | SpecificDateOption[], selectedValue: string): number {
    const index = options.findIndex((option: DateRangeOption | SpecificDateOption) => option.value === selectedValue);
    return index >= 0 ? index : 0;
  }

  // 构建健康记录卡片
  @Builder
  buildHealthRecordCard(record: PetHealthHistory): void {
    Column({ space: 8 }) {
      Text(`记录日期：${record.recordDate ?? '--'}`)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.getTextColor())
        .fontSize(15)

      Grid() {
        GridItem() { this.buildInfoRow('体重(kg)', record.bodyWeight!.toString()) }
        GridItem() { this.buildInfoRow('体温(℃)', record.bodyTemperature!.toString()) }
        GridItem() { this.buildInfoRow('心率', record.heartRate!.toString()) }
        GridItem() { this.buildInfoRow('食欲', record.appetiteLevel) }
        GridItem() { this.buildInfoRow('精力', record.energyLevel) }
        GridItem() { this.buildInfoRow('疫苗接种', record.vaccinationStatus) }
      }
      .columnsTemplate('1fr 1fr')
      .width('100%')

      // 其他信息
      this.buildInfoRow('上次接种日期', record.lastVaccinationDate)
      this.buildInfoRow('驱虫状态', record.dewormingStatus)
      this.buildInfoRow('上次驱虫日期', record.lastDewormingDate)

      // if (record.vetNotes && record.vetNotes !== '') {
      //   Column() {
      //     Text('兽医备注:')
      //       .fontSize(14)
      //       .fontColor(this.getTextColor())
      //       .fontWeight(FontWeight.Medium)
      //       .margin({ bottom: 4 })
      //     Text(record.vetNotes)
      //       .fontSize(14)
      //       .fontColor('#666')
      //       .width('100%')
      //   }
      //   .width('100%')
      //   .margin({ top: 8 })
      // }
    }
    .width('95%')
    .backgroundColor('#99ffffff')
    .borderRadius(8)
    .padding(12)
    .margin({ bottom: 10 })
  }

  // 无记录时的显示
  @Builder
  buildNoRecords(): void {
    Column() {
      Image($r('sys.media.ohos_ic_public_clock'))
        .width(60)
        .height(60)
        .margin({ bottom: 16 })
      Text(this.selectedSpecificDate ? '该日期暂无记录' : '暂无记录')
        .fontSize(16)
        .fontColor('#999')
    }
    .width('100%')
    .padding(40)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
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
  // 数据处理方法
  // ==================

  // 获取过滤后的健康记录
  private getFilteredHealthRecords(): PetHealthHistory[] {
    if (!this.selectedSpecificDate) {
      return this.healthList; // 如果没有选择具体日期，显示所有记录
    }

    return this.healthList.filter((record: PetHealthHistory) => {
      if (!record.recordDate) return false;

      // 提取日期部分进行比较（忽略时间部分）
      const recordDateOnly = this.extractDatePart(record.recordDate);
      return recordDateOnly === this.selectedSpecificDate;
    });
  }

  // 从日期时间字符串中提取日期部分
  private extractDatePart(dateTimeStr: string): string {
    if (!dateTimeStr) return '';

    // 假设日期格式为 "yyyy-MM-dd HH:mm" 或 "yyyy-MM-dd"
    const parts = dateTimeStr.split(' ');
    return parts[0]; // 返回日期部分
  }

  // 生成具体日期选项
  private generateSpecificDateOptions(): void {
    const dateSet = new Set<string>();

    this.healthList.forEach((record: PetHealthHistory) => {
      if (record.recordDate) {
        const dateOnly = this.extractDatePart(record.recordDate);
        dateSet.add(dateOnly);
      }
    });

    // 转换为数组并排序（最新的在前）
    const dates = Array.from(dateSet).sort((a: string, b: string) => {
      return new Date(b).getTime() - new Date(a).getTime();
    });

    // 修复：明确创建SpecificDateOption数组
    const newOptions: SpecificDateOption[] = dates.map((date: string): SpecificDateOption => {
      return {
        value: date,
        label: date
      }
    });

    this.specificDateOptions = newOptions;

    // 默认选择最新的日期
    if (dates.length > 0 && !this.selectedSpecificDate) {
      this.selectedSpecificDate = dates[0];
    }
  }

  // ==================
  // 网络请求部分
  // ==================

  getPetInfo(): void {
    this.isLoading = true
    let result = new HttpUtil().httpRequestGet<ResponseBean<PetBean[]>>(
      "https://place.wxtcc.com.cn/officelease/pets/getPets",
      [
        { key: "key", value: this.userKey },
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

  // 根据选择的日期范围计算开始时间
  private getStartTimeByRange(): string {
    const now = new Date();
    const days = parseInt(this.selectedDateRange);

    if (days === 0) {
      // 全部记录，返回一个很早的日期
      return '2020-01-01 00:00';
    }

    now.setDate(now.getDate() - days);
    return this.formatTime(now);
  }

  getPetHealthRecords(): void {
    this.isLoading = true
    let result = new HttpUtil().httpRequestGet<ResponseBean<DataListBean<PetHealthHistory>>>(
      "https://place.wxtcc.com.cn/officelease/pets/getPetHealthHistory",
      [
        { key: "key", value: this.userKey },
        { key: "petId", value: "1" },
        { key: "startTime", value: this.getStartTimeByRange() },
        { key: "endTime", value: this.getNowTime() },
        { key: "page", value: "1" },
        { key: "size", value: "50" }
      ]
    )

    result.then((value: ResponseBean<DataListBean<PetHealthHistory>>) => {
      const list = value?.data?.list ?? []
      this.healthList = list
      // 生成具体日期选项
      this.generateSpecificDateOptions()
      console.info(`[HealthRecord] ${JSON.stringify(value)}`)
    }).finally(() => {
      this.isLoading = false
    })
  }

  postSavePetData(petData: PetData): void {
    let result = new HttpUtil().httpRequestPost<ResponseBean<string>>(
      "https://place.wxtcc.com.cn/officelease/pets/updatePets",
      "",
      [
        { key: "key", value: this.userKey },
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

  cancel: () => void = () => { }
  confirm: (data: PetData) => void = (data: PetData) => { }
  controller: CustomDialogController

  build() {
    Column({ space: 18 }) {
      Text('✏️ 编辑宠物基础信息')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10 })

      this.inputField('🐶 名字', '请输入宠物名字', (v: string) => this.petName = v)
      this.inputField('🎂 出生日期', '例如 2023-05-10', (v: string) => this.birthDate = v)
      this.inputField('🐕 种类', '例如 金毛 / 猫咪', (v: string) => this.petSpecies = v)
      this.inputField('🐾 品种', '例如 比熊 / 英短 / 田园猫', (v: string) => this.petBreed = v)
      this.inputField('⚖️ 体重(kg)', '请输入数字', (v: string) => this.currentWeight = v, InputType.Number)
      this.inputField('🚻 性别', '雄性 / 雌性', (v: string) => this.petGender = v)
      this.inputField('❤️ 健康状态', '良好 / 需要关注', (v: string) => this.healthStatus = v)

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