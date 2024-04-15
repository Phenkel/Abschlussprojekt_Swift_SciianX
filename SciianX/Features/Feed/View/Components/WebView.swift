//
//  WebView.swift
//  SciianX
//
//  Created by Philipp Henkel on 15.03.24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    WebView(url: URL(string: "https://sarunw.com/posts/swiftui-webview/")!)
}
