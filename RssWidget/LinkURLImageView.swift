//
//  LinkURLImageView.swift
//  RssWidgetExtension
//
//  Created by 若江照仁 on 2022/03/27.
//

import SwiftUI

struct LinkURLImageView: View {
    let url: URL
    let imageUrlString: String
    let isSyncURLImage: Bool

    init(url: URL, imageUrlString: String, isSyncURLImage: Bool = false) {
        self.url = url
        self.imageUrlString = imageUrlString
        self.isSyncURLImage = isSyncURLImage
    }

    var body: some View {
        Link(destination: url) {
            let imageViewModel = URLImageViewModel(url: imageUrlString, isSync: isSyncURLImage)
            URLImageView(viewModel: imageViewModel)
        }
    }
}
