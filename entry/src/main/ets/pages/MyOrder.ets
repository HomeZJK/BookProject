import { TitleBarBuilder } from '../builders'
import { ReqLoadingDialog } from '../components'
import { Goods } from '../model/entity'
import { OrderAndGoods } from '../model/entity/OrderData'
import { MyOrderVM } from '../viewmodel'

@Builder
export function MyOrderBuilder() {
    MyOrder()
}

// 我的订单
@Component
struct MyOrder {
    navStack?: NavPathStack = undefined
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    @State currentTabIndex: number = 0
    @State orderData: OrderAndGoods[] = []
    @State currentPage: number = 1
    @State isLoading: boolean = false
    private myOrderVM = MyOrderVM.getInstance()
    private dialog = new CustomDialogController({
        builder: ReqLoadingDialog(),
        customStyle: true,
        alignment: DialogAlignment.Center
    })

    async refreshData(page: number, status: number) {
        this.isLoading = true
        this.dialog.open()
        const r = await this.myOrderVM.getOrderData(page, status)
        this.dialog.close()
        this.isLoading = false
        return r
    }

    showToast(msg: string) {
        try {
            this.getUIContext().getPromptAction().showToast({ message: msg })
        } catch (error) {
        }
    }

    @Builder
    TabBarBuilder(title: string, index: number) {
        Column() {
            Blank()

            Text(title)
                .fontColor(index === this.currentTabIndex ? "" : "#646566")
                .fontSize(14)

            Blank()

            Divider()
                .strokeWidth(2)
                .color(index === this.currentTabIndex ? "#EE0A24" : Color.Transparent)
                .width(35)
        }
        .width("100%")
        .height("100%")
        .border({ width: { bottom: 1 }, color: "#FAFAFA" })
    }

    @Builder
    OrderBuilder() {
        List() {
            ForEach(this.orderData, (item: OrderAndGoods) => {
                ListItem() {
                    Column() {
                        Column() {
                            Text() {
                                Span("订单号：")
                                Span(item.order_no)
                            }
                            .fontSize(18)
                            .margin({ bottom: 15 })

                            Text() {
                                Span("创建时间：")
                                Span(item.created_at?.toLocaleString() ?? "")
                            }
                            .fontSize(18)
                            .fontColor("#2C3E50")

                        }
                        .alignItems(HorizontalAlign.Start)
                        .width("100%")
                        .padding({
                            left: 10,
                            right: 10,
                            top: 20
                        })
                        .backgroundColor("#FAFAFA")

                        ForEach(item.goods.data, (goods: Goods) => {
                            Row() {
                                Column() {
                                    Divider()
                                        .strokeWidth(10)
                                        .color("#FAFAFA")

                                    Row() {
                                        Image($r("app.media.santi"))
                                            .width(90)
                                            .height(90)
                                        Column() {
                                            Text(goods.title)
                                                .fontWeight(700)
                                                .margin({ bottom: 5 })

                                            Text("全场包邮")
                                                .fontColor("#969799")
                                                .fontSize(14)

                                            Blank()

                                            Row() {
                                                Text() {
                                                    Span("￥")
                                                    Span("99.99")
                                                }
                                                .fontSize(17)
                                                .fontColor("#FF6A00")

                                                Blank()

                                                Text() {
                                                    Span("x")
                                                    Span("1")
                                                }
                                                .fontSize(14)
                                                .fontColor("#969799")
                                            }
                                            .width("100%")
                                        }
                                        .height(90)
                                        .layoutWeight(1)
                                        .alignItems(HorizontalAlign.Start)
                                    }
                                    .width("100%")
                                    .padding({
                                        top: 8,
                                        bottom: 8,
                                        left: 13,
                                        right: 13
                                    })

                                }
                            }
                            .width("100%")

                        }, (goods: Goods, index: number) => {
                            return `${goods.id}-${index}`
                        })
                    }
                    .width("100%")
                }
            }, (item: OrderAndGoods, index: number) => {
                return `${item.order_no} ${index}`
            })

        }
        .width("100%")
        .height("100%")
        .flexShrink(1)
        .padding({ left: 5, right: 5 })
        .edgeEffect(EdgeEffect.None)
        .onReachEnd(async () => {
            const r = await this.refreshData(this.currentPage, this.currentTabIndex)
            if (r.length === 0) {
                this.showToast("没有更多了")
            } else {
                this.orderData.push(...r)
            }
        })
    }

    build() {
        NavDestination() {
            TitleBarBuilder("订单列表", this.topArea, 0, () => {
                this.navStack?.pop()
            })

            Tabs() {
                ForEach(["全部", "待付款", "已支付", "发货", "交易完成", "过期"], (item: string, index: number) => {
                    TabContent() {
                        if (this.orderData.length <= 0) {
                            Column() {
                                Text(this.isLoading ? "加载中..." : "没有更多了")
                                    .fontColor("#969799")
                                    .margin({ top: 20 })
                            }
                            .height("100%")
                        } else {
                            this.OrderBuilder()
                        }
                    }
                    .tabBar(this.TabBarBuilder(item, index))
                })
            }
            .scrollable(false)
            .barHeight(40)
            .flexShrink(1)
            .onTabBarClick(async (index: number) => {
                this.currentTabIndex = index
                this.currentPage = 1
                this.orderData = []
                this.orderData = await this.refreshData(this.currentPage, this.currentTabIndex)
            })

        }
        .hideTitleBar(true)
        .width("100%")
        .height("100%")
        .padding({ bottom: this.bottomArea })
        .onReady(async (ctx) => {
            this.navStack = ctx.pathStack
            this.orderData = await this.refreshData(this.currentPage, this.currentTabIndex)
        })
    }
}