//
//  ListImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 21/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct ListImage: View {
    @EnvironmentObject var store: Store<AppState>
    let movieId: Int
    
    private var icon: String? {
        if store.state.moviesState.wishlist.contains(movieId) {
            return "heart.fill"
        } else if   store.state.moviesState.seenlist.contains(movieId) {
            return "eye.fill"
        } else if store.state.moviesState.customLists.contains(where: { (_, value) -> Bool in
            value.movies.contains(self.movieId)
        }) {
            return "pin.fill"
        }
        return nil
    }
    
    var body: some View {
        Group {
            if icon != nil {
                Image(systemName: icon!)
                    .imageScale(.small)
                    .foregroundColor(.white)
                    .position(x: 13, y: 15)
                    .transition(AnyTransition.scale
                        .combined(with: .opacity))
                    .animation(.spring())
            }
        }
    }
}

#if DEBUG
struct ListImage_Previews: PreviewProvider {
    static var previews: some View {
        ListImage(movieId: 0).environmentObject(sampleStore)
    }
}
#endif
