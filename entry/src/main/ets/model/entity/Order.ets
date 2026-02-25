/**订单主表实体*/
export interface Order {
    /**自增长主键ID*/
    id: number
    /**下单的用户*/
    user_id: number
    /**订单单号*/
    order_no: string
    /**总金额*/
    amount: number
    /**收货地址*/
    address_id: number
    /**订单状态: 1下单 2支付 3发货 4收货 5过期*/
    status?: number
    /**快递类型: SF YTO YD*/
    express_type?: string
    /**快递单号*/
    express_no?: string
    /**支付时间*/
    pay_time?: Date
    /**支付类型: 支付宝 微信*/
    pay_type?: string
    /**支付单号*/
    trade_no?: string
    /**添加时间*/
    created_at?: Date
    /**修改时间*/
    updated_at?: Date
}
