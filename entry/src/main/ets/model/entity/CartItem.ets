import { Goods } from "."

/**购物车表实体*/
export interface CartItem {
    /** 自增长主键ID */
    id: number
    /** 用户ID */
    user_id: number
    /** 商品ID */
    goods_id: number
    /** 商品数量 */
    num: number
    /** 是否选择: 0不选 1选中 */
    is_checked?: number // 默认值 1
    /** 添加时间 */
    created_at?: Date
    /** 修改时间 */
    updated_at?: Date
    goods?: Goods
}
