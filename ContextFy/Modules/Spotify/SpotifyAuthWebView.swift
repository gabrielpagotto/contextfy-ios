//
//  CustomWebView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import Foundation
import SwiftUI
import WebKit
import UIKit

struct AuthResult {
    let accessToken: String?
}

class SpotifyAuthWebUIViewController: UIViewController {
    let onResult: (_ result: AuthResult) -> Void
    let spotifyService: SpotifyService
    
    init(spotifyService: SpotifyService, onResult: @escaping (_: AuthResult) -> Void) {
        self.onResult = onResult
        self.spotifyService = spotifyService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        guard let urlRequest = spotifyService.getAccessTokenUrl() else {
            return
        }
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.load(urlRequest)
        view = webView
    }
}

extension SpotifyAuthWebUIViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        if url.absoluteString.starts(with: SpotifyConstants.redirectURI) {
            let accessToken = extractAccessToken(url)
            let authResult = AuthResult(accessToken: accessToken)
            onResult(authResult)
        }
    }
    
    func extractAccessToken(_ url: URL) -> String? {
        guard let fragment = URLComponents(url: url, resolvingAgainstBaseURL: false)?.fragment else { return nil }
        let components = fragment.components(separatedBy: "&")
        for component in components {
            if component.hasPrefix("access_token=") {
                let accessCode = component.replacingOccurrences(of: "access_token=", with: "")
                return accessCode
            }
        }
        return nil
    }
}

struct SpotifyAuthWebView: UIViewControllerRepresentable {
    let spotifyService: SpotifyService
    let onResult: (_ result: AuthResult) -> Void
    
    func makeUIViewController(context: Context) -> SpotifyAuthWebUIViewController {
        return SpotifyAuthWebUIViewController(spotifyService: spotifyService, onResult: onResult)
    }
    
    func updateUIViewController(_ uiViewController: SpotifyAuthWebUIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = SpotifyAuthWebUIViewController
}
