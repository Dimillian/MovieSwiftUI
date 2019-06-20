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
    @State var isImageLoaded = false
    
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 200, height: 300)
                    .cornerRadius(5)
                    .opacity(self.isImageLoaded ? 1 : 0.1)
                    .animation(.basic())
                    .onAppear{
                        self.isImageLoaded = true
                }
            } else if imageLoader.poster == nil {
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

