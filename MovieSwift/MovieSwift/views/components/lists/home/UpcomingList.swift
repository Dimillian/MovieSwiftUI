//
//  LatestList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

final class UpcomingPageListener: MoviesPagesListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchUpcoming(page: currentPage))
    }
}


struct UpcomingList : View {
    @EnvironmentObject var store: Store<AppState>
    @State var pageListener = UpcomingPageListener()
    var headerView: AnyView?
    
    var body: some View {
        MoviesList(movies: store.state.moviesState.upcoming, displaySearch: true, pageListener: pageListener, headerView: headerView)
            .navigationBarTitle(Text("Upcoming"))
            .onAppear {
                self.pageListener.loadPage()
        }
    }
}

#if DEBUG
struct LatestList_Previews : PreviewProvider {
    static var previews: some View {
        UpcomingList().environmentObject(sampleStore)
    }
}
#endif
