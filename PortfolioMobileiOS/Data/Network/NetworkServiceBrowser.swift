import Network

actor NetworkServiceBrowser {
    private var browser: NWBrowser?
    
    func browse(
        serviceType: String,
        protocolType: NetworkProtocolType
    ) -> AsyncThrowingStream<[NetworkService],Error> {
        AsyncThrowingStream { continuation in
            let browser: NWBrowser = .init(
                for: .bonjour(
                    type: serviceType,
                    domain: nil
                ),
                using: protocolType.parameters
            )
            browser.browseResultsChangedHandler = { results, _ in
                let services: [NetworkService] = results.map { result in
                    NetworkService(endpoint: result.endpoint)
                }
                continuation.yield(services)
            }
            
            browser.stateUpdateHandler = { state in
                switch state {
                case .setup:
                    break
                case .ready:
                    break
                case .waiting(let error):
                    continuation.yield(with: .failure(error))
                case .failed(let error):
                    continuation.finish(throwing: error)
                case .cancelled:
                    continuation.finish()
                default:
                    break
                }
            }
            
            browser.start(queue: .main)
            self.browser = browser
            continuation.onTermination = { [weak self]_ in
                // onTermination自体はActor上で実行されることが保証できないのでTaskを生成しActorに入り直す
                Task {
                    await self?.stopBrowse()
                }
            }
        }
    }
    
    func stopBrowse() {
        browser?.cancel()
        browser = nil
    }
}
