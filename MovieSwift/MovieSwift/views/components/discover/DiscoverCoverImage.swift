//
//  DiscoverCoverImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct DiscoverPosterStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .aspectRatio(0.66, contentMode: .fit)
            .frame(maxWidth: UIApplication.shared.windows.first!.bounds.width * 0.65,
                   maxHeight: UIApplication.shared.windows.first!.bounds.height * 0.65)
            .cornerRadius(5)
    }
}

extension View {
    func discoverPosterStyle() -> some View {
        return Modified(content: self, modifier: DiscoverPosterStyle())
    }
}

struct DiscoverCoverImage : View {
    @State var imageLoader: ImageLoader
    
    var cachedImage: UIImage? {
        if let poster = imageLoader.path {
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
                    .discoverPosterStyle()
            } else if imageLoader.missing == true {
                Rectangle()
                    .foregroundColor(.gray)
                    .discoverPosterStyle()
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

