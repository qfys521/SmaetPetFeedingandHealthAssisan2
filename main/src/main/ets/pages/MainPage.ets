import { DashboardPage } from '../pageView/DashboardPage'
import { FeedAndHealthPage } from '../pageView/FeedAndHealthPage'
import { KnowledgePage } from '../pageView/KnowledgePage'
import { MyPage } from '../pageView/MyPage'
import { ProfilePage } from '../pageView/ProfilePage'

@Entry
@Component
struct MainPage {
  // 当前页面
  @State currentIndex: number = 0
  //tab bar 控制器
  tabController: TabsController = new TabsController()

  @Builder
  TabBuilder(tabTitle: string , index: number , image: Resource){
    Column({ space: 5 }) {
      SymbolGlyph(image)
        .fontSize(30)
        .fontColor(this.currentIndex == index ? ['#ff0dbfee'] : [Color.Black])
      Text(tabTitle)
        .fontColor(this.currentIndex == index ? '#ff0dbfee' : Color.Black)
    }.onClick(() => {
      this.currentIndex = index
      this.tabController.changeIndex(index)
    })
  }

  build() {
    Tabs({barPosition: BarPosition.End , controller:this.tabController}){
      TabContent(){
        DashboardPage()
      }
      .tabBar(this.TabBuilder('首页' , 0 , $r('sys.symbol.house')))
      .backgroundColor($r('sys.color.comp_background_focus'))
      TabContent(){
        FeedAndHealthPage()
      }
      .tabBar(this.TabBuilder('喂养健康' , 1 , $r('sys.symbol.life_payment')))
      .backgroundColor($r('sys.color.comp_background_focus'))
      TabContent(){
        ProfilePage()
      }
      .tabBar(this.TabBuilder('宠物档案' , 2 , $r('sys.symbol.doc')))
      .backgroundColor($r('sys.color.comp_background_focus'))
      TabContent(){
        KnowledgePage()
      }
      .tabBar(this.TabBuilder('知识库' , 3 , $r('sys.symbol.knowing_everything')))
      .backgroundColor($r('sys.color.comp_background_focus'))
      TabContent(){
        MyPage()
      }
      .tabBar(this.TabBuilder('我的' , 4 , $r('sys.symbol.my_plans')))
      .backgroundColor($r('sys.color.comp_background_focus'))

    }.onChange((index) => {
      this.currentIndex = index
    })
    .backgroundColor('#bbFFFFFF')
  }
}