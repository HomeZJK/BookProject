import { TitleBarBuilder } from '../builders'
import { ReqLoadingDialog } from '../components'
import { LoginVM } from '../viewmodel/LoginVM'


@Builder
export function LoginBuilder() {
    Login()
}


// 登录
@Entry
@Component
struct Login {
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    @State username: string = ""
    @State password: string = ""
    @State isShowOverlay: [boolean, boolean] = [false, false]
    private navStack?: NavPathStack = undefined
    private loginVM = LoginVM.getInstance()
    private dialog = new CustomDialogController({
        builder: ReqLoadingDialog(),
        customStyle: true,
        alignment: DialogAlignment.Center
    })

    @Builder
    LoginTextInputBuilder(title: string, placeholder: string, type: InputType) {
        Column() {
            Row() {
                Text(title)
                    .fontColor("#646566")
                    .fontSize(16)
                    .textAlign(TextAlign.Start)
                    .layoutWeight(1)


                TextInput({ placeholder: placeholder, text: type === InputType.Email ? this.username : this.password })
                    .backgroundColor(Color.Transparent)
                    .placeholderFont({ size: 16 })
                    .placeholderColor("#BBBBBB")
                    .type(type)
                    .showPasswordIcon(false)
                    .borderRadius(0)
                    .layoutWeight(3)
                    .padding({ left: 0 })
                    .overlay(this.OverlayBuilder(title, type),
                        { align: Alignment.BottomStart, offset: { x: 0, y: 8 } })
                    .onChange((value: string) => {
                        if (type === InputType.Email) {
                            this.username = value
                            this.isShowOverlay[0] = value ? false : true
                        } else if (type === InputType.Password) {
                            this.password = value
                            this.isShowOverlay[1] = value ? false : true
                        }
                    })
                    .onEditChange((isEdit) => {
                        if (!isEdit) {
                            if (type === InputType.Email) {
                                this.isShowOverlay[0] = this.username ? false : true
                            } else if (type === InputType.Password) {
                                this.isShowOverlay[1] = this.password ? false : true
                            }
                        }
                    })
            }
            .width("100%")
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ bottom: 10 })

            Line()
                .width("100%")
                .height(1)
                .backgroundColor("#F5F5F7")
        }
        .margin({ bottom: 25 })
    }

    @Builder
    OverlayBuilder(title: string, type: InputType) {
        if (type === InputType.Email && this.isShowOverlay[0]) {
            Text(`请填写${title}`)
                .fontColor("#EE0A24")
                .fontSize(12)
        } else if (type === InputType.Password && this.isShowOverlay[1]) {
            Text(`请填写${title}`)
                .fontColor("#EE0A24")
                .fontSize(12)
        } else {
        }
    }

    build() {
        NavDestination() {
            TitleBarBuilder("用户登录", this.topArea, 0, () => {
                this.navStack?.pop()
            })

            Column() {
                Image($r("app.media.ewshop_logo"))
                    .width("50%")
                    .margin({ top: 50, bottom: 50 })
                this.LoginTextInputBuilder("用户名", "用户名", InputType.Email)
                this.LoginTextInputBuilder("密码", "密码", InputType.Password)
                Text("没有账号，立即注册")
                    .fontColor("#FF6A00")
                    .alignSelf(ItemAlign.Start)
                    .margin({ bottom: 25 })

                Button("提交")
                    .width("100%")
                    .height(50)
                    .borderRadius(25)
                    .backgroundColor("#FF6A00")
                    .onClick(async () => {
                        if (!this.username) {
                            this.isShowOverlay[0] = true
                        }
                        if (!this.password) {
                            this.isShowOverlay[1] = true
                        }
                        if (this.username && this.password) {
                            this.dialog.open()
                            const token = await this.loginVM.login(this.username, this.password)
                            if (token) {
                                AppStorage.set("token", token.access_token)
                                try {
                                    this.getUIContext()
                                        .getPromptAction()
                                        .showToast({ message: "登录成功" })
                                } catch (error) {
                                }
                                this.navStack?.clear()
                            } else {
                                try {
                                    this.getUIContext()
                                        .getPromptAction()
                                        .showToast({ message: "登录失败，账号或密码有误" })
                                } catch (error) {
                                }
                            }
                            this.dialog.close()
                        }
                    })
            }
            .padding({ right: 15, left: 15 })

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