import { TitleBarBuilder } from '../builders'

@Builder
export function AddressEditBuilder() {
    AddressEdit()
}

// 地址编辑
@Component
struct AddressEdit {
    navStack?: NavPathStack = undefined
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    @State title: string = "新增地址"
    @State showSelectArea: boolean = false

    @Builder
    DividerBuilder() {
        Divider()
            .strokeWidth(2)
            .width("100%")
            .color("#F5F6F5")
    }

    @Builder
    SelectAreaBuilder() {
        Column() {
            Row() {
                Button("取消")
                // .type(ButtonType.Normal)
                    .backgroundColor(Color.Transparent)
                    .fontColor("#969799")
                    .onClick(() => {
                        this.showSelectArea = false
                    })

                Blank()

                Button("确认")
                // .type(ButtonType.Normal)
                    .backgroundColor(Color.Transparent)
                    .fontColor("#576B95")
                    .onClick(() => {
                        this.showSelectArea = false
                    })
            }
            .width("100%")
            .margin({ bottom: "10%" })

            TextPicker({
                range: ["北京", "天津", "河北", "山西", "内蒙古", "辽宁", "吉林", "黑龙江", "上海", "江苏", "浙江",
                    "安徽", "福建", "江西", "山东", "河南", "湖北", "湖南", "广东", "广西", "海南", "重庆", "四川",
                    "贵州", "云南", "西藏", "陕西", "甘肃", "青海", "宁夏", "新疆"]
            })
                .alignSelf(ItemAlign.Start)
                .canLoop(false)
                .textStyle({
                    color: "#A5A5A6",
                    font: {
                        size: 20
                    }
                })
                .selectedTextStyle({
                    color: "#323233",
                    font: {
                        size: 20
                    }
                })
        }
        .width("100%")
        .height("100%")
        .padding({ left: 16, right: 16 })

    }

    @Styles
    itemStyle(){
        .width("100%")
        .height("60")
        .padding(14)
    }

    build() {
        NavDestination() {
            TitleBarBuilder(this.title, this.topArea, 12, () => {
                this.navStack?.pop()
            })
            Column() {
                Row() {
                    Text("姓名\u3000\u3000")
                    TextInput({ placeholder: "姓名" })
                        .textInputStyle()
                }
                .itemStyle()


                this.DividerBuilder()

                Row() {
                    Text("电话\u3000\u3000")
                    TextInput({ placeholder: "电话" })
                        .textInputStyle()
                }
                .itemStyle()

                this.DividerBuilder()

                Row() {
                    Text("地区\u3000\u3000")

                    Text("地区")
                        .fontColor("#D4C9CC")
                        .margin({ left: 20 })

                    Blank()

                    SymbolGlyph($r("sys.symbol.chevron_right"))
                        .fontSize(25)
                        .fontColor(["#969799"])
                }
                .stateStyles({
                    clicked: {
                        .backgroundColor("#F2F3F5")
                    },
                    normal: {
                        .backgroundColor("")
                    }
                })
                .itemStyle()
                .onClick(() => {
                    this.showSelectArea = true
                })
                .bindSheet($$this.showSelectArea, this.SelectAreaBuilder(), {
                    height: "50%",
                    showClose: false
                })

                this.DividerBuilder()

                Column() {
                    Row() {
                        Text("详细地址")
                        TextInput({ placeholder: "详细地址" })
                            .textInputStyle()
                    }
                    .margin({ bottom: 30 })

                    Row() {
                        Text("设置为默认收货地址")
                        Toggle({ type: ToggleType.Switch })
                            .selectedColor("#FFA666")
                    }
                    .width("80%")
                    .justifyContent(FlexAlign.SpaceBetween)
                }
                .padding(14)


                this.DividerBuilder()

                Button("保存")
                    .width("100%")
                    .backgroundColor("#FFA666")

            }
            .layoutWeight(1)
            .padding({ left: 12, right: 12 })

        }
        .width("100%")
        .height("100%")
        .hideTitleBar(true)
        .onReady((ctx) => {
            this.navStack = ctx.pathStack
            this.title = "编辑地址"
        })

    }
}

@Extend(TextInput)
function textInputStyle() {
    .placeholderColor("#D4C9CC")
    .borderRadius(0)
    .padding({ top: 0, bottom: 0, left: 20 })
    .layoutWeight(1)
    .backgroundColor(Color.Transparent)
}