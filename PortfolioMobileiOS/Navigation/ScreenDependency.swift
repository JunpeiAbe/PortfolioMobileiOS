import Foundation

struct ScreenDependency {
    
    func makeSplashState() -> SplashScreenState {
        return SplashScreenState()
    }
    
    func makeLoginState() -> LoginScreenState {
        return LoginScreenState()
    }
    
    func makeRegisterState() -> RegisterScreenState {
        return RegisterScreenState()
    }
    
    func makeTermState() -> TermScreenState {
        return TermScreenState()
    }
}
