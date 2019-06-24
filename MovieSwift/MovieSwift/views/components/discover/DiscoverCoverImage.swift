//
//  DiscoverCoverImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct DiscoverCoverImage : View {
    @State var imageLoader: ImageLoader
    
    var cachedImage: UIImage? {
        if let poster = imageLoader.poster {
            return ImageService.shared.syncImageFromCache(poster: poster, size: imageLoader.size)
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            if cachedImage != nil || imageLoader.image != nil {
                Image(uiImage: cachedImage ?? self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 200, height: 300)
                    .cornerRadius(5)
            } else if imageLoader.missing == true {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 300)
                    .cornerRadius(5)
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 50, height: 50)
            }
            }.onAppear {
                self.imageLoader.loadImage()
        }
    }
}

