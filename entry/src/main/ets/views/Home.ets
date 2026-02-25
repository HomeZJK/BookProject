import { LengthMetrics } from "@kit.ArkUI"
import { LoadingBuilder, TitleBarBuilder } from "../builders"
import { ReqLoadingDialog } from "../components"
import { Goods, GoodsListType } from "../model/entity"
import { MainVM } from "../viewmodel"

@Component
export struct Home {
    @Consume("navStack") navStack: NavPathStack
    @Prop topArea: number = 0
    @State canScroll: boolean = false
    @State currentBarIndex: number = 0
    @State mainGoods: Goods[] = []
    @State goodsList: Goods[] = []
    @State currentPage: number = 1
    @State listType: GoodsListType = "sales"
    @State isLoading: boolean = false
    private dialog = new CustomDialogController({
        builder: ReqLoadingDialog(),
        customStyle: true,
        alignment: DialogAlignment.Center
    })
    private swiperController = new SwiperController()
    private mainVM = MainVM.getInstance()
    private listTypes: GoodsListType[] = ["sales", "new", "recommend"]

    async aboutToAppear() {
        AppStorage.setOrCreate("navStack", this.navStack)
        this.mainGoods = await this.mainVM.getHomeData()
        this.goodsList = await this.mainVM.getHomeListsData(this.currentPage, this.listType)
    }

    onPageHide(): void {
        this.dialog.close()
    }

    toDetails(id: number) {
        this.navStack.pushPath({ name: "GoodsDetails", param: id })
    }

    @Builder
    HomeItemBuilder(goods: Goods) {
        Column({ space: 10 }) {
            Image($r("app.media.santi"))
                .height(70)
                .width(70)
            Text(goods.title)
                .fontSize(14)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .layoutWeight(1)
        .padding(5)
        .onClick(() => {
            this.toDetails(goods.id)
        })
    }

    @Builder
    ListHeaderBarBuilder(title: string, index: number) {
        Column() {
            Text(title)
                .fontSize(17)
                .fontColor(this.currentBarIndex === index ? "#FFA666" : "")
                .margin(10)

            Divider()
                .strokeWidth(3)
                .width(35)
                .color(this.currentBarIndex === index ? "#FFA666" : Color.Transparent)
        }
        .flexGrow(1)
        .height(40)
        .backgroundColor("#FFF")
        .alignItems(HorizontalAlign.Center)
        .onClick(async () => {
            this.currentBarIndex = index
            this.swiperController.changeIndex(index, true)
            this.listType = this.listTypes[index]
            this.currentPage = 1
            this.dialog.open()
            this.goodsList = await this.mainVM.getHomeListsData(this.currentPage, this.listType)
            this.dialog.close()
        })
    }

    @Builder
    ListHeaderBuilder() {
        Row() {
            ForEach(["畅销", "新书", "精选"], (item: string, index: number) => {
                this.ListHeaderBarBuilder(item, index)
            })
        }
        .width("100%")
    }

    @Builder
    GoodsBuilder(goods: Goods) {
        Column() {
            Image($r("app.media.santi"))
                .width("47%")
                .aspectRatio(1)

            Text(goods.title)
                .margin({ top: 10 })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            Row() {
                Text() {
                    Span("￥")
                        .fontColor("#F00")
                    Span(goods.price.toFixed(2))
                        .fontColor("#F00")
                    Span("    ")
                    SymbolSpan($r("sys.symbol.star"))
                    Span((goods?.sales ?? 0).toString())
                }
                .fontSize(15)
            }
            .margin({ top: 5, bottom: 5 })
        }
        .shadow({
            color: "#E9E9E9",
            offsetX: 2,
            offsetY: 3,
            radius: 5
        })
        .onClick(() => {
            this.toDetails(goods.id)
        })
    }

    @Builder
    GoodsListBuilder() {
        Flex({
            wrap: FlexWrap.Wrap,
            space: { cross: LengthMetrics.vp(15) },
            justifyContent: FlexAlign.SpaceBetween
        }) {
            ForEach(this.goodsList, (item: Goods) => {
                this.GoodsBuilder(item)
            }, (item: Goods, index) => {
                return `${JSON.stringify(item)}${index}`
            })
        }
        .padding({ top: 10, left: 10, right: 10 })
    }

    build() {
        if (this.mainGoods.length > 0) {
            Column() {
                TitleBarBuilder("图书兄弟", this.topArea, 0)

                List({ space: 10 }) {
                    ListItemGroup() {
                        ListItem() {
                            Column() {
                                Swiper() {
                                    Text("图片1")
                                        .textAlign(TextAlign.Center)
                                        .width("100%")
                                        .height(180)
                                        .backgroundColor("#F1C978")
                                    Text("图片2")
                                        .textAlign(TextAlign.Center)
                                        .width("100%")
                                        .height(180)
                                        .backgroundColor("#81BA97")
                                    Text("图片3")
                                        .textAlign(TextAlign.Center)
                                        .width("100%")
                                        .height(180)
                                        .backgroundColor("#D45B34")
                                }
                                .autoPlay(true)

                                Row() {
                                    this.HomeItemBuilder(this.mainGoods[0])
                                    this.HomeItemBuilder(this.mainGoods[1])
                                    this.HomeItemBuilder(this.mainGoods[2])
                                    this.HomeItemBuilder(this.mainGoods[3])
                                }
                                .padding({ top: 5, bottom: 10 })
                                .alignItems(VerticalAlign.Top)
                            }
                        }
                    }
                    .backgroundColor("#FFF")

                    ListItemGroup({ header: this.ListHeaderBuilder() }) {
                        ListItem() {
                            Swiper(this.swiperController) {
                                this.GoodsListBuilder()

                                this.GoodsListBuilder()

                                this.GoodsListBuilder()
                            }
                            .indicator(false)
                            .disableSwipe(true)
                        }
                    }
                    .padding("1%")
                    .layoutWeight(1)
                    .backgroundColor("#FFF")

                }
                .width("100%")
                .height("100%")
                .flexShrink(1)
                .onScrollStart(() => {
                    this.canScroll = true
                })
                .onReachEnd(async () => {
                    if (this.canScroll) {
                        this.dialog.open()
                        this.currentPage += 1
                        const data = await this.mainVM.getHomeListsData(this.currentPage, this.listType)
                        if (data.length > 0) {
                            this.goodsList.push(...data)
                        } else {
                            try {
                                this.getUIContext().getPromptAction().showToast({ message: "没有更多了" })
                            } catch (error) {
                            }
                        }
                        this.dialog.close()
                    }
                })
            }
            .width("100%")
            .height("100%")
            .backgroundColor("#EEEEEE")
        } else {
            LoadingBuilder()
        }
    }
}