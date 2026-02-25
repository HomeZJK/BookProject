import { TitleBarBuilder } from '../builders'

@Builder
export function AddressManagementBuilder() {
    AddressManagement()
}

// 地址管理
@Component
struct AddressManagement {
    navStack?: NavPathStack = undefined
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    addressInfos: AddressInfo[] = [
        {
            name: "张三",
            phone: "12345678901",
            province: "广东省",
            city: "深圳市",
            county: "宝安区",
            address: "深圳宝安大道",
            isDefault: true
        },
        {
            name: "李四",
            phone: "12345678901",
            province: "广东省",
            city: "深圳市",
            county: "宝安区",
            address: "深圳宝安大道",
            isDefault: false
        }
    ]

    @Builder
    AddressItemBuilder(addressInfo: AddressInfo) {
        Row() {
            Column() {
                Row() {
                    Text() {
                        Span(addressInfo.name)
                        Span("  ")
                        Span(addressInfo.phone)
                    }
                    .fontSize(19)

                    if (addressInfo.isDefault) {
                        Text("默认")
                            .fontSize(14)
                            .fontColor("#FFF")
                            .backgroundColor("#EE0A24")
                            .padding({
                                left: 5,
                                right: 5,
                                top: 2,
                                bottom: 2
                            })
                            .borderRadius("50%")
                            .margin({ left: 5 })
                    }
                }
                .margin({ bottom: 12 })


                Text() {
                    Span(addressInfo.province)
                    Span("  ")
                    Span(addressInfo.city)
                    Span("  ")
                    Span(addressInfo.county)
                    Span("  ")
                    Span(addressInfo.address)
                }
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .alignItems(HorizontalAlign.Start)

            SymbolGlyph($r("sys.symbol.square_and_pencil"))
                .fontSize(20)
                .onClick(() => {

                })
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(12)
    }

    build() {
        NavDestination() {
            TitleBarBuilder("地址管理", this.topArea, 12, () => {
                this.navStack?.pop()
            })
            Column() {
                if (this.addressInfos.length === 0) {
                    Text("您还没有添加地址哦")
                        .fontSize(18)
                        .fontColor("#A2A2A2")
                        .layoutWeight(1)
                } else {
                    List() {
                        ForEach(this.addressInfos, (addressInfo: AddressInfo) => {
                            this.AddressItemBuilder(addressInfo)
                        }, (item: AddressInfo, index: number) => {
                            return JSON.stringify(item) + index
                        })
                    }
                    .width("100%")
                    .height("100%")
                    .flexShrink(1)
                }

                Button("新增地址")
                    .width("100%")
                    .backgroundColor("#FFA666")
            }
            .width("100%")
            .layoutWeight(1)
            .padding({ left: 12, right: 12 })
        }
        .padding({ bottom: this.bottomArea })
        .hideTitleBar(true)
        .onReady((ctx) => {
            this.navStack = ctx.pathStack
        })
    }
}

interface AddressInfo {
    name: string
    phone: string
    province: string
    city: string
    county: string
    address: string
    isDefault: boolean
}
