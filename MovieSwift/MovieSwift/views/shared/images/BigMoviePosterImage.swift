//
//  BigMoviePosterImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct BigMoviePosterImage : View {
    @State var imageLoader: ImageLoader
    @State var isImageLoaded = false
    
    var body: some View {
        ZStack(alignment: .center) {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 250, height: 375)
                    .cornerRadius(5)
                    .scaleEffect(self.isImageLoaded ? 1 : 0.6)
                    .opacity(self.isImageLoaded ? 1 : 0.1)
                    .shadow(radius: 8)
                    .animation(.spring())
                    .onAppear{
                        self.isImageLoaded = true
                }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 300)
                    .cornerRadius(5)
                    .shadow(radius: 8)
                    .opacity(0.1)
            }
            }.onAppear {
                self.imageLoader.loadImage()
        }
    }
}
