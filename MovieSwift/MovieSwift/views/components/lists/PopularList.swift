//
//  PopularList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

final class PopularPageListener: PageListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchPopular(page: currentPage))
    }
}

struct PopularList : View {
    @EnvironmentObject var state: AppState
    @State var pageListener = PopularPageListener()
    
    var body: some View {
        NavigationView {
            MoviesList(movies: state.moviesState.popular, displaySearch: true, pageListener: pageListener)
                .navigationBarTitle(Text("Popular"))
            }
            .onAppear {
                self.pageListener.loadPage()
            }
    }
}

#if DEBUG
struct PopularList_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularList().environmentObject(sampleStore)
        }
    }
}
#endif
