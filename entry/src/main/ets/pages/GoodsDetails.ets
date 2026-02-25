import { LengthMetrics } from "@kit.ArkUI"
import { LoadingBuilder, TitleBarBuilder } from "../builders"
import { Goods } from "../model/entity"
import { GoodsDetailsVM } from "../viewmodel"
import { webview } from "@kit.ArkWeb"
import { ReqLoadingDialog } from "../components"
import { emitter } from "@kit.BasicServicesKit"

@Builder
export function GoodsDetailsBuilder() {
    GoodsDetails()
}


// 商品详情
@Component
struct GoodsDetails {
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    @State goods?: Goods = undefined
    @State likeGoods: Goods[] = []
    @State num: number = 1
    @State isEditing: boolean = false
    @State isCollect: boolean = false
    @State currentTabIndex: number = 0
    private navStack?: NavPathStack = undefined
    private goodsDetailsVM = GoodsDetailsVM.getInstance()
    private webviewController: WebviewController = new webview.WebviewController()
    private richStrHead: string = '<head><meta name="viewport" content="width=device-width, initial-scale=1"></head>'
    private dialog = new CustomDialogController({
        builder: ReqLoadingDialog(),
        customStyle: true,
        alignment: DialogAlignment.Center
    })

    showToast(msg: string) {
        try {
            this.getUIContext().getPromptAction().showToast({ message: msg })
        } catch (error) {
        }
    }

    @Styles
    buttonStyles(){
        .backgroundColor("#F2F3F5")
        .width(30)
        .height(30)
    }

    @Builder
    TabBarBuilder(title: string, index: number) {
        Column() {
            Blank()

            Text(title)
                .fontColor(index === this.currentTabIndex ? "" : "#646566")
                .overlay(index === 1 ? this.OverlayContentBuilder() : "", { offset: { x: 30, y: -5 } })

            Blank()

            Divider()
                .strokeWidth(3)
                .color(index === this.currentTabIndex ? "#EE0A24" : Color.Transparent)
                .width(40)
        }
        .width("100%")
        .height("100%")
        .border({ width: { bottom: 1 }, color: "#FAFAFA" })
    }

    @Builder
    OverlayContentBuilder() {
        Text("99+")
            .fontColor("#FFF")
            .fontSize(12)
            .textAlign(TextAlign.Center)
            .height(16)
            .lineHeight(16)
            .padding({ left: 4, right: 4 })
            .backgroundColor("#EE0A24")
            .borderRadius("50%")
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
                    Span((goods.collects_count ?? 0).toString())
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
            this.navStack?.pushPath({ name: "GoodsDetails", param: goods.id })
        })
    }

    build() {
        NavDestination() {
            if (this.goods) {
                TitleBarBuilder(`${this.goods.title}详情`, this.topArea, 0, () => {
                    this.navStack?.pop()
                    if (this.navStack?.size() === 0) {
                        emitter.emit("refreshCart")
                    }
                })

                Column() {
                    Scroll() {
                        Column() {
                            Image($r("app.media.santi"))
                                .width("100%")
                                .height(200)
                                .objectFit(ImageFit.Contain)
                            Text(this.goods.title)
                                .fontSize(21)
                                .fontColor("#FFF")
                                .fontWeight(700)
                                .width("100%")
                                .backgroundColor("#FF6A00")
                                .textAlign(TextAlign.Center)
                                .padding(3)

                            Column() {
                                Row() {
                                    Text(this.goods.description)
                                        .fontSize(14)
                                }
                                .padding(5)
                                .backgroundColor("#FFF")
                                .alignItems(VerticalAlign.Top)
                                .width("100%")
                                .height(50)

                                Row() {
                                    Text("新书")
                                        .fontSize(14)
                                        .fontColor("#EE0A24")
                                        .border({ width: 1, color: "#EE0A24" })
                                        .borderRadius(2)
                                        .padding({ left: 4, right: 4 })
                                        .backgroundColor("#FFF")
                                }
                                .width("100%")
                                .margin({ top: 8, bottom: 8 })

                                Row() {
                                    Text() {
                                        Span("￥")
                                        Span(this.goods.price.toFixed(2))
                                    }
                                    .fontSize(20)
                                    .fontColor("#FF6A00")

                                    Blank()

                                    Text() {
                                        Span("剩余 ")
                                        Span(this.goods.stock.toString())
                                            .fontWeight(700)
                                        Span(" 件")
                                    }
                                    .fontSize(14)
                                    .fontColor("#969799")
                                }
                                .width("100%")

                                Row() {
                                    Text("我要买")
                                        .fontSize(14)

                                    Blank()

                                    Text("（不限购）")
                                        .fontSize(14)
                                        .fontColor("#FF6A00")

                                    Button({ type: ButtonType.Normal, stateEffect: this.num <= 1 ? false : true }) {
                                        Text("-")
                                            .fontSize(25)
                                    }
                                    .buttonStyles()
                                    .opacity(this.num <= 1 ? 0.5 : 1)
                                    .onClick(() => {
                                        if (this.num > 1) {
                                            this.num -= 1
                                        }
                                    })

                                    TextInput({ text: this.num.toString() })
                                        .type(InputType.Number)
                                        .height("100%")
                                        .aspectRatio(1)
                                        .padding(0)
                                        .borderRadius(0)
                                        .margin({ left: 3, right: 3 })
                                        .height(30)
                                        .width(30)
                                        .textAlign(TextAlign.Center)
                                        .onChange((text) => {
                                            const n = parseInt(text)
                                            this.num = n
                                            if (!this.isEditing) {
                                                if (n < 0 || Number.isNaN(n)) {
                                                    this.num = 1
                                                } else {
                                                    this.num = n
                                                }
                                            }
                                        })
                                        .onEditChange((state) => {
                                            this.isEditing = state
                                            if (!state) {
                                                if (this.num <= 0 || Number.isNaN(this.num)) {
                                                    this.num = 1
                                                } else if (this.goods?.stock && this.num >= this.goods.stock) {
                                                    this.num = this.goods.stock
                                                }
                                            }
                                        })

                                    Button({ type: ButtonType.Normal, stateEffect: this.num >= this.goods.stock }) {
                                        Text("+")
                                            .fontSize(25)
                                    }
                                    .buttonStyles()
                                    .opacity(this.num >= this.goods.stock ? 0.5 : 1)
                                    .onClick(() => {
                                        if (this.goods?.stock && this.num >= this.goods.stock) {
                                            this.showToast("不能再加了")
                                        } else {
                                            this.num += 1
                                        }
                                    })

                                }
                                .width("100%")
                                .margin({ bottom: 15 })

                                Row() {
                                    Column() {
                                        if (this.isCollect) {
                                            SymbolGlyph($r("sys.symbol.star_fill"))
                                                .fontSize(20)
                                                .fontColor(["#FF6A00"])
                                        } else {
                                            SymbolGlyph($r("sys.symbol.star"))
                                                .fontSize(20)
                                        }
                                        Text() {
                                            if (this.isCollect) {
                                                Span("已收藏")
                                            } else {
                                                Span("收藏")
                                            }
                                        }
                                        .fontSize(15)
                                    }
                                    .width(55)
                                    .onClick(async () => {
                                        if (this.goods) {
                                            this.dialog.open()
                                            const r = await this.goodsDetailsVM.collectGoods(this.goods.id)
                                            console.log(`收藏结果：${r}`)
                                            this.dialog.close()
                                            if (r === 1) {
                                                this.isCollect = true
                                            } else if (r === 2) {
                                                this.isCollect = false
                                            }
                                        }
                                    })

                                    Blank()

                                    Button({ type: ButtonType.Normal }) {
                                        Text("加入购物车")
                                            .fontColor("#FFF")
                                            .fontSize(14)
                                    }
                                    .height(40)
                                    .width(95)
                                    .padding({ left: 14, right: 8 })
                                    .borderRadius({ topLeft: "50%", bottomLeft: "50%" })
                                    .linearGradient({
                                        colors: [["#E88F3B", 0], ["#F3CE4E", 1]],
                                        direction: GradientDirection.Left
                                    })
                                    .onClick(async () => {
                                        if (this.goods) {
                                            this.dialog.open()
                                            const r = await this.goodsDetailsVM.addCart(this.goods.id, this.num)
                                            this.dialog.close()
                                            r ? this.showToast("加入购物车成功") : this.showToast("加入购物车失败")
                                        }
                                    })

                                    Button({ type: ButtonType.Normal }) {
                                        Text("立即购买")
                                            .fontColor("#FFF")
                                            .fontSize(14)
                                    }
                                    .height(40)
                                    .width(95)
                                    .padding({ left: 8, right: 14 })
                                    .borderRadius({ topRight: "50%", bottomRight: "50%" })
                                    .linearGradient({
                                        colors: [["#E46B43", 0], ["#EE0A24", 1]],
                                        direction: GradientDirection.Right
                                    })
                                    .onClick(async () => {
                                        if (this.goods) {
                                            this.dialog.open()
                                            await this.goodsDetailsVM.addCart(this.goods.id, this.num)
                                            this.dialog.close()
                                            emitter.emit("resetPage", { data: { "index": 2 } })
                                            this.navStack?.clear()
                                        }
                                    })

                                }
                                .width("100%")
                                .margin({ bottom: 5 })
                            }
                            .width("100%")
                            .padding({
                                top: 5,
                                bottom: 5,
                                left: 10,
                                right: 10
                            })
                            .backgroundColor("#F7F8FA")

                            Tabs({ index: this.currentTabIndex }) {
                                TabContent() {
                                    Web({ src: "", controller: this.webviewController })
                                        .onControllerAttached(() => {
                                            try {
                                                this.webviewController.loadData(this.richStrHead + this.goods?.details,
                                                    "text/html",
                                                    "UTF-8",
                                                    " ", " ")
                                            } catch (error) {
                                            }
                                        })
                                        .width("100%")
                                }
                                .tabBar(this.TabBarBuilder("概述", 0))
                                .height(200)

                                TabContent() {
                                    Column() {
                                        Image($r("app.media.table"))
                                            .width("50%")
                                            .aspectRatio(1)
                                            .margin({ top: 15 })

                                        Text("该商品没有评论")
                                            .fontSize(18)
                                            .fontColor("#969799")
                                            .margin({ top: 10, bottom: 20 })

                                        Button() {
                                            Text("去发表评论")
                                                .fontSize(18)
                                                .fontColor("#FFF")
                                        }
                                        .backgroundColor("#EE0A24")
                                        .width("50%")
                                        .height(45)
                                        .borderRadius("50%")
                                        .margin({ bottom: 20 })
                                    }
                                    .width("100%")
                                }
                                .tabBar(this.TabBarBuilder("热评", 1))

                                TabContent() {
                                    Flex({
                                        wrap: FlexWrap.Wrap,
                                        space: { cross: LengthMetrics.vp(15) },
                                        justifyContent: FlexAlign.SpaceBetween
                                    }) {
                                        ForEach(this.likeGoods, (item: Goods) => {
                                            this.GoodsBuilder(item)
                                        }, (item: number, index) => {
                                            return `${JSON.stringify(item)}${index}`
                                        })
                                    }
                                    .padding({ top: 10, left: 10, right: 10 })
                                }
                                .tabBar(this.TabBarBuilder("相关图书", 2))

                            }
                            .scrollable(false)
                            .barHeight(40)
                            .onTabBarClick((index: number) => {
                                this.currentTabIndex = index
                            })
                            .barBackgroundColor("#FFF")
                            .height("auto")

                        }
                    }

                }
                .width("100%")
                .layoutWeight(1)
            } else {
                LoadingBuilder()
            }
        }
        .width("100%")
        .height("100%")
        .padding({ bottom: this.bottomArea })
        .hideTitleBar(true)
        .onReady(async (ctx) => {
            this.navStack = ctx.pathStack
            const details = await this.goodsDetailsVM.getGoodsDetails(ctx.pathInfo.param as number)
            this.goods = details?.goods
            this.likeGoods = details?.like_goods ?? []
            this.isCollect = details?.goods.is_collect === 1 ? true : false
        })
        .onBackPressed(() => {
            if (this.navStack?.size() === 1) {
                emitter.emit("refreshCart")
            }
            return false
        })
    }
}