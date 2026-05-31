import SwiftUI

@main
struct PortfolioMobileiOSApp: App {
    
    private var dependency: ScreenDependency {
        #if DEBUG
        return .debug
        #elseif STAGING
        return .debug
        #else
        return .release
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen(dependency: dependency)
        }
    }
}
