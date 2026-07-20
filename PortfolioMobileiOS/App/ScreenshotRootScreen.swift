#if DEBUG
import SwiftUI

enum ScreenshotScreen: String {
    case splash
    case login
    case register
    case terms
    case features

    static var launchArgument: Self? {
        let arguments = ProcessInfo.processInfo.arguments
        guard let flagIndex = arguments.firstIndex(of: "-screenshot-screen") else {
            return nil
        }
        let valueIndex = arguments.index(after: flagIndex)
        guard arguments.indices.contains(valueIndex) else {
            return nil
        }
        return Self(rawValue: arguments[valueIndex])
    }
}

struct ScreenshotRootScreen: View {
    let screen: ScreenshotScreen
    private let screensBuilder: ScreensBuilder

    init(screen: ScreenshotScreen, dependency: AppDependency) {
        self.screen = screen
        var screenshotDependency = dependency
        let makeFeaturesState = dependency.makeFeaturesState
        screenshotDependency.makeFeaturesState = {
            let state = makeFeaturesState()
            state.features = Self.featureFixtures
            return state
        }
        self.screensBuilder = ScreensBuilder(dependency: screenshotDependency)

        var appRouter = screenshotDependency.appRouter
        if screen == .features {
            appRouter.selectedTab = .features
        }
    }

    var body: some View {
        NavigationStack {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        switch screen {
        case .splash:
            screenshotSplashScreen
        case .login:
            screensBuilder.loginScreen()
        case .register:
            screensBuilder.registerScreen()
        case .terms:
            screenshotTermScreen
        case .features:
            screensBuilder.mainScreen()
        }
    }

    private var screenshotSplashScreen: some View {
        HStack(alignment: .center, spacing: .zero) {
            Image(.appIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
        .screenBackground()
    }

    private var screenshotTermScreen: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("利用規約")
                        .font(.system(size: 24, weight: .bold))
                    Text("このページはレイアウト確認用のダミーコンテンツです。実際の利用規約ではありません。")
                    Text("第1条　本規約の目的")
                        .font(.system(size: 18, weight: .bold))
                    Text("本規約は、ユーザーが本アプリを利用する際の条件を定めるものです。ユーザーは、本アプリを利用することにより、本規約の内容を確認し、同意したものとみなされます。")
                    Text("第2条　定義")
                        .font(.system(size: 18, weight: .bold))
                    Text("本規約において使用する用語は、本アプリ内で定める意味を有するものとします。")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
            Divider()
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "square")
                        .font(.title)
                        .foregroundStyle(.gray)
                    Text("利用規約に同意する")
                        .bodyFont()
                }
                Button("Agree") {}
                    .buttonStyle(.filled(backgroundColor: .gray))
                    .headlineFont()
                    .frame(height: 48)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .background(Color.white.ignoresSafeArea(edges: .bottom))
        }
        .screenBackground()
    }

    private static let featureFixtures: [Feature] = [
        .init(id: "feature_location", title: "Location", category: .location),
        .init(id: "feature_swift_data", title: "SwiftData", category: .swiftData),
        .init(id: "feature_camera", title: "Camera", category: .camera),
        .init(id: "feature_deep_link", title: "Deep Link", category: .deepLink),
        .init(id: "feature_map", title: "Map", category: .map),
        .init(id: "feature_share", title: "Share", category: .share),
        .init(id: "feature_service_search", title: "Service Search", category: .serviceSearch),
        .init(id: "feature_web_socket", title: "WebSocket", category: .webSocket)
    ]
}
#endif
