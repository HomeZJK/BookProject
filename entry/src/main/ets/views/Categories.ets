import { TitleBarBuilder } from "../builders"
import { ReqLoadingDialog } from "../components"
import { Category, Goods, SortType } from "../model/entity"
import { MainVM } from "../viewmodel"

@Component
export struct Categories {
    @Consume("navStack") navStack: NavPathStack
    @State topArea: number = 0
    @State canScroll: boolean = false
    // 父索引，是否展开
    @State selectIndex: [number, boolean] = [0, false]
    // 父索引，子索引，id
    @State selectChildIndex: [number, number, number] = [0, 0, 0]
    @State currentTabIndex: number = 0
    @State categories: Category[] = []
    @State goods: Goods[] = []
    @State currentPage: number = 1
    @State sortType: SortType = "sales"
    @State isLoading: boolean = false
    private tabsController: TabsController = new TabsController()
    private mainVM = MainVM.getInstance()
    private dialog = new CustomDialogController({
        builder: ReqLoadingDialog(),
        customStyle: true,
        alignment: DialogAlignment.Center
    })

    async aboutToAppear() {
        this.categories = await this.mainVM.getCategories()
        this.selectChildIndex[2] = this.categories[0].children?.[0].id ?? 0
        const data = await this.mainVM.getCategoriesListData(this.currentPage, this.selectChildIndex[2], this.sortType)
        this.goods = data.data
    }

    async getNewGoods() {
        this.dialog.open()
        const data = (await this.mainVM.getCategoriesListData(this.currentPage, this.selectChildIndex[2],
            this.sortType)).data
        this.dialog.close()
        return data
    }

    @Builder
    SelectBarBuilder(category: Category, index: number) {
        Row() {
            Text(category.name)
                .fontSize(18)
                .height("30")
                .backgroundColor("#FFF")

                .layoutWeight(1)
                .textAlign(TextAlign.Center)

            SymbolGlyph($r("sys.symbol.chevron_down"))
                .fontSize(22)
                .rotate({ angle: this.selectIndex[0] === index && this.selectIndex[1] ? 180 : 0 })
                .animation({ duration: 300 })
        }
        .margin({
            left: 10,
            right: 10,
            top: 10
        })
        .padding({ bottom: 10 })
        .border({
            width: {
                bottom: index === this.categories.length - 1 ? 0 : 1
            }, color: "#F2F3F5"
        })
        .onClick(() => {
            if (this.selectIndex[0] === index) {
                this.selectIndex[1] = !this.selectIndex[1]
            } else {
                this.selectIndex[1] = true
            }
            this.selectIndex[0] = index
        })
    }

    @Builder
    SelectItemBuilder(category: Category, parentIndex: number, index: number) {
        Row() {
            Blank()
                .width(4)
                .backgroundColor(this.selectChildIndex[0] === parentIndex &&
                    this.selectChildIndex[1] === index ? "#EE0A24" : "")

            Text(category.name)

            Blank()
                .width(4)
        }
        .width("100%")
        .padding({
            top: 15,
            bottom: 15,
            left: 10,
            right: 10
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor(this.selectChildIndex[0] === parentIndex &&
            this.selectChildIndex[1] === index ? "#FFF" : "#F7F8FA")
        .onClick(async () => {
            this.canScroll = false
            this.currentTabIndex = 0
            this.sortType = "sales"
            this.selectChildIndex[1] = index
            this.selectChildIndex[2] = this.categories[parentIndex].children?.[index].id ?? 0
            this.selectChildIndex[0] = parentIndex
            this.currentPage = 1
            this.goods = await this.getNewGoods()
        })
    }

    @Builder
    TabBarBuilder(title: string, index: number) {
        Column() {
            Blank()

            Text(title)
                .fontColor(index === this.currentTabIndex ? "" : "#646566")
                .fontSize(15)

            Blank()

            Divider()
                .strokeWidth(3)
                .color(index === this.currentTabIndex ? "#EE0A24" : Color.Transparent)
                .width(50)
        }
        .width("100%")
        .height("100%")
        .border({ width: { bottom: 1 }, color: "#FAFAFA" })
    }

    @Builder
    GoodsItemBuilder(goods: Goods) {
        Row() {
            Image($r("app.media.santi"))
                .width("33%")
                .aspectRatio(1)
                .overlay(this.OverlayContentBuilder())

            Column() {
                Text(goods.title)
                    .fontSize(14)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text() {
                    Span("￥")
                    Span(goods.price.toFixed(2))
                }
                .fontColor("#FF6A00")
                .margin({ top: 10, bottom: 10 })

                Row() {
                    Text("商品销量")
                        .fontColor("#666")
                        .fontSize(13)
                        .fontWeight(600)

                    Text() {
                        Span("x")
                        Span((goods.sales ?? 0).toString())
                    }
                    .fontColor("#969799")
                    .fontSize(13)
                }
                .width("100%")
                .justifyContent(FlexAlign.SpaceBetween)
            }
            .width("100%")
            .flexShrink(1)
            .alignItems(HorizontalAlign.Start)
        }
        .width("100%")
        .padding({ left: 5, right: 5 })
        .backgroundColor("#F7F8FA")
        .alignItems(VerticalAlign.Top)
        .onClick(() => {
            this.navStack.pushPath({ name: "GoodsDetails", param: goods.id })
        })
    }

    @Builder
    GoodsListBuilder() {
        List({ space: 10 }) {
            ForEach(this.goods, (item: Goods) => {
                ListItem() {
                    this.GoodsItemBuilder(item)
                }
            }, (item: Goods, index) => {
                return `${JSON.stringify(item)}${index}`
            })
        }
        .width("100%")
        .height("100%")
        .padding({ top: 5 })
        .onScrollStart(() => {
            this.canScroll = true
        })
        .onReachEnd(async () => {
            setTimeout(() => {
                this.isLoading = false
            }, 1500)
            if (this.canScroll && !this.isLoading) {
                this.isLoading = true
                this.currentPage += 1
                let data = await this.getNewGoods()
                if (data.length > 0) {
                    this.goods.push(...data)
                } else {
                    this.currentPage -= 1
                    try {
                        this.getUIContext().getPromptAction().showToast({ message: "没有更多了" })
                    } catch (error) {
                    }
                }
            }
        })

    }

    @Builder
    OverlayContentBuilder() {
        Text("流行")
            .fontColor("#FFF")
            .fontSize(14)
            .lineHeight(20)
            .height(20)
            .width(36)
            .padding({ left: 3, right: 3 })
            .backgroundColor("#EE0A24")
            .borderRadius({ topRight: "50%", bottomRight: "50%" })
    }

    build() {
        Column() {
            TitleBarBuilder("分类", this.topArea, 0)
            SideBarContainer(SideBarContainerType.Embed) {
                List() {
                    ListItem() {
                        Divider()
                            .strokeWidth(1)
                            .color("#F2F3F5")
                    }

                    ForEach(this.categories, (item: Category, parentIndex) => {
                        ListItemGroup({ header: this.SelectBarBuilder(item, parentIndex) }) {
                            ListItem() {
                                if (parentIndex == this.selectIndex[0] && this.selectIndex[1]) {
                                    Column() {
                                        ForEach(item.children, (child: Category, index) => {
                                            this.SelectItemBuilder(child, parentIndex, index)
                                        }, (child: Category, index) => {
                                            return child.name + index
                                        })
                                    }
                                    .alignItems(HorizontalAlign.Start)
                                    .padding({
                                        top: 10,
                                        bottom: 10,
                                        left: 5,
                                        right: 5
                                    })
                                }
                            }
                        }
                    }, (item: Category, index) => {
                        return item.name + index
                    })

                    ListItem() {
                        Divider()
                            .strokeWidth(1)
                            .color("#F2F3F5")
                    }
                }
                .width("100%")
                .height("100%")
                .backgroundColor("#FFF")
                .margin({ top: 45 })

                Tabs({ controller: this.tabsController }) {
                    ForEach(["销量排序", "价格排序", "评论排序"], (item: string, index) => {
                        TabContent() {
                            if (this.goods.length > 0) {
                                this.GoodsListBuilder()
                            } else {
                                Column() {
                                    Text("该分类下没有商品")
                                        .margin({ top: 30 })
                                        .fontColor("#666")
                                }
                                .width("100%")
                                .height("100%")
                            }
                        }
                        .tabBar(this.TabBarBuilder(item, index))
                    }, (item: string, index) => {
                        return item + index
                    })
                }
                .layoutWeight(1)
                .scrollable(false)
                .onTabBarClick(async (index: number) => {
                    this.canScroll = false
                    this.currentTabIndex = index
                    this.sortType = ["sales", "price", "comments_count"][index] as SortType
                    this.currentPage = 1
                    this.goods = await this.getNewGoods()
                })
                .barHeight(45)
            }
            .showControlButton(false)
            .showSideBar(true)
            .sideBarWidth("33%")
            .maxSideBarWidth("33%")
            .minSideBarWidth("33%")
            .autoHide(false)
            .flexShrink(1)
        }
        .width("100%")
        .height("100%")
    }
}