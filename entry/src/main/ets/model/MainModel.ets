import { RequestUtil } from "../utils";
import { GoodsData, OrderData } from "./entity";
import { GoodsDetails } from "./entity/GoodsDetails";
import { GoodsListType } from "./entity/GoodsListType";
import { HomeData } from "./entity/HomeData";
import { SortType } from "./entity/SortType";

export default class MainModel {
    private static instance: MainModel = new MainModel()
    private requestUtil: RequestUtil = RequestUtil.getInstance()

    private constructor() {
    }

    public static getInstance() {
        return MainModel.instance
    }

    async getMainData() {
        const r = await this.requestUtil.get(`/api/index`, {})
        if (r && r.statusCode === 200) {
            return r.toJSON() as HomeData
        }
        return undefined
    }

    async getHomeListsData(page: number, listType: GoodsListType) {
        const params: Record<string, string> = {}
        params["page"] = page.toString()
        params[listType] = "1"
        const r = await this.requestUtil.get(`/api/index`, params)
        if (r && r.statusCode === 200) {
            return (r.toJSON() as HomeData).goods.data ?? []
        }
        return []
    }

    async getCategoriesListData(page: number, categoryID: number, sortType: SortType) {
        const params: Record<string, string> = {}
        params["page"] = page.toString()
        params["category_id"] = categoryID.toString()
        params[sortType] = "1"
        const r = await this.requestUtil.get(`/api/goods`, params)
        if (r && r.statusCode === 200) {
            return (r.toJSON() as HomeData).goods ?? { current_page: 1, data: [] }
        }
        return { current_page: 1, data: [] } as GoodsData
    }

    async getGoodsDetails(goodsId: number) {
        const r = await this.requestUtil.get(`/api/goods/${goodsId}`, {})
        if (r && r.statusCode === 200) {
            return r.toJSON() as GoodsDetails
        }
        return undefined
    }

    async collectGoods(id: number) {
        const r = await this.requestUtil.post(`/api/collects/goods/${id}`, {})
        if (r && r.statusCode === 201) {
            return 1
        } else if (r && r.statusCode === 204) {
            return 2
        }
        return 0
    }

    async getOrderData(page: number, status: number) {
        const params: Record<string, string> = {}
        params["page"] = page.toString()
        if (status !== 0) {
            params["status"] = status.toString()
        }
        params["include"] = "goods"
        const r = await this.requestUtil.get(`/api/orders`, params)
        if (r && r.statusCode === 200) {
            return (r.toJSON() as OrderData).data
        }
        return []
    }
}





