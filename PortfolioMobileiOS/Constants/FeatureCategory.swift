import Foundation
import SwiftUI

enum FeatureCategory: Int, Decodable, Hashable {
    case location = 0
    case swiftData = 1
    case camera = 2
    case deepLink = 3
    case map = 4
    case share = 5
    case serviceSearch = 6
    case webSocket = 7
    case bluetooth = 8
    case qrCodeRead = 9
    case widget = 10
    case pushNotification = 11
    case localNotification = 12
    case biometricAuth = 13
    case photoLibrary = 14
    case fileImport = 15
    case fileExport = 16
    case speechRecognition = 17
    case textRecognition = 18
    case networkMonitor = 19
    case appReview = 20
    case inAppBrowser = 21
    case unknown = 999
    
    var title: String {
        switch self {
        case .location:
            "Location"
        case .swiftData:
            "SwiftData"
        case .camera:
            "Camera"
        case .deepLink:
            "Deep Link"
        case .map:
            "Map"
        case .share:
            "Share"
        case .serviceSearch:
            "Service Search"
        case .webSocket:
            "WebSocket"
        case .bluetooth:
            "Bluetooth"
        case .qrCodeRead:
            "QR Code Read"
        case .widget:
            "Widget"
        case .pushNotification:
            "Push Notification"
        case .localNotification:
            "Local Notification"
        case .biometricAuth:
            "Biometric Auth"
        case .photoLibrary:
            "Photo Library"
        case .fileImport:
            "File Import"
        case .fileExport:
            "File Export"
        case .speechRecognition:
            "Speech Recognition"
        case .textRecognition:
            "Text Recognition"
        case .networkMonitor:
            "Network Monitor"
        case .appReview:
            "App Review"
        case .inAppBrowser:
            "In-App Browser"
        case .unknown:
            "Unknown"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .location:
            "location"
        case .swiftData:
            "externaldrive"
        case .camera:
            "camera"
        case .deepLink:
            "link"
        case .map:
            "map"
        case .share:
            "square.and.arrow.up"
        case .serviceSearch:
            "magnifyingglass"
        case .webSocket:
            "point.3.connected.trianglepath.dotted"
        case .bluetooth:
            "dot.radiowaves.left.and.right"
        case .qrCodeRead:
            "qrcode.viewfinder"
        case .widget:
            "square.grid.2x2"
        case .pushNotification:
            "bell.badge"
        case .localNotification:
            "bell"
        case .biometricAuth:
            "faceid"
        case .photoLibrary:
            "photo.on.rectangle"
        case .fileImport:
            "square.and.arrow.down"
        case .fileExport:
            "square.and.arrow.up"
        case .speechRecognition:
            "mic"
        case .textRecognition:
            "text.viewfinder"
        case .networkMonitor:
            "wifi"
        case .appReview:
            "star.bubble"
        case .inAppBrowser:
            "safari"
        case .unknown:
            "questionmark.circle"
        }
    }
}
