import Foundation

struct AppDependency {
    var makeSplashState: @MainActor () -> SplashScreenState
    var makeLoginState: @MainActor () -> LoginScreenState
    var makeRegisterState: @MainActor () -> RegisterScreenState
    var makeTermState: @MainActor () -> TermScreenState
    var makeHomeState: @MainActor () -> HomeScreenState
    var makeURLSessionClient: @MainActor () -> URLSessionAPIClient
    
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
        },
        makeHomeState: {
            HomeScreenState()
        },
        makeURLSessionClient: {
            StubResponseConfigurator.configure()
            return URLSessionAPIClient(
                session: .stub,
                configuration: .init(baseURL: URL(string: "https://debug-api.example.com")!)
            )
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
        },
        makeHomeState: {
            HomeScreenState()
        },
        makeURLSessionClient: {
            return URLSessionAPIClient(configuration: .init(baseURL: URL(string: "https://release-api.example.com")!))
        }
    )
}
