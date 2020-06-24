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
      
    var body: some View {
        Group {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .blur(radius: isExpanded ? 0 : 50, opaque: true)
                    .opacity(self.isImageLoaded ? 1 : 0)
                    .onAppear{
                        self.isImageLoaded = true
                    }.onTapGesture {
                        self.isExpanded.toggle()
                    }
                    .aspectRatio(contentMode: .fit)
                    .animation(.easeInOut)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.1)
            }
        }.frame(maxHeight: fill ? 50 : height)
    }
}
