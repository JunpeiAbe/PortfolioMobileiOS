import Foundation
import Testing
@testable import PortfolioMobileiOS

@MainActor
@Suite("Stores", .serialized)
struct StoreTests {
    // Login・Register・RefreshがRepository結果を保持しメールアドレスを保存することを検証する。
    @Test func authenticationStoreSessionFlows() async throws {
        let authentication = AuthenticationRepositorySpy()
        let terms = AgreeTermRepositorySpy()
        let defaults = UserDefaultsClientSpy()
        let keychain = KeychainClientSpy()
        let store = DefaultAuthenticationStore(authenticationRepository: authentication, agreeTermRepository: terms, userDefaultClient: defaults, keychainClient: keychain)
        try await store.login(mailAddress: "login@example.com", password: "Abcdef1!")
        #expect(store.isLoggedIn)
        #expect(keychain.storage[.mailAddress] == "login@example.com")
        try await store.register(mailAddress: "register@example.com", password: "Abcdef1!")
        #expect(keychain.storage[.mailAddress] == "register@example.com")
        try await store.tokenRefresh(refreshToken: "old-refresh")
        #expect(authentication.refreshArguments == ["old-refresh"])
    }

    // Token・メール・Terminal IDの読み取りと生成を検証する。
    @Test func authenticationStorePersistenceProperties() {
        let keychain = KeychainClientSpy()
        keychain.storage = [.accessToken: "access", .refreshToken: "refresh", .mailAddress: "mail"]
        let defaults = UserDefaultsClientSpy()
        defaults.strings[.terminalID] = "terminal"
        let store = DefaultAuthenticationStore(authenticationRepository: AuthenticationRepositorySpy(), agreeTermRepository: AgreeTermRepositorySpy(), userDefaultClient: defaults, keychainClient: keychain)
        #expect(store.accessToken == "access")
        #expect(store.refreshToken == "refresh")
        #expect(store.mailAddress == "mail")
        #expect(store.terminalID == "terminal")
        store.saveTerminalID()
        #expect(defaults.strings[.terminalID]?.isEmpty == false)
    }

    // 利用規約同意とLogoutを各Repositoryへ委譲することを検証する。
    @Test func authenticationStoreDelegation() async throws {
        let authentication = AuthenticationRepositorySpy()
        let terms = AgreeTermRepositorySpy()
        let store = DefaultAuthenticationStore(authenticationRepository: authentication, agreeTermRepository: terms, userDefaultClient: UserDefaultsClientSpy(), keychainClient: KeychainClientSpy())
        try await store.agreeTerm(termsVersion: "1.0.0")
        try await store.logout()
        #expect(terms.versions == ["1.0.0"])
        #expect(authentication.logoutCallCount == 1)
    }

    // アプリ情報取得後にメンテナンス状態と最低バージョンを公開することを検証する。
    @Test func appInformationStore() async throws {
        let repository = AppInformationRepositorySpy()
        repository.information = .init(isMaintenance: true, iOSMinAppVersion: "99.0.0", appTermURL: nil, appTermVersion: nil, qaURL: nil)
        let store = DefaultAppInformationStore(appInformationRepository: repository)
        try await store.fetchAppInformation()
        #expect(store.isMaintenance)
        #expect(store.latestAppVersion == AppVersion(value: "99.0.0"))
        #expect(store.needsForceUpdate)
    }

    // Notice Storeが初回取得で置換し、追加取得でappendしてcursorを更新することを検証する。
    @Test func noticeStorePagination() async throws {
        let repository = NoticeRepositorySpy()
        repository.responses = [([TestFixtures.notice("1")], "next"), ([TestFixtures.notice("2")], nil)]
        let store = DefaultNoticeStore(noticeRepository: repository)
        try await store.fetchNotices()
        try await store.loadMore(nextCursor: "next")
        #expect(store.notices.map(\.id) == ["1", "2"])
        #expect(store.nextCursor == nil)
        #expect(repository.cursors.count == 2)
        #expect(repository.cursors[0] == nil)
        #expect(repository.cursors[1] == "next")
    }

    // Feature Storeが初回取得と追加取得を行い、選択Featureを保持することを検証する。
    @Test func featureStorePaginationAndSelection() async throws {
        let repository = FeaturesRepositorySpy()
        repository.responses = [([TestFixtures.feature("1")], "next"), ([TestFixtures.feature("2")], nil)]
        let store = DefaultFeaturesStore(featuresRepository: repository)
        try await store.fetchFeatures()
        try await store.loadMore(nextCursor: "next")
        store.selectedFeature = store.features.last
        #expect(store.features.map(\.id) == ["1", "2"])
        #expect(store.selectedFeature?.id == "2")
    }

    // Push Notification Storeが許可要求とToken登録をRepositoryへ委譲することを検証する。
    @Test func pushNotificationStore() async throws {
        let repository = PushNotificationRepositorySpy()
        let store = DefaultPushNotificationStore(pushNotificationRepository: repository)
        await store.requestAuthorization()
        try await store.registerToken(deviceID: "device")
        #expect(repository.authorizationCallCount == 1)
        #expect(repository.deviceIDs == ["device"])
    }
}
