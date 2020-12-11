//
//  DiscoverCoverImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct DiscoverPosterStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(0.66, contentMode: .fit)
            .frame(maxWidth: 245)
            .cornerRadius(5)
    }
}

extension View {
    func discoverPosterStyle() -> some View {
        ModifiedContent(content: self, modifier: DiscoverPosterStyle())
    }
}

struct DiscoverCoverImage : View {
    @ObservedObject var imageLoader: ImageLoader
        
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.original)
                .discoverPosterStyle()
        } else if imageLoader.path == nil {
            Rectangle()
                .foregroundColor(.gray)
                .discoverPosterStyle()
        } else {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 50, height: 50)
        }
    }
}

