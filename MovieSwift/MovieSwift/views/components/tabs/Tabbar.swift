//
//  Tabbar.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct Tabbar : View {
    @EnvironmentObject var store: AppStore
    @State var selectedTab = Tab.movies
    
    enum Tab: Int {
        case movies, discover, myLists
    }

    var body: some View {
        TabbedView(selection: $selectedTab) {
            MoviesHome().tabItemLabel(VStack{Image("tab_movie");Text("Movies")}).tag(Tab.movies)
            DiscoverView().tabItemLabel(VStack{Image("tab_discover");Text("Discover")}).tag(Tab.discover)
            MyLists().tabItemLabel(Image("tab_my_list");Text("My Lists")}).tag(Tab.myLists)
        }
            .edgesIgnoringSafeArea(.top)
    }
}

#if DEBUG
struct Tabbar_Previews : PreviewProvider {
    static var previews: some View {
        Tabbar().environmentObject(sampleStore)
    }
}
#endif
