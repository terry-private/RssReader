//
//  URLImageView.swift
//  RssWidgetExtension
//
//  Created by 若江照仁 on 2022/03/27.
//

import SwiftUI

struct URLImageView: View {

    @ObservedObject var viewModel: URLImageViewModel

    var body: some View {
        if let imageData = self.viewModel.downloadData {
            if let image = UIImage(data: imageData) {
                return Image(uiImage: image).resizable().scaledToFit()
            } else {
                return Image(uiImage: UIImage()).resizable().scaledToFit()
            }
        } else {
            return Image(uiImage: UIImage()).resizable().scaledToFit()
        }
    }
}
