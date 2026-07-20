import Foundation

enum TestError: Error, Equatable {
    case expected
}

@MainActor
func waitForTasks() async throws {
    try await Task.sleep(for: .milliseconds(100))
}
