//
//  TextBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 15/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct GenreBadge : View {
    let genre: Genre
    
    var body: some View {
        NavigationButton(destination: MoviesGenreList(genre: genre)) {
            HStack {
                Text(genre.name.capitalized)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .color(.white)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                
                }
                .background(
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(12)
            )
        }
    }
}

#if DEBUG
struct TextBadge_Previews : PreviewProvider {
    static var previews: some View {
        GenreBadge(genre: Genre(id: 0, name: "Test"))
    }
}
#endif
