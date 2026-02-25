@Builder
export function LoadingBuilder() {
    Column() {
        Text("加载中...")
            .fontSize(25)
            .fontColor(Color.Green)
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#EEEEEE")
    .justifyContent(FlexAlign.Center)
}