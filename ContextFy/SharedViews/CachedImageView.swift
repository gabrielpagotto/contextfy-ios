//
//  CachedImageView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 09/04/24.
//

import SwiftUI

struct CachedImageView: View {
    @State private var imageData: Data?
    
    let urlString: String
    let placeholderSystemName: String
    
    init(urlString: String, placeholderSystemName: String = "photo") {
        self.urlString = urlString
        self.placeholderSystemName = placeholderSystemName
    }

    var body: some View {
        HStack {
            if let idata = self.imageData, let uiImage = UIImage(data: idata) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image(systemName: placeholderSystemName)
                    .resizable()
                    .foregroundColor(.secondary)
            }
        }
        .onAppear { loadImage() }
    }

    private func loadImage() {
        guard let url = URL(string: urlString) else { return }
        
        if let cachedData = ImageCache.shared.cache.object(forKey: urlString as NSString) as Data? {
            self.imageData = cachedData
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil { return }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.imageData = data
                ImageCache.shared.cache.setObject(data as NSData, forKey: urlString as NSString)
            }
        }.resume()
    }
}

class ImageCache {
    static let shared = ImageCache()
    let cache = NSCache<NSString, NSData>()
    private init() {}
}
