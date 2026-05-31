import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
    
    var isLoading: Bool {
        switch self {
        case .loading: true
        case .idle, .loaded, .failed(_): false
        }
    }
}

