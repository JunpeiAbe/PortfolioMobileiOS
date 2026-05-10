import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

