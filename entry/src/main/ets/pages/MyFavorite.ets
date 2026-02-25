import { TitleBarBuilder } from '../builders'

@Builder
export function MyFavoriteBuilder() {
    MyFavorite()
}

// 我的收藏
@Component
struct MyFavorite {
    navStack?: NavPathStack = undefined
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    @State myFavorite: number[] = [1]

    @Builder
    OverlayContentBuilder() {
        Text("特价")
            .fontColor("#FFF")
            .fontSize(14)
            .lineHeight(20)
            .height(20)
            .width(36)
            .padding({ left: 3, right: 3 })
            .backgroundColor("#EE0A24")
            .borderRadius({ topRight: "50%", bottomRight: "50%" })
    }

    @Builder
    FavoriteItemBuilder() {
        Row() {
            Image($r("app.media.santi"))
                .width(90)
                .height(90)
                .margin({ right: 10 })
                .overlay(this.OverlayContentBuilder(), { offset: { x: 0, y: 0 } })

            Column() {
                Text("《细说网页制作》")
                    .fontWeight(700)

                Text("前端/《细说网页制作》")
                    .fontSize(14)
                    .margin({ bottom: 8, top: 5 })

                Text() {
                    Span("￥")
                    Span("38.00")
                }
                .fontColor("#FF6A00")
                .fontSize(17)

                Row() {
                    Text() {
                        Span("收藏日期")
                        Span("2025-05-05")
                    }
                    .fontSize(14)

                    Blank()

                    Button({ type: ButtonType.Normal }) {
                        Text("取消收藏")
                            .fontColor("#969799")
                            .fontSize(15)
                            .margin({
                                left: 5,
                                right: 5,
                                top: 3,
                                bottom: 3
                            })
                    }
                    .backgroundColor("#F0F0F0")
                }
                .width("100%")

            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
        }
        .width("100%")
        .backgroundColor("#F7F8FA")
        .padding({
            left: 15,
            right: 15,
            bottom: 8,
            top: 8
        })
        .margin({ bottom: 10 })

    }

    build() {
        NavDestination() {
            TitleBarBuilder(`我的收藏(${this.myFavorite.length}件)`, this.topArea, 0, () => {
                this.navStack?.pop()
            })
            if (this.myFavorite.length <= 0) {
                Column() {
                    // Image($r("app.media.table"))

                    Text("还没有收藏的商品")
                        .fontColor("#969799")
                        .margin({ top: 200, bottom: 30 })

                    Button("去逛逛")
                        .backgroundColor("#EE0A24")
                        .width("40%")

                }
                .width("100%")
                .layoutWeight(1)
            } else {
                List() {
                    ForEach(Array(20).fill(0), (item: number) => {
                        ListItem() {
                            this.FavoriteItemBuilder()
                        }
                    })
                }
                .width("100%")
                .height("100%")
                .flexShrink(1)
            }

        }
        .width("100%")
        .height("100%")
        .padding({ bottom: this.bottomArea })
        .hideTitleBar(true)
        .onReady((ctx) => {
            this.navStack = ctx.pathStack
        })
    }
}