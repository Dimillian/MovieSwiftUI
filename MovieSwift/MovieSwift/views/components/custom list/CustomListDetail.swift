//
//  CustomListDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Flux

struct CustomListDetail : View {
    @EnvironmentObject var store: Store<AppState>
    let listId: Int
    
    var list: CustomList {
        return store.state.moviesState.customLists[listId]!
    }
    
    var body: some View {
        MoviesList(movies: list.movies,
                   displaySearch: false)
            .navigationBarTitle(Text(list.name))
    }
}

#if DEBUG
struct CustomListDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomListDetail(listId: sampleStore.state.moviesState.customLists.first!.key)
                .environmentObject(sampleStore)
        }
    }
}
#endif
