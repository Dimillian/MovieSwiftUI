//
//  MoviesHome.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviesHome : View {
    enum Categories: Int {
        case popular, topRated, upcoming, nowPlaying
    }
    
    @State var selectedIndex: Categories = Categories.popular
    
    var segmentedView: some View {
        SegmentedControl(selection: $selectedIndex) {
            Text("Popular").tag(Categories.popular)
            Text("Top Rated").tag(Categories.topRated)
            Text("Upcoming").tag(Categories.upcoming)
            Text("Playing").tag(Categories.nowPlaying)
            }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if selectedIndex == .popular {
                    PopularList(headerView: AnyView(segmentedView))
                } else if selectedIndex == .topRated {
                    TopRatedList(headerView: AnyView(segmentedView))
                } else if selectedIndex == .upcoming {
                    UpcomingList(headerView: AnyView(segmentedView))
                } else if selectedIndex == .nowPlaying {
                    NowPlayingList(headerView: AnyView(segmentedView))
                }
            }
            .navigationBarItems(trailing:
                PresentationLink(destination: SettingsForm()) {
                        Image(systemName: "wrench")
                }
            )
        }
    }
}

#if DEBUG
struct MoviesHome_Previews : PreviewProvider {
    static var previews: some View {
        MoviesHome()
    }
}
#endif
