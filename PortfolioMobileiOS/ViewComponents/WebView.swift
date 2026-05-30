import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    enum Source: Equatable {
        case remote(URL)
        case localFile(name: String, extension: String)
    }
    let source: Source
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        switch source {
        case .remote(let url):
            guard webView.url != url else {
                return
            }
            webView.load(URLRequest(url: url))
        case .localFile(let name, let fileExtension):
            guard let fileURL = Bundle.main.url(
                forResource: name,
                withExtension: fileExtension
            ) else {
                print("not url")
                return
            }
            print("HTML fileURL:", fileURL)
            webView.loadFileURL(
                fileURL,
                allowingReadAccessTo: fileURL.deletingLastPathComponent()
            )
        }
    }
}
