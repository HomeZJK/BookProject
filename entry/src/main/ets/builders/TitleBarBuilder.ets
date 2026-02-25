@Builder
export function TitleBarBuilder(title: ResourceStr, topPadding: number, bottomMargin: number,
    backClick?: () => void) {
    Row() {
        if (backClick) {
            Button({ type: ButtonType.Normal }) {
                Image($r("app.media.left_arrow"))
                    .width(25)
                    .height(25)
                    .fillColor("#000")
            }
            .width(30)
            .height(30)
            .backgroundColor(Color.Transparent)
            .onClick(backClick)
        } else {
            Blank()
                .height(18)
                .width(18)
        }

        Text(title)
            .fontSize(20)
            .fontColor("#FFF")
            .height(40)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })


        Blank()
            .height(30)
            .width(30)
    }
    .backgroundColor("#FFA666")
    .width("100%")
    .margin({ bottom: bottomMargin })
    .padding({ left: 11, right: 11, top: topPadding * 3 / 4 })
    .justifyContent(FlexAlign.SpaceBetween)

}