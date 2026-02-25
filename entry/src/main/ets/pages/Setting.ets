import { TitleBarBuilder } from '../builders'

@Builder
export function SettingBuilder() {
    Setting()
}

// 账号管理
@Component
struct Setting {
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    private navStack?: NavPathStack = undefined

    build() {
        NavDestination() {
            TitleBarBuilder("账号管理", this.topArea, 10, () => {
                this.navStack?.pop()
            })
        }
        .width("100%")
        .height("100%")
        .hideTitleBar(true)
        .padding({ bottom: this.bottomArea })
        .onReady((ctx) => {
            this.navStack = ctx.pathStack
        })
    }
}