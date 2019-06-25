//
//  MovieAddToList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieAddToListRow : View {
    @EnvironmentObject var store: AppStore
    
    @State var addedToWishlist: Bool {
        return store.state.moviesState.wishlist.contains(movieId)
    }
    
    @State var addedToSeenlist: Bool {
        return store.state.moviesState.seenlist.contains(movieId)
    }
    
    let movieId: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            BorderedButton(text: addedToWishlist ? "In wishlist" : "Add to wishlist",
                           systemImageName: "heart",
                           color: .pink,
                           isOn: addedToWishlist,
                           action: {
                self.store.dispatch(action: MoviesActions.addToWishlist(movie: self.movieId))
            })

            BorderedButton(text: addedToSeenlist ? "Seen" : "Mark as seen",
                           systemImageName: "eye",
                           color: .green,
                           isOn: addedToSeenlist,
                           action: {
                self.store.dispatch(action: MoviesActions.addToSeenlist(movie: self.movieId))
            })
        }.padding(.top, 8)
            .padding(.bottom, 8)
    }
}

#if DEBUG
struct MovieAddToList_Previews : PreviewProvider {
    static var previews: some View {
        MovieAddToListRow(addedToWishlist: true,
                       addedToSeenlist: false,
                       movieId: 0).environmentObject(sampleStore)
    }
}
#endif
