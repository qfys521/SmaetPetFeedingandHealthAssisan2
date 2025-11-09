import { KnowledgeBean, parseToBeans, knowledgeBeanStr } from '../model/KnowledgeBean'

@Component
export struct KnowledgePage {
  @State private knowledgeList: KnowledgeBean[] = parseToBeans(knowledgeBeanStr);
  @State private searchText: string = '';
  @State private expandedTitles: Set<string> = new Set();
  @State private loadingItems: Set<string> = new Set(); // 正在加载的条目
  @State private isSearching: boolean = false; // 搜索加载状态
  @State private filteredList: KnowledgeBean[] = []; // 过滤后的列表

  private listScroller: Scroller = new Scroller();

  aboutToAppear() {
    this.collapseAll();
    this.filteredList = this.knowledgeList; // 初始化显示所有内容
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景图
      Image($r('app.media.bg2'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .objectRepeat(ImageRepeat.NoRepeat);

      Column() {
        // 顶部固定栏
        Column() {
          // 标题与副标题
          Column() {
            Text('知识库')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222')
            Text('宠物养护知识与技巧')
              .fontSize(14)
              .fontColor('#666')
          }
          .padding({ top: 20, left: 14, right: 20, bottom: 8 })
          .borderRadius({ bottomLeft: 12, bottomRight: 12 })
          .shadow({ radius: 8, color: '#33000000', offsetY: 2 })

          // 搜索框
          Row() {
            Image($r('sys.media.AI_search'))
              .width(20)
              .height(20)
              .margin({ right: 8 })
              .onClick(() => {
                this.handleSearch(this.searchText);
              })
            TextInput({ text: this.searchText, placeholder: '搜索养宠知识...'})
              .onChange((val: string) => {
                this.searchText = val;
              })
              .width('100%')
              .height(36)
              .backgroundColor('#f4f4f4')
              .borderRadius(18)
              .padding({ left: 10 })

          }
          .padding({ left: 15, right: 20, bottom: 12, top: 6 })
          .width('80%')
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)

        }
        .position({ x: 0, y: 0 })
        .zIndex(10)
        .width('100%')

        // 主体内容：滚动列表 - 调整marginTop避免覆盖标题
        Scroll(this.listScroller) {
          Column({ space: 8 }) {
            if (this.isSearching) {
              // 搜索加载中
              this.buildSearchLoading()
            } else if (this.searchText.trim() !== '' && this.filteredList.length === 0) {
              // 没有搜索结果
              this.buildNoSearchResult()
            } else {
              // 正常显示列表
              ForEach(this.filteredList, (bean: KnowledgeBean) => {
                this.buildKnowledgeCard(bean);
              })
            }
          }
          .padding({ top: 8, left: 20, right: 20, bottom: 20 })
        }
        .margin({ top: 140 }) // 调整marginTop以适应新的顶部高度
        .width('100%')
        .height('100%')
        .scrollable(ScrollDirection.Vertical)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildKnowledgeCard(bean: KnowledgeBean): void {
    Column() {
      // 主卡片
      Row() {
        Text(bean.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222')
          .flexGrow(1)

        Image(this.expandedTitles.has(bean.title)
          ? $r('sys.media.ohos_ic_public_arrow_up')
          : $r('sys.media.ohos_ic_public_arrow_down'))
          .width(16)
          .height(16)
          .margin({ left: 8 })
      }
      .width('100%')
      .padding({ bottom: 8 })
      .onClick(() => this.toggleExpand(bean.title))

      // 展开的内容卡片
      if (this.expandedTitles.has(bean.title)) {
        // 加载状态
        if (this.loadingItems.has(bean.title)) {
          this.buildLoadingCard()
        } else {
          this.buildExpandedContentCard(bean)
        }
      }
    }
    .padding(12)
    .backgroundColor('#80ffffff') // 半透明白色背景
    .borderRadius(12)
    .shadow({ radius: 6, color: '#22000000', offsetY: 2 })
    .width('100%')
  }

  @Builder
  buildExpandedContentCard(bean: KnowledgeBean): void {
    Column({ space: 8 }) {
      // 根据搜索条件过滤子卡片


      if ((this.searchText.trim() === ''
        ? bean.subSentences
        : bean.subSentences.filter((sentence: string) => sentence.includes(this.searchText.trim()))).length === 0) {
        // 如果没有匹配的子卡片，不显示任何内容
        Blank()
      } else {
        ForEach((this.searchText.trim() === ''
          ? bean.subSentences
          : bean.subSentences.filter((sentence: string) => sentence.includes(this.searchText.trim()))), (sentence: string, index: number) => {
          // 每个子项都是独立的卡片，包含编号
          Column() {
            Row() {
              // 提取并显示编号（如"1."、"2."等）
              Text(this.extractNumberPrefix(sentence))
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .fontColor('#66CCFF')
                .margin({ right: 12 })

              // 显示剩余内容，高亮搜索关键词
              Text(this.getHighlightedContent(sentence))
                .fontSize(14)
                .fontColor('#555')
                .flexGrow(1)
                .textAlign(TextAlign.Start)
                .width("80%")
            }
            .width('100%')
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#f8f8f8') // 子项卡片背景色
          .borderRadius(8)
          .border({ width: 1, color: '#e0e0e0' })
        })
      }
    }
    .width('100%')
    .padding({ top: 8 })
  }

  @Builder
  buildLoadingCard(): void {
    Column() {
      Row() {
        LoadingProgress()
          .width(20)
          .height(20)
        Text('加载中...')
          .fontSize(14)
          .fontColor('#666')
          .margin({ left: 8 })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#40f0f0f0')
    .borderRadius(8)
    .margin({ top: 8 })
  }

  @Builder
  buildSearchLoading(): void {
    Column() {
      Row() {
        LoadingProgress()
          .width(30)
          .height(30)
        Text('搜索中...')
          .fontSize(16)
          .fontColor('#666')
          .margin({ left: 12 })
      }
    }
    .width('100%')
    .padding(40)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildNoSearchResult(): void {
    Column() {
      Image($r('sys.media.ohos_ic_public_search_filled'))
        .width(60)
        .height(60)
        .margin({ bottom: 16 })
      Text('暂无搜索内容哦~')
        .fontSize(16)
        .fontColor('#999')
    }
    .width('100%')
    .padding(40)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // ========== 搜索处理 ==========
  private handleSearch(searchText: string): void {
    if (searchText.trim() === '') {
      // 清空搜索，显示所有内容
      this.filteredList = this.knowledgeList;
      this.collapseAll();
      return;
    }

    // 显示搜索加载动画
    this.isSearching = true;

    // 模拟异步搜索（实际应用中可能是网络请求）
    setTimeout(() => {
      const query = searchText.trim().toLowerCase();
      const matchingTitles = new Set<string>();

      // 过滤列表：只显示标题匹配或子内容匹配的知识项
      const filtered = this.knowledgeList.filter((item: KnowledgeBean) => {
        const titleMatch = item.title.toLowerCase().includes(query);
        const contentMatch = item.subSentences.some((s: string) =>
        s.toLowerCase().includes(query)
        );

        // 如果子内容匹配，记录标题用于展开
        if (contentMatch) {
          matchingTitles.add(item.title);
        }

        // 显示条件：标题匹配 或 子内容匹配
        return titleMatch || contentMatch;
      });

      this.filteredList = filtered;
      this.expandedTitles = matchingTitles;
      this.isSearching = false;
    }, 800); // 800ms 模拟搜索时间
  }

  // ========== 展开/折叠控制 ==========
  private toggleExpand(title: string): void {
    if (this.expandedTitles.has(title)) {
      // 如果已经展开，直接折叠
      const newExpanded = new Set(this.expandedTitles);
      newExpanded.delete(title);
      this.expandedTitles = newExpanded;
      this.loadingItems.delete(title);
    } else {
      // 如果未展开，先显示加载状态，然后异步展开
      const newLoading = new Set(this.loadingItems);
      newLoading.add(title);
      this.loadingItems = newLoading;

      // 模拟异步加载
      setTimeout(() => {
        const newExpanded = new Set(this.expandedTitles);
        newExpanded.add(title);
        this.expandedTitles = newExpanded;

        const newLoadingAfter = new Set(this.loadingItems);
        newLoadingAfter.delete(title);
        this.loadingItems = newLoadingAfter;
      }, 300); // 300ms 模拟加载时间
    }
  }

  private collapseAll(): void {
    this.expandedTitles = new Set();
    this.loadingItems = new Set();
  }

  // ========== 文本处理工具方法 ==========
  private extractNumberPrefix(sentence: string): string {
    // 提取开头的数字编号，如"1."、"2."等
    const match = sentence.match(/^(\d+\.)\s/);
    return match ? match[1] : '•';
  }

  private extractContent(sentence: string): string {
    // 提取编号后的内容
    return sentence.replace(/^\d+\.\s/, '');
  }

  private getHighlightedContent(sentence: string): string {
    const query = this.searchText.trim();
    if (query === '') {
      return this.extractContent(sentence);
    }

    // 简单的高亮实现：在实际项目中可能需要更复杂的高亮逻辑
    const content = this.extractContent(sentence);
    return content;
  }
}