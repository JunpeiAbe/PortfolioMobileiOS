import Foundation

enum KeychainError: Error {
    case invalidData
    case unhandledStatus(OSStatus)
}
