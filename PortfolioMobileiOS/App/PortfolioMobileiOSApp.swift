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
#if DEBUG
            if let screenshotScreen = ScreenshotScreen.launchArgument {
                ScreenshotRootScreen(
                    screen: screenshotScreen,
                    dependency: dependency
                )
            } else {
                RootScreen(dependency: dependency)
            }
#else
            RootScreen(dependency: dependency)
#endif
        }
    }
}
