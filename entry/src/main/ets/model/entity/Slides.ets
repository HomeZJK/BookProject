/**轮播图表实体*/
export interface Slides {
    /** 自增长主键ID */
    id: number
    /** 轮播图名称 */
    title: string
    /** 轮播图图片 */
    img: string
    /** 跳转连接 (可选) */
    url?: string
    /** 状态: 0禁用 1正常 (可选, 默认值 0) */
    status?: number
    /** 排序 (可选, 默认值 1) */
    seq?: number
    /** 添加时间 (可选) */
    createdAt?: Date
    /** 修改时间 (可选) */
    updatedAt?: Date
}
