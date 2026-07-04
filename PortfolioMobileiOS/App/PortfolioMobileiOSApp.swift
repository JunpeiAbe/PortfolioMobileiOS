import SwiftUI

@main
struct PortfolioMobileiOSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private var dependency: AppDependency {
        #if DEBUG
        return .debug()
        #elseif STAGING
        return .staging()
        #else
        return .release()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen(dependency: dependency)
        }
    }
}
