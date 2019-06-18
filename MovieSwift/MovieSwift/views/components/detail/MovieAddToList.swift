//
//  MovieAddToList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieAddToList : View {
    @EnvironmentObject var state: AppState
    
    @State var addedToWishlist: Bool {
        return state.moviesState.wishlist.contains(movieId)
    }
    
    @State var addedToSeenlist: Bool {
        return state.moviesState.seenlist.contains(movieId)
    }
    
    let movieId: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            BorderedButton(text: addedToWishlist ? "In wishlist" : "Add to wishlist",
                           systemImageName: "film",
                           color: .blue,
                           isOn: addedToWishlist,
                           action: {
                store.dispatch(action: MoviesActions.addToWishlist(movie: self.movieId))
            })

            BorderedButton(text: addedToSeenlist ? "Seen" : "Mark as seen",
                           systemImageName: "eyeglasses",
                           color: .green,
                           isOn: addedToSeenlist,
                           action: {
                store.dispatch(action: MoviesActions.addToSeenlist(movie: self.movieId))
            })
        }
    }
}

#if DEBUG
struct MovieAddToList_Previews : PreviewProvider {
    static var previews: some View {
        MovieAddToList(addedToWishlist: true,
                       addedToSeenlist: false,
                       movieId: 0).environmentObject(sampleStore)
    }
}
#endif
