@CustomDialog
export  struct ReqLoadingDialog {
    controller: CustomDialogController

    build() {
        Column({ space: 10 }) {
            LoadingProgress()
                .width(48)
                .height(48)
                .color("#FFF")

            Text("加载中...")
                .fontSize(14)
                .fontColor("#FFF")
        }
        .justifyContent(FlexAlign.Center)
        .width(120)
        .height(120)
        .backgroundColor("#4d000000")
        .borderRadius(20)
    }
}