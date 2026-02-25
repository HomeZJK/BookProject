/**评论表实体*/
export interface Comments {
    /** 自增长主键ID */
    id: number
    /** 评论的用户 */
    user_id: number
    /** 所属订单 */
    order_id: number
    /** 所属商品 */
    goods_id: number
    /** 评论的内容 */
    content: string
    /** 评论的级别: 1好评 2中评 3差评 (默认 1) */
    rate?: number
    /** 评论星级： 0-5星 (默认 5) */
    star?: number
    /** 商家的回复 */
    reply?: string | null
    /** 多个评论图 (JSON 数组字符串或对象) */
    pics?: string | null
    /** 注册时间 */
    created_at?: Date | null
    /** 修改时间 */
    updated_at?: Date | null
}
