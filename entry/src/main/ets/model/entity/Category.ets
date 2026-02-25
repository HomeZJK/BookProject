/**分类表实体*/
export interface Category {
    /** 自增长主键 ID */
    id: number
    /** 分类名称 */
    name: string
    /** 父级 ID，0 表示顶级分类 */
    pid?: number
    /** 状态: 0 禁用, 1 启用 */
    status?: number
    /** 分类级别: 1、2、3 */
    level?: number
    seq: number
    /** 分组: 'goods' 商品分组, 'menu' 菜单分组 */
    group?: string
    /** 添加时间 (时间戳) */
    createdAt?: Date
    /** 修改时间 (时间戳) */
    updatedAt?: Date
    children?: Category[]
}
