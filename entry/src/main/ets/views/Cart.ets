import { TitleBarBuilder } from "../builders"
import { ReqLoadingDialog } from "../components"
import { CartItem } from "../model/entity/CartItem"
import { CartVM } from "../viewmodel"
import { emitter } from "@kit.BasicServicesKit"

@Component
export struct Cart {
    @Consume("navStack") navStack: NavPathStack
    @Prop topArea: number = 0
    @Prop currentTabsIndex: number
    @State totalPrice: number = 0
    @State cartList: CartItem[] = []
    @State cartGoodsNum: Map<number, number> = new Map()
    @State isEditing: boolean = false
    @State isLoading: boolean = false
    @State changingNum: number = 1
    private cartVM: CartVM = CartVM.getInstance()
    private dialog = new CustomDialogController({
        builder: ReqLoadingDialog(),
        customStyle: true,
        alignment: DialogAlignment.Center
    })

    async aboutToAppear() {
        await this.refreshData()
        emitter.on("refreshCart", (data) => {
            if (this.currentTabsIndex === 2 || data.data?.["isTabs"]) {
                this.refreshData()
            }
        })
    }

    aboutToDisappear(): void {
        emitter.off("refreshCart")
    }

    async refreshData() {
        this.dialog.open()
        this.isLoading = true
        this.totalPrice = 0
        const data = (await this.cartVM.getCartListData()).data
        this.cartList = data
        data.forEach(item => {
            this.cartGoodsNum.set(item.id, item.num)
            if (item.goods && item.is_checked === 1) {
                this.totalPrice += item.goods.price * item.num
            }
        })
        setTimeout(() => {
            this.isLoading = false
            this.dialog.close()
        }, 100)
    }

    async changeCartNum(id: number, num: number) {
        const r =
            await this.cartVM.changeCartNum(id, num)
        if (!r) {
            this.showToast("修改失败")
            this.refreshData()
        } else {
            this.refreshData()
        }
    }

    showToast(msg: string) {
        try {
            this.getUIContext().getPromptAction().showToast({ message: msg })
        } catch (error) {
        }
    }

    @Styles
    buttonStyles(){
        .backgroundColor("#F2F3F5")
        .width(30)
        .height(30)
    }

    @Builder
    CartItemBuilder(item: CartItem) {
        Row() {
            Checkbox({ group: "cart" })
                .select(item.is_checked === 1)
                .onChange((selected) => {
                    if (!this.isLoading) {
                    }
                })

            Image($r("app.media.santi"))
                .layoutWeight(1)
                .onClick(() => {
                    this.navStack.pushPath({ name: "GoodsDetails", param: item.goods_id })
                })

            Column() {
                Row() {
                    Text(item.goods?.title ?? "")
                        .fontSize(18)
                    Blank()
                    Text() {
                        Span("x")
                        Span((item.goods?.stock ?? 1).toString())
                    }
                    .fontSize(18)
                }
                .width("100%")

                Row() {
                    Text() {
                        Span("￥")
                        Span(item.goods?.price.toFixed(2) ?? "0.00")
                    }
                    .fontSize(18)
                    .fontColor("#F00")

                    Blank()

                    Button({ type: ButtonType.Normal, stateEffect: (this.cartGoodsNum.get(item.id) ?? 1) <= 1 }) {
                        Text("-")
                            .fontSize(25)
                    }
                    .buttonStyles()
                    .opacity((this.cartGoodsNum.get(item.id) ?? 1) <= 1 ? 0.5 : 1)
                    .onClick(() => {
                        if (!this.isLoading) {
                            if (item.num <= 1) {
                                this.showToast("不能再减了")
                                return
                            } else {
                                const n = this.cartGoodsNum.get(item.id)
                                this.cartGoodsNum.set(item.id, n ? n - 1 : 1)
                            }
                        }
                    })

                    TextInput({ text: (this.cartGoodsNum.get(item.id) ?? 1).toString() })
                        .type(InputType.Number)
                        .height("100%")
                        .aspectRatio(1)
                        .padding(0)
                        .borderRadius(0)
                        .margin({ left: 3, right: 3 })
                        .height(30)
                        .width(30)
                        .textAlign(TextAlign.Center)
                        .onChange(async (text) => {
                            this.changingNum = parseInt(text)
                            if (this.changingNum >= 0) {
                                this.cartGoodsNum.set(item.id, this.changingNum)
                            }
                            if (!this.isEditing) {
                                if (this.changingNum <= 0 || Number.isNaN(this.changingNum)) {
                                    this.cartGoodsNum.set(item.id, item.num)
                                } else if (this.changingNum !== item.num && !this.isLoading) {
                                    await this.changeCartNum(item.id, this.changingNum)
                                }
                            }
                        })
                        .onEditChange(async (state) => {
                            this.isEditing = state
                            if (!state) {
                                if (this.changingNum <= 0 || Number.isNaN(this.changingNum)) {
                                    this.cartGoodsNum.set(item.id, item.num)
                                } else if (item.goods?.stock && this.changingNum > item.goods.stock) {
                                    this.cartGoodsNum.set(item.id, item.goods.stock)
                                }
                                if (this.cartGoodsNum.get(item.id) !== item.num) {
                                    this.changeCartNum(item.id, this.cartGoodsNum.get(item.id) ?? 1)
                                } else {
                                    this.cartGoodsNum.set(item.id, item.num)
                                }
                            }
                        })

                    Button({
                        type: ButtonType.Normal,
                        stateEffect: (this.cartGoodsNum.get(item.id) ?? 1) >= (item.goods?.stock ?? 999)
                    }) {
                        Text("+")
                            .fontSize(25)
                    }
                    .buttonStyles()
                    .opacity(item.goods?.stock && item.goods.stock <= (this.cartGoodsNum.get(item.id) ?? 1) ? 0.5 : 1)
                    .onClick(() => {
                        if (!this.isLoading) {
                            const n = this.cartGoodsNum.get(item.id)
                            if (item.goods?.stock && n && n >= item.goods.stock) {
                                this.showToast("不能再加了")
                            } else {
                                this.cartGoodsNum.set(item.id, n ? n + 1 : 1)
                            }
                        }
                    })

                }
                .width("100%")
            }
            .width("70%")
            .height("100%")
            .padding({
                left: 10,
                right: 10,
                top: 10,
                bottom: 10
            })
            .justifyContent(FlexAlign.SpaceBetween)
        }
        .width("100%")
        .backgroundColor("#FFF")
        .padding({
            left: 10,
            right: 10,
        })
        .height(90)
        .justifyContent(FlexAlign.SpaceBetween)
    }

    build() {
        Column() {
            if (this.cartList.length > 0 && !this.cartList.some(item => {
                return !item.goods
            })) {
                TitleBarBuilder(`购物车(${this.cartList.length})`, this.topArea, 0)
            } else {
                TitleBarBuilder("购物车", this.topArea, 0)
            }

            Column() {
                if (this.cartList.length > 0 && !this.cartList.some(item => {
                    return !item.goods
                })) {
                    List({ space: 5 }) {
                        ForEach(this.cartList, (item: CartItem) => {
                            ListItem() {
                                this.CartItemBuilder(item)
                            }
                        }, (item: CartItem, index) => {
                            return `${JSON.stringify(item)}${index}`
                        })
                    }
                    .width("100%")
                    .height("100%")
                    .flexShrink(1)
                } else {
                    Column() {
                        Image($r("app.media.empty_car"))
                            .width("50%")
                        Text("购物车空空如也")
                            .margin({ top: 20, bottom: 20 })
                        Button("前往选购")
                            .backgroundColor("#1BAEAE")
                            .width("50%")
                            .onClick(() => {
                            })
                    }
                    .justifyContent(FlexAlign.Center)
                    .width("100%")
                    .height("100%")
                    .flexShrink(1)
                }

                Row() {
                    CheckboxGroup({ group: "cart" })
                        .onChange(() => {
                            if (!this.isLoading) {
                            }
                        })
                    Text("全选")
                        .fontSize(18)

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
                    .fontSize(18)
                    .fontColor("#EE0A24")
                    .margin({ right: 10 })

                    Button() {
                        Text("结算")
                            .fontSize(17)
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
                    .onClick(() => {
                        this.navStack.pushPath({ name: "OrderPreview" })
                    })
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

        }
        .width("100%")
        .height("100%")
    }
}