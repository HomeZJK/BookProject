import { RequestUtil } from "../utils"
import { CartData } from "./entity"

export default class CartModel {
    private static instance = new CartModel()
    private requestUtil: RequestUtil = RequestUtil.getInstance()

    private constructor() {
    }

    static getInstance() {
        return CartModel.instance
    }

    async getCartListData() {
        const params: Record<string, string> = {}
        params["include"] = "goods"
        const r = await this.requestUtil.get(`/api/carts`, params)
        if (r) {
            if (r.statusCode === 200) {
                return r.toJSON() as CartData
            }
        }
        return { data: [] } as CartData
    }

    async changeCartNum(cartId: number, num: number) {
        const body: Record<string, number> = {
            "num": num
        }
        const r = await this.requestUtil.put(`/api/carts/${cartId}`, {}, body)
        if (r && r.statusCode === 204) {
            return true
        }
        return false
    }

    async addCart(id: number, num: number) {
        const body: Record<string, number> = {
            "goods_id": id,
            "num": num
        }
        const r = await this.requestUtil.post(`/api/carts`, {}, body)
        if (r && r.statusCode === 201) {
            return true
        }
        return false
    }
}