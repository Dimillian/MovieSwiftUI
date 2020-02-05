//
//  MoviePostersCarouselView.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 23/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct ImagesCarouselView : View {
    let posters: [ImageData]
    @Binding var selectedPoster: ImageData?
    @State var innerSelectedPoster: ImageData?
    
    func computeCarouselPosterScale(width: CGFloat, itemX: CGFloat) -> CGFloat {
        let trueX = itemX - (width/2 - 200/2) - 100
        if trueX < -5 {
            return 1 - (abs(trueX) / width)
        }
        if trueX > 5 {
            return 1 - (trueX / width)
        }
        return 1
    }
    
    private func scrollView(reader: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(self.posters) { poster in
                    GeometryReader { reader2 in
                        BigMoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: poster.file_path,
                                                                                           size: .medium))
                            .scaleEffect(self.selectedPoster == nil ?
                                .zero :
                                self.computeCarouselPosterScale(width: reader.frame(in: .global).width,
                                                                itemX: reader2.frame(in: .global).midX),
                                         anchor: .center)
                            .onTapGesture {
                                withAnimation {
                                    self.innerSelectedPoster = poster
                                }
                        }
                    }.frame(width: 250, height: 375)
                }
            }
        }
        .disabled(self.innerSelectedPoster != nil)
        .scaleEffect(self.innerSelectedPoster != nil ? 0 : 1)
        .position(x: reader.frame(in: .global).midX,
                  y: reader.frame(in: .local).midY)
    }
    
    private func closeButton(reader: GeometryProxy) -> some View {
        Button(action: {
            self.selectedPoster = nil
        }) {
            Circle()
                .strokeBorder(Color.red, lineWidth: 1)
                .background(Image(systemName: "xmark").foregroundColor(.red))
                .frame(width: 50, height: 50)
            
        }
        .scaleEffect(self.innerSelectedPoster != nil ? 0 : 1)
        .position(x: reader.frame(in: .local).midX,
                  y: reader.frame(in: .local).maxY - 40)
    }
    
    private func selectedPoster(reader: GeometryProxy) -> some View {
        BigMoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: self.innerSelectedPoster!.file_path,
                                                                           size: .medium))
            .position(x: reader.frame(in: .local).midX,
                      y: reader.frame(in: .global).midY - 120)
            .scaleEffect(1.3)
            .onTapGesture {
                withAnimation {
                    self.innerSelectedPoster = nil
                }
        }
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .center) {
                self.scrollView(reader: reader)
                self.closeButton(reader: reader)
                
                if self.innerSelectedPoster != nil {
                    self.selectedPoster(reader: reader)
                }
            }
        }
    }
}

#if DEBUG
struct MoviePostersCarouselView_Previews : PreviewProvider {
    static var previews: some View {
        ImagesCarouselView(posters: [ImageData(aspect_ratio: 0.666666666666667,
                                                      file_path: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg",
                                                      height: 720,
                                                      width: 1280),
                                           ImageData(aspect_ratio: 0.666666666666667,
                                                      file_path: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg",
                                                      height: 720,
                                                      width: 1280),
                                           ImageData(aspect_ratio: 0.666666666666667,
                                                      file_path: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg",
                                                      height: 720,
                                                      width: 1280),
                                           ImageData(aspect_ratio: 0.666666666666667,
                                                      file_path: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg",
                                                      height: 720,
                                                      width: 1280)],
                                 selectedPoster: .constant(nil))
    }
}
#endif
