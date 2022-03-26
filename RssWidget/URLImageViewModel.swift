//
//  URLImageViewModel.swift
//  RssWidgetExtension
//
//  Created by 若江照仁 on 2022/03/27.
//

import SwiftUI

final class URLImageViewModel: ObservableObject {

    @Published var downloadData: Data? = nil
    let url: String

    init(url: String, isSync: Bool = false) {
        self.url = url
        if isSync {
            self.downloadImageSync(url: self.url)
        } else {
            self.downloadImageAsync(url: self.url)
        }
    }

    func downloadImageAsync(url: String) {

        guard let imageURL = URL(string: url) else {
            return
        }

        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
        if let data = cache.cachedResponse(for: request)?.data {
            self.downloadData = data
        }else {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    self.downloadData = data
                }
            }
        }
    }

    func downloadImageSync(url: String) {

        guard let imageURL = URL(string: url) else {
            return
        }

        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
        if let data = cache.cachedResponse(for: request)?.data {
            self.downloadData = data
        }else {
            let data = try? Data(contentsOf: imageURL)
            self.downloadData = data
        }
    }
}
