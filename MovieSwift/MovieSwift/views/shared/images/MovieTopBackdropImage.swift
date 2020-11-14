//
//  MovieBackdropImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MovieTopBackdropImage : View {
    @ObservedObject var imageLoader: ImageLoader
    @State var isImageLoaded = false
    
    var fill: Bool = false
    var height: CGFloat = 250
          
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .blur(radius: 50, opaque: true)
                    .opacity(isImageLoaded ? 1 : 0)
                    .onAppear{
                        isImageLoaded = true
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.1)
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(maxHeight: fill ? 50 : height)
        .animation(nil)
    }
}
