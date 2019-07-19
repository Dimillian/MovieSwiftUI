//
//  MovieBackdropImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieTopBackdropImage : View {
    @State var imageLoader: ImageLoader
    @State var isImageLoaded = false
    
    @Binding var isExpanded: Bool
    
    var forceBlur: Bool = false
    var fill: Bool = false
    var height: Length = 300
    
    private let threeshold: CGFloat = 50
    private let maxBlur: CGFloat = 100
    
    func blurFor(minY: CGFloat) -> Length {
        if isExpanded {
            return 0
        }
        
        if threeshold - minY > maxBlur {
            return maxBlur
        }
        
        return threeshold - minY
    }
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                ZStack {
                    GeometryReader { geometry in
                        Image(uiImage: self.imageLoader.image!)
                            .resizable()
                            .blur(radius: self.forceBlur ? 50 : self.blurFor(minY: geometry.frame(in: .global).minY),
                                  opaque: false)
                            .opacity(self.isImageLoaded ? 1 : 0)
                            .animation(.easeInOut)
                            .onAppear{
                                self.isImageLoaded = true
                            }.tapAction {
                                self.isExpanded.toggle()
                            }
                    }
                    }
                    .frame(maxHeight: fill ? 50 : height)
            } else {
                Rectangle()
                    .frame(maxHeight: fill ? 50 : height)
                    .foregroundColor(.gray)
                    .opacity(0.1)
            }
            }.onAppear {
                self.imageLoader.loadImage()
        }
    }
}
