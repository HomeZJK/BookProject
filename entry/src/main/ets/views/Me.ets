import { TitleBarBuilder } from "../builders"
import { emitter } from "@kit.BasicServicesKit"
import { User } from "../model/entity"
import { LoginVM } from "../viewmodel"

@Component
export struct Me {
    @Consume("navStack") navStack: NavPathStack
    @Prop topArea: number = 0
    @State userDetails?: User = undefined
    private loginVM = LoginVM.getInstance()
    private settingItems: SettingItem[] = [
        { title: "我的订单", router: "MyOrder" },
        { title: "我的收藏", router: "MyFavorite" },
        { title: "账号管理", router: "Setting" },
        { title: "地址管理", router: "AddressManagement" },
        { title: "关于我们", router: "AboutUs" }
    ]

    async aboutToAppear() {
        this.userDetails = await this.loginVM.getUserDetails()
    }

    @Builder
    SettingItemBuilder(title: string, router: string) {
        Row() {
            Text(title)
                .fontSize(17)
            Blank()
            Image($r("app.media.right_arrow1"))
                .width(16)
                .height(16)
                .fillColor("#000")
        }
        .width("100%")
        .backgroundColor("#FFF")
        .padding({
            left: 5,
            right: 5,
            top: 10,
            bottom: 10
        })
        .margin({ bottom: 10 })
        .borderRadius(3)
        .border({ width: { bottom: 1 }, color: "#EFF0F2" })
        .onClick(() => {
            this.navStack.pushPath({ name: router })
        })
    }

    build() {
        Column() {
            TitleBarBuilder("我的", this.topArea, 0)

            Column() {
                Row() {
                    Image($r("app.media.startIcon"))
                        .width(60)
                        .height(60)
                        .borderRadius("50%")
                        .border({ width: 1, color: "#FFF" })
                        .shadow({ radius: 4, color: "#FFF", offsetY: 2 })
                        .margin({ right: 20 })
                    Column() {
                        Text() {
                            Span("昵\u3000称：")
                            Span(this.userDetails?.name ?? "牢大")
                        }
                        .fontColor("#FFF")
                        .fontSize(17)

                        Text() {
                            Span("登录名：")
                            Span(this.userDetails?.email ?? "")
                        }
                        .fontColor("#FFF")
                        .margin({ top: 5, bottom: 5 })
                        .fontSize(17)

                        Text() {
                            Span("签\u3000名：")
                            Span("什么罐头我说")
                        }
                        .fontColor("#FFF")
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .fontSize(17)
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)
                }
                .width("100%")
                .height(115)
                .padding({ left: 10, right: 10 })
                .linearGradient({ colors: [["#EEEEF0", 0], ["#676869", 1]], direction: GradientDirection.Right })
                .borderRadius(5)
                .margin({ top: 10, bottom: 20 })

                ForEach(this.settingItems, (item: SettingItem) => {
                    this.SettingItemBuilder(item.title, item.router)
                }, (item: SettingItem) => {
                    return item.title
                })

                Button("退出登录")
                    .width("95%")
                    .height(45)
                    .borderRadius("50%")
                    .backgroundColor("#FF6A00")
                    .onClick(async () => {
                        const r = await this.loginVM.logout()
                        if (r) {
                            try {
                                this.getUIContext().getPromptAction().showToast({ message: "退出登录成功" })
                            } catch (error) {
                            }
                            AppStorage.set("token", "")
                            emitter.emit("resetPage")
                        } else {
                            try {
                                this.getUIContext().getPromptAction().showToast({ message: "退出登录失败" })
                            } catch (error) {
                            }
                        }
                    })

            }
            .padding({ left: 5, right: 5 })

        }
        .width("100%")
        .height("100%")
        .backgroundColor("#FCFCFC")
    }
}

interface SettingItem {
    title: string
    router: string
}