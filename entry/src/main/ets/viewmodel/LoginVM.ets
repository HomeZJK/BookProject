import LoginModel from "../model/LoginModel"

export class LoginVM {
    private static instance: LoginVM = new LoginVM()
    private loginModel = LoginModel.getInstance()

    private constructor() {
    }

    static getInstance() {
        return LoginVM.instance
    }

    async login(username: string, password: string) {
        return await this.loginModel.login(username, password)
    }

    async logout() {
        return await this.loginModel.logout()
    }

    async getUserDetails() {
        return await this.loginModel.getUserDetails()
    }
}