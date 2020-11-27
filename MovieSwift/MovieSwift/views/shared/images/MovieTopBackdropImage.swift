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
    var height: CGFloat = 220
          
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .blur(radius: 50, opaque: true)
                .opacity(isImageLoaded ? 1 : 0)
                .aspectRatio(contentMode: .fill)
                .overlay(Color.black.opacity(0.3))
                .frame(height: fill ? 50 : height)
                .onAppear{
                    isImageLoaded = true
                }
        } else {
            Rectangle()
                .foregroundColor(.gray)
                .opacity(0.1)
                .frame(height: fill ? 50 : height)
        }
    }
}
