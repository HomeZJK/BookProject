/**订单详情表实体*/
export interface OrderDetails {
    /**自增长主键ID*/
    id: number
    /**所属订单*/
    orderId: number
    /**商品*/
    goodsId: number
    /**商品的价格*/
    price: number
    /**商品的数量*/
    num: number
    /**添加时间*/
    createdAt?: Date
    /**修改时间*/
    updatedAt?: Date
}
