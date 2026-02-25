/**收货地址表 - 接口定义*/
export interface Address {
    /** 自增长主键ID */
    id: number
    /** 用户ID */
    user_id: number
    /** 收货人 */
    name: string
    /** 省份 */
    province: string
    /** 城市 */
    city: string
    /** 区县 */
    county: string
    /** 详细地址 */
    address: string
    /** 手机号 */
    phone: string
    /** 是否是默认地址: 0不是默认 1是默认 (可为 null，默认 0) */
    is_default?: number | null
    /** 添加时间 (可为 null) */
    created_at?: Date | null
    /** 修改时间 (可为 null) */
    updated_at?: Date | null
}
