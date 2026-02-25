import { rcp } from '@kit.RemoteCommunicationKit'
import ReqInterceptor from './ReqInterceptor'

export class RequestUtil {
    private rcpSession?: rcp.Session = undefined
    private static instance: RequestUtil = new RequestUtil()

    private constructor() {
    }

    static getInstance() {
        return RequestUtil.instance
    }

    private async getSession() {
        if (!this.rcpSession) {
            try {
                this.rcpSession = rcp.createSession({
                    baseAddress: "https://api.shop.eduwork.cn",
                    interceptors: [new ReqInterceptor()]
                })
            } catch (error) {
            }
        }
    }

    async get(url: string, params: Record<string, string>) {
        await this.getSession()
        const queryString = this.getQueryString(params)
        const request: rcp.Request = new rcp.Request(url + queryString, "GET")
        let r: rcp.Response | undefined = undefined
        try {
            r = await this.rcpSession?.fetch(request)
        } catch (error) {
        }
        return r
    }

    async post(url: string, params: Record<string, string>, body?: object) {
        await this.getSession()
        const queryString = this.getQueryString(params)
        const request: rcp.Request = new rcp.Request(url + queryString, "POST", undefined, body)
        let r: rcp.Response | undefined = undefined
        try {
            r = await this.rcpSession?.fetch(request)
        } catch (error) {
        }
        return r
    }

    async put(url: string, params: Record<string, string>, body?: object) {
        await this.getSession()
        const queryString = this.getQueryString(params)
        const request: rcp.Request = new rcp.Request(url + queryString, "PUT", undefined, body)
        let r: rcp.Response | undefined = undefined
        try {
            r = await this.rcpSession?.fetch(request)
        } catch (error) {
        }
        return r
    }


    private getQueryString(params: Record<string, string>) {
        let queryString = Object.keys(params)
            .map(key => `${key}=${params[key]}`)
            .join("&")
        if (queryString) {
            queryString = "?" + queryString
        }
        return queryString
    }

    closeSession() {
        this.rcpSession?.close()
    }
}