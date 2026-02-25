import CartModel from "../model/CartModel"

export class CartVM {
    private static instance: CartVM = new CartVM()
    private cartModel = CartModel.getInstance()

    private constructor() {
    }

    static getInstance(): CartVM {
        return CartVM.instance
    }

    async getCartListData() {
        return await this.cartModel.getCartListData()
    }

    async changeCartNum(cartId: number, num: number) {
        return await this.cartModel.changeCartNum(cartId, num)
    }
}