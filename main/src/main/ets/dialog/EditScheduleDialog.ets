export  interface EditScheduleDialogData {
  scheduleTime: string;
  foodAmount: string;
  isActive: boolean;
  schedulesInfo: string;
}

@Component
export struct EditScheduleDialog {
  @Prop visible: boolean = false
  @Prop scheduleTime: string = ''
  @Prop foodAmount: string = ''
  @Prop isActive: boolean = false
  @Prop schedulesInfo: string = ''
  @Prop onConfirm: (data: EditScheduleDialogData) => void
  @Prop onCancel: () => void

  @State inputScheduleTime: string = ''
  @State inputFoodAmount: string = ''
  @State inputSchedulesInfo: string = ''
  @State inputIsActive: boolean = false

  aboutToAppear() {
    // 初始化输入框的值
    this.inputScheduleTime = this.scheduleTime
    this.inputFoodAmount = this.foodAmount
    this.inputSchedulesInfo = this.schedulesInfo
    this.inputIsActive = this.isActive
  }

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.Center }) {
        // 背景遮罩
        Column() {}
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => this.onCancel())

        // 弹窗主体
        Column({ space: 15 }) {
          Text('编辑喂食计划')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')

          // 1️⃣ 喂食时间
          Column({ space: 6 }) {
            Text('喂食时间')
              .fontSize(16)
              .fontColor('#555')
            TextInput({ text: this.inputScheduleTime, placeholder: '例如 08:30' })
              .width('100%')
              .height(44)
              .backgroundColor('#f8f8f8')
              .borderRadius(8)
              .padding(10)
              .onChange((value: string) => {
                this.inputScheduleTime = value
              })
          }

          // 2️⃣ 喂食量
          Column({ space: 6 }) {
            Text('喂食量')
              .fontSize(16)
              .fontColor('#555')
            TextInput({ text: this.inputFoodAmount, placeholder: '例如 150g' })
              .width('100%')
              .height(44)
              .backgroundColor('#f8f8f8')
              .borderRadius(8)
              .padding(10)
              .onChange((value: string) => {
                this.inputFoodAmount = value
              })
          }

          // 3️⃣ 是否启用
          Row({ space: 10 }) {
            Text('是否启用')
              .fontSize(16)
              .fontColor('#555')
            Toggle({ type: ToggleType.Switch, isOn: this.inputIsActive })
              .onChange((val: boolean) => {
                this.inputIsActive = val
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)

          // 4️⃣ 备注信息
          Column({ space: 6 }) {
            Text('备注信息')
              .fontSize(16)
              .fontColor('#555')
            TextInput({ text: this.inputSchedulesInfo, placeholder: '例如 早饭喂食，控制在200g内' })
              .width('100%')
              .height(44)
              .backgroundColor('#f8f8f8')
              .borderRadius(8)
              .padding(10)
              .onChange((value: string) => {
                this.inputSchedulesInfo = value
              })
          }

          // 底部按钮
          Row({ space: 20 }) {
            Button('取消')
              .width('40%')
              .height(40)
              .backgroundColor('#f0f0f0')
              .fontColor('#333')
              .fontSize(16)
              .onClick(() => this.onCancel())

            Button('确定')
              .width('40%')
              .height(40)
              .backgroundColor('#007dff')
              .fontColor(Color.White)
              .fontSize(16)
              .onClick(() => {
                this.onConfirm({
                  scheduleTime: this.inputScheduleTime,
                  foodAmount: this.inputFoodAmount,
                  isActive: this.inputIsActive,
                  schedulesInfo: this.inputSchedulesInfo
                })
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
          .margin({ top: 10 })
        }
        .width('85%')
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(16)
        .shadow({ radius: 20, color: '#000000', offsetY: 5 })
      }
      .width('100%')
      .height('100%')
    }


  }
}
