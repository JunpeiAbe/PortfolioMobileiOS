import Network

enum NetworkProtocolType {
    case tcp
    case udp

    var parameters: NWParameters {
        switch self {
        case .tcp:
            return .tcp
        case .udp:
            return .udp
        }
    }
}
