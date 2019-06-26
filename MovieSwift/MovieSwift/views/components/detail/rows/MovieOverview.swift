//
//  MovieOverview.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieOverview : View {
    let movie: Movie
    @State var isOverviewExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview:").font(.FjallaOne(size: 20))
            Text(movie.overview)
                .font(.subheadline)
                .color(.secondary)
                .lineLimit(self.isOverviewExpanded ? nil : 4)
                .tapAction {
                    withAnimation {
                        self.isOverviewExpanded.toggle()
                    }
            }
            Button(action: {
                withAnimation {
                    self.isOverviewExpanded.toggle()
                }
            }, label: {
                Text(self.isOverviewExpanded ? "Less" : "Read more")
                    .color(.steam_blue)
            })
        }
    }
}

#if DEBUG
struct MovieOverview_Previews : PreviewProvider {
    static var previews: some View {
        MovieOverview(movie: sampleMovie)
    }
}
#endif
