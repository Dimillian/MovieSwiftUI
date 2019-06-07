//
//  PopularList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct PopularList : View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        List {
            ForEach(state.moviesState.popular) { id in
                MovieRow(movie: self.state.moviesState.movies[id]!)
            }
        }
    }
}

#if DEBUG
struct PopularList_Previews : PreviewProvider {
    static var previews: some View {
        PopularList().environmentObject(store)
    }
}
#endif
