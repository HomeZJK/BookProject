import { TitleBarBuilder } from '../builders'
import { emitter } from '@kit.BasicServicesKit'

@Builder
export function OrderPreviewBuilder() {
    OrderPreview()
}

// 订单预览
@Component
struct OrderPreview {
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    @State totalPrice: number = 0
    private navStack?: NavPathStack = undefined

    @Builder
    ProductItemBuilder() {
        Row() {
            Image($r("app.media.santi"))
                .width(100)
                .height(100)

            Column() {
                Row() {
                    Text("《Java从入门到入土》")
                        .fontSize(17)

                    Text() {
                        Span("x")
                        Span("1")
                    }
                    .fontSize(17)
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width("100%")

                Text() {
                    Span("￥")
                    Span("99.9")
                }
                .fontSize(17)
                .fontColor("#F00")
            }
            .width("100%")
            .flexShrink(1)
            .padding(10)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
            .height(100)
        }
        .width("100%")
        .padding(10)
        .backgroundColor("#FFF")
    }

    build() {
        NavDestination() {
            TitleBarBuilder("订单预览", this.topArea, 10, () => {
                this.navStack?.pop()
                emitter.emit("refreshCart")
            })
            Column() {
                Scroll() {
                    Column() {
                        Row() {
                            Column() {
                                Text("ikun 114514")
                                    .margin({ bottom: 10 })

                                Text("yufjftjtrhcxthrdthxth")
                            }
                            .alignItems(HorizontalAlign.Start)

                            Image($r("app.media.right_arrow1"))
                                .height(20)
                        }
                        .width("100%")
                        .justifyContent(FlexAlign.SpaceBetween)
                        .padding(15)

                        Divider()
                            .strokeWidth(2)
                            .color("#1989FA")
                            .margin({ top: 5, bottom: 15 })

                        Column() {
                            ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], (item: number) => {
                                this.ProductItemBuilder()
                            }, (item: number) => {
                                return item + ""
                            })
                        }
                        .width("100%")
                    }

                }
                .flexShrink(1)

                Row() {
                    Text("商品金额")
                    Blank()
                    Text() {
                        Span("合计: ")
                            .fontColor("000")
                        Span("￥")
                            .fontSize(14)
                        Span(Math.floor(this.totalPrice).toString())
                            .fontSize(22)
                        Span(`.${this.totalPrice.toFixed(2).split(".")[1]}`)
                            .fontSize(14)
                    }
                    .fontSize(17)
                    .fontColor("#EE0A24")
                    .margin({ right: 10 })

                    Button() {
                        Text("生成订单")
                            .fontColor("#FFF")
                            .fontWeight(700)
                    }
                    .linearGradient({
                        colors: [["#E46B43", 0], ["#EE0A24", 1]],
                        direction: GradientDirection.Right
                    })
                    .width(100)
                    .borderRadius("50%")
                    .height(40)
                }
                .width("100%")
                .padding({
                    left: 10,
                    right: 10,
                    bottom: 2
                })
            }
            .width("100%")
            .layoutWeight(1)
            .backgroundColor("#F9F9F9")
        }
        .width("100%")
        .height("100%")
        .padding({ bottom: this.bottomArea })
        .hideTitleBar(true)
        .onReady((ctx) => {
            this.navStack = ctx.pathStack
        })
        .onBackPressed(() => {
            emitter.emit("refreshCart")
            return false
        })

    }
}