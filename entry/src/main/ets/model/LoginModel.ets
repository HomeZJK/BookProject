import { RequestUtil } from "../utils"
import { User } from "./entity"
import { Token } from "./entity/Token"

export default class LoginModel {
    private static instance = new LoginModel()
    private requestUtil: RequestUtil = RequestUtil.getInstance()

    private constructor() {
    }

    static getInstance() {
        return LoginModel.instance
    }

    async login(username: string, password: string) {
        const body: Record<string, string> = {
            "email": username,
            "password": password
        }
        const r = await this.requestUtil.post("/api/auth/login", {}, body)
        if (r && r.statusCode === 200) {
            return r.toJSON() as Token
        }
        return undefined
    }

    async logout() {
        const r = await this.requestUtil.post("/api/auth/logout", {})
        if (r && r.statusCode === 204) {
            return true
        }
        return false
    }

    async getUserDetails() {
        const r = await this.requestUtil.get("/api/user", {})
        if (r && r.statusCode === 200) {
            return r.toJSON() as User
        }
        return undefined
    }
}