import { GoodsListType, SortType } from "../model/entity"
import MainModel from "../model/MainModel"

export class MainVM {
    private static instance = new MainVM()
    private mainModel = MainModel.getInstance()

    private constructor() {
    }

    static getInstance() {
        return MainVM.instance
    }

    async getHomeData() {
        const r = await this.mainModel.getMainData()
        return r?.goods.data ?? []
    }

    async getHomeListsData(page: number, listType: GoodsListType) {
        return await this.mainModel.getHomeListsData(page, listType)
    }

    async getCategories() {
        const r = await this.mainModel.getMainData()
        return r?.categories ?? []
    }

    async getCategoriesListData(page: number, categoryID: number, sortType: SortType) {
        return await this.mainModel.getCategoriesListData(page, categoryID, sortType)
    }
}