import CartModel from "../model/CartModel"
import MainModel from "../model/MainModel"

export class GoodsDetailsVM {
    private static instance = new GoodsDetailsVM()
    private mainModel = MainModel.getInstance()
    private cartModel = CartModel.getInstance()

    private constructor() {
    }

    static getInstance() {
        return GoodsDetailsVM.instance
    }

    async getGoodsDetails(id: number) {
        return await this.mainModel.getGoodsDetails(id)
    }

    async addCart(id: number, num: number) {
        return await this.cartModel.addCart(id, num)
    }

    async collectGoods(id: number) {
        return await this.mainModel.collectGoods(id)
    }
}