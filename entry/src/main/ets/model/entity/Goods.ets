/**商品表实体*/
export interface Goods {
    /** 自增长主键ID */
    id: number
    /** 创建者 */
    user_id: number
    /** 分类 */
    category_id: number
    /** 标题 */
    title: string
    /** 描述 */
    description: string
    /** 价格 */
    price: number
    /** 库存 */
    stock: number
    /** 封面图 */
    cover: string
    /** 小图集 */
    pics: string // json字符串
    /** 详情 */
    details: string
    collects_count?: number
    is_collect?: number
    /** 销量 */
    sales?: number // 可空，默认 0
    /** 是否上架 0不上架 1上架 */
    is_on?: number // 可空，默认 0
    /** 是否推荐 0不推荐 1推荐 */
    is_recommend?: number // 可空，默认 0
    /** 添加时间 */
    created_at?: Date
    /** 修改时间 */
    updated_at?: Date
}
