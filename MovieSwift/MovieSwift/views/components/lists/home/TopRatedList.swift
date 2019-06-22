//
//  TopRatedList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

final class TopRatedListPageListener: PageListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchTopRated(page: currentPage))
    }
}

struct TopRatedList : View {
    @EnvironmentObject var store: AppStore
    @State var pageListener = TopRatedListPageListener()
    
    var body: some View {
        MoviesList(movies: store.state.moviesState.topRated, displaySearch: true, pageListener: pageListener)
            .navigationBarTitle(Text("Top Rated"))
            .onAppear {
                self.pageListener.loadPage()
        }
    }
}

#if DEBUG
struct TopRatedList_Previews : PreviewProvider {
    static var previews: some View {
        TopRatedList().environmentObject(sampleStore)
    }
}
#endif
