//
//  AuthWebView.swift
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

class AuthWebUIViewController: UIViewController {
    let onResult: (_ result: AuthResult) -> Void
    let authURL: String
    
    init(authURL: String, onResult: @escaping (_: AuthResult) -> Void) {
        self.onResult = onResult
        self.authURL = authURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: self.authURL)!))
        view = webView
    }
}

extension AuthWebUIViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        if url.absoluteString.contains("callback?access_token=") {
            
            let script = """
                (function() {
                    var body = document.body.innerText;
                    return body;
                })();
            """
            
            webView.evaluateJavaScript(script) { (result, error) in
                if let jsonString = result as? String {
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]
                            if let accessToken = jsonObject?["access_token"] as? String {
                                self.onResult(AuthResult(accessToken: accessToken))
                            }
                        } catch {
                            print("Erro ao parsear JSON: \(error)")
                        }
                    }
                } else if let error = error {
                    print("Erro ao executar script: \(error)")
                }
            }
        }
    }
}

struct AuthWebView: UIViewControllerRepresentable {
    let authURL: String
    let onResult: (_ result: AuthResult) -> Void
    
    func makeUIViewController(context: Context) -> AuthWebUIViewController {
        return AuthWebUIViewController(authURL: authURL, onResult: onResult)
    }
    
    func updateUIViewController(_ uiViewController: AuthWebUIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = AuthWebUIViewController
}
