import Foundation

struct ScreenDependency {
    var makeSplashState: @MainActor () -> SplashScreenState
    var makeLoginState: @MainActor () -> LoginScreenState
    var makeRegisterState: @MainActor () -> RegisterScreenState
    var makeTermState: @MainActor () -> TermScreenState
    
    static let debug: Self = .init(
        makeSplashState: {
            SplashScreenState()
        },
        makeLoginState: {
            LoginScreenState()
        },
        makeRegisterState: {
            RegisterScreenState()
        },
        makeTermState: {
            TermScreenState()
        }
    )
    
    static let release: Self = .init(
        makeSplashState: {
            SplashScreenState()
        },
        makeLoginState: {
            LoginScreenState()
        },
        makeRegisterState: {
            RegisterScreenState()
        },
        makeTermState: {
            TermScreenState()
        }
    )
}
