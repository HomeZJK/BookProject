import { TitleBarBuilder } from '../builders'


@Builder
export function AboutUsBuilder() {
    AboutUs()
}

// 关于我们
@Component
struct AboutUs {
    navStack?: NavPathStack = undefined
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0

    build() {
        NavDestination() {
            TitleBarBuilder("关于我们", this.topArea, 0, () => {
                this.navStack?.pop()
            })

            Column() {
                Image($r("app.media.ewshop_logo"))
                    .width("90%")
            }
            .width("100%")
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)

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