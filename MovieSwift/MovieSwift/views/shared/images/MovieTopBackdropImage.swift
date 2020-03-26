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
    @Binding var isExpanded: Bool
    
    var forceBlur: Bool = false
    var fill: Bool = false
    var height: CGFloat = 250
    
    private let threeshold: CGFloat = 50
    private let maxBlur: CGFloat = 100
    
    func blurFor(minY: CGFloat) -> CGFloat {
        if isExpanded {
            return 0
        }
        
        if threeshold - minY > maxBlur {
            return maxBlur
        }
        
        return threeshold - minY
    }
        
    var body: some View {
        Group {
            if self.imageLoader.image != nil {
                    GeometryReader { geometry in
                        Image(uiImage: self.imageLoader.image!)
                            .resizable()
                            .blur(radius: self.forceBlur ? 50 : self.blurFor(minY: geometry.frame(in: .global).minY),
                                  opaque: true)
                            .opacity(self.isImageLoaded ? 1 : 0)
                            .onAppear{
                                self.isImageLoaded = true
                            }.onTapGesture {
                                self.isExpanded.toggle()
                            }.if(self.isExpanded ||
                                self.blurFor(minY: geometry.frame(in: .global).minY) <= 0)
                            { image in
                                image.aspectRatio(contentMode: .fit)
                            }
                            .animation(.easeInOut)
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.1)
            }
        }.frame(maxHeight: fill ? 50 : height)
    }
}
