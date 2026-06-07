import SwiftUI

@main
struct PortfolioMobileiOSApp: App {
    
    private var dependency: AppDependency {
        #if DEBUG
        return .debug()
        #elseif STAGING
        return .debug()
        #else
        return .release()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen(state: dependency.makeRootState())
        }
    }
}
