/**用户表实体*/
export interface User {
    /**自增长主键ID*/
    id: number
    /**昵称*/
    name: string
    /**邮箱*/
    email: string
    /**手机*/
    phone?: string
    /**头像*/
    avatar?: string
    /**用户禁用状态: 0正常 1禁用*/
    is_locked?: number
    /**邮箱认证时间*/
    password_verified?: Date
    /**记住我token*/
    remember_token?: string
    /**添加时间*/
    created_at?: Date
    /**修改时间*/
    updated_at?: Date
}
