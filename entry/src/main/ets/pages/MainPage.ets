import { Cart } from '../views/Cart'
import { Categories } from '../views/Categories'
import { Home } from '../views/Home'
import { Me } from '../views/Me'
import { emitter } from '@kit.BasicServicesKit'

// 主页
@Entry
@Component
struct MainPage {
    // 获取AppStorage中的安全区上下长度
    @StorageProp("topArea") topArea: number = 0
    @StorageProp("bottomArea") bottomArea: number = 0
    @State currentIndex: number = 0
    @State isHandlingNavigation: boolean = false
    // tabs控制器
    private tabsController: TabsController = new TabsController()
    // 导航栈
    @Provide("navStack") navStack: NavPathStack = new NavPathStack()

    aboutToAppear(): void {
        emitter.on("resetPage", (data) => {
            const index: number = data.data?.["index"] ?? 0
            if (index > 3) {
                this.tabsController.changeIndex(0)
                this.currentIndex = 0
            } else {
                this.tabsController.changeIndex(index)
                this.currentIndex = index
            }
        })
    }

    aboutToDisappear(): void {
        emitter.off("resetPage")
    }

    // 自定义底部导航栏项
    @Builder
    TabBarItemBuilder(title: string, icon: Resource, index: number) {
        Column() {
            Column() {
                SymbolGlyph(icon)
                    .fontSize(18)
                    .margin({ bottom: 3 })
                    .fontColor([index === this.currentIndex ? "#FF6A00" : ""])

                Text(title)
                    .fontSize(16)
                    .fontColor(index === this.currentIndex ? "#FF6A00" : "")
            }
            .height(55)
            .width("100%")
            .padding({ top: 5, bottom: 5 })
        }
        .backgroundColor("#F6F6F6")
        .padding({ bottom: this.bottomArea / 2 })
    }

    build() {
        Navigation(this.navStack) {
            Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
                TabContent() {
                    // 首页
                    Home({ topArea: this.topArea })
                }
                .tabBar(this.TabBarItemBuilder("首页", $r("sys.symbol.house"), 0))

                TabContent() {
                    // 分类
                    Categories({ topArea: this.topArea })
                }
                .tabBar(this.TabBarItemBuilder("分类", $r("sys.symbol.square_grid_2x2"), 1))

                TabContent() {
                    // 购物车
                    Cart({ topArea: this.topArea, currentTabsIndex: this.currentIndex })
                }
                .tabBar(this.TabBarItemBuilder("购物车", $r("sys.symbol.trash"), 2))

                TabContent() {
                    // 我的
                    Me({ topArea: this.topArea })
                }
                .tabBar(this.TabBarItemBuilder("我的", $r("sys.symbol.person"), 3))
            }
            .layoutWeight(1)
            .scrollable(false)
            .barHeight("auto")
            .onTabBarClick((index) => {
                this.tabsController.changeIndex(index)
                if (index === 2) {
                    emitter.emit("refreshCart", { data: { "isTabs": true } })
                }
            })
            .onAnimationEnd((index) => {
                // 当切换动画结束时改变当前索引
                this.currentIndex = index
            })
            // 拦截导航
            .onContentWillChange((_, comingIndex) => {
                const token = AppStorage.get<string>("token")
                if (comingIndex > 1 && !token) {
                    if (!this.isHandlingNavigation) {
                        this.isHandlingNavigation = true
                        try {
                            this.getUIContext().getPromptAction().showToast({ message: "请先登录" })
                        } catch (error) {
                        }
                        this.navStack.pushPath({ name: "Login" })
                    }
                    setTimeout(() => {
                        this.isHandlingNavigation = false
                    }, 500)
                    return false
                } else {
                    return true
                }
            })
        }
        .width("100%")
        .height("100%")
        .hideToolBar(true)
        .hideTitleBar(true)
    }
}