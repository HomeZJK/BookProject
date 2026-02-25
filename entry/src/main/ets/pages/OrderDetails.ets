import { TitleBarBuilder } from '../builders'

@Builder
export function OrderDetailsBuilder() {
    OrderDetails()
}

// 订单详情
@Component
struct OrderDetails {
    navStack?: NavPathStack = undefined
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0

    @Builder
    ItemBuilder(title: string, value: string) {
        Text() {
            Span(title)
                .fontColor("#999")
            Span(value)
        }
        .fontSize(18)
    }

    @Builder
    ProductItemBuilder() {
        Row() {
            Image($r("app.media.santi"))
                .width(90)
                .height(90)
            Column() {
                Text("《Java从入门到入土》")
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

    build() {
        NavDestination() {
            TitleBarBuilder("订单详情", this.topArea, 0, () => {
                this.navStack?.pop()
            })

            Column() {
                Scroll() {
                    Column() {
                        Column() {
                            this.ItemBuilder("订单状态：", "待付款")

                            Blank()
                                .height(10)

                            this.ItemBuilder("订单编号：", "2020123456789")

                            Blank()
                                .height(10)

                            this.ItemBuilder("下单时间：", "2020-12-12 12:12:12")

                            Blank()
                                .height(10)

                            Button("催发货", { type: ButtonType.Normal })
                                .width("100%")
                                .backgroundColor(Color.Transparent)
                                .fontColor("#000")
                                .fontWeight(400)
                                .borderWidth(1)
                                .borderColor("#E7E7E7")
                                .onClick(() => {
                                    this.getUIContext().showAlertDialog(
                                        {
                                            title: " ",
                                            subtitle: "收到，马上安排...",
                                            message: " ",
                                            textStyle: {
                                                fontColor: "#F00"
                                            },
                                            autoCancel: true,
                                            alignment: DialogAlignment.Center,
                                            gridCount: 3,
                                            confirm: {
                                                value: "确认",
                                                action: () => {
                                                },
                                                fontColor: "#EE0A24"
                                            }
                                        }
                                    )
                                })

                        }
                        .width("100%")
                        .alignItems(HorizontalAlign.Start)
                        .backgroundColor("#FFF")
                        .margin({ bottom: 20 })
                        .padding({
                            top: 15,
                            bottom: 15,
                            left: 15,
                            right: 15
                        })

                        Column() {
                            this.ItemBuilder("商品金额：", "114.51")

                            Blank()
                                .height(10)

                            this.ItemBuilder("配送方式：", "普通快递")
                        }
                        .width("100%")
                        .backgroundColor("#FFF")
                        .alignItems(HorizontalAlign.Start)
                        .padding({
                            top: 15,
                            bottom: 15,
                            left: 15,
                            right: 15
                        })

                        ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], (item: number, index) => {
                            this.ProductItemBuilder()
                        }, (item: number) => {
                            return item + ""
                        })

                        Blank()
                            .height(20)

                    }
                }
            }
            .width("100%")
            .layoutWeight(1)
            .backgroundColor("#F7F8FA")

        }
        .hideTitleBar(true)
        .width("100%")
        .height("100%")
        .padding({ bottom: this.bottomArea })
        .onReady((ctx) => {
            this.navStack = ctx.pathStack
        })
    }
}