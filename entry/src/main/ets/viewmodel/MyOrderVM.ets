import MainModel from "../model/MainModel"

export class MyOrderVM {
    private static instance = new MyOrderVM()
    private mainModel = MainModel.getInstance()

    private constructor() {
    }

    static getInstance() {
        return MyOrderVM.instance
    }

    async getOrderData(page: number, status: number) {
        return await this.mainModel.getOrderData(page, status)
    }
}