import { rcp } from "@kit.RemoteCommunicationKit";
import { emitter } from "@kit.BasicServicesKit";

export default class ReqInterceptor implements rcp.Interceptor {
    async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
        const ignoreAddress = [/\/api\/index/, /\/api\/goods/, /\/api\/auth\/login/]
        const r = ignoreAddress.some(item => item.test(context.request.url.toString()))
        console.log(`URL: ${context.request.url}`)
        console.log(`Pass: ${r}`)
        if (r) {
            return next.handle(context)
        }
        const token = AppStorage.get<string>("token")

        if (token) {
            const headers = context.request.headers
            if (headers) {
                headers["Authorization"] = `Bearer ${token}`
            } else {
                context.request.headers = { "Authorization": `Bearer ${token}` }
            }
            const resp = await next.handle(context)
            if (resp.statusCode === 401) {
                AppStorage.set("token", "")
                AppStorage.get<NavPathStack>("navStack")?.pushPath({ name: "Login" })
                emitter.emit("resetPage")
                return Promise.reject("请登录")
            }
            return resp
        } else {
            return Promise.reject("请登录")
        }
    }
}