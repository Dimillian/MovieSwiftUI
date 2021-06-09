//
//  MoviePosterImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 13/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MoviePosterImage: View {
    let posterURL: URL?
    let posterSize: PosterStyle.Size
    
    var body: some View {
        AsyncImage(url: posterURL) {
            $0.resizable()
        } placeholder: {
            Rectangle()
                .foregroundColor(.gray)
        }
        .posterStyle(loaded: true, size: posterSize)
    }
}
