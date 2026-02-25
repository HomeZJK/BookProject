import { Category, Goods } from "."

export interface HomeData {
    categories?: Category[]
    goods: GoodsData
}

export interface GoodsData {
    current_page: number
    data: Goods[]
}