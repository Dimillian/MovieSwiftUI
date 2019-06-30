//
//  PopularList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import SwiftUIFlux

final class PopularPageListener: PageListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchPopular(page: currentPage))
    }
}

struct PopularList : View {
    @EnvironmentObject var store: Store<AppState>
    @State var pageListener = PopularPageListener()
    var headerView: AnyView?
    
    var body: some View {
        MoviesList(movies: store.state.moviesState.popular, displaySearch: true, pageListener: pageListener, headerView: headerView)
            .navigationBarTitle(Text("Popular"))
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
