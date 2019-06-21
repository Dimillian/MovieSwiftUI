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

    var body: some View {
        TabbedView {
            PopularList().tabItemLabel(Text("Popular")).tag(0)
            TopRatedList().tabItemLabel(Text("Top Rated")).tag(1)
            UpcomingList().tabItemLabel(Text("Upcoming")).tag(2)
            DiscoverView().tabItemLabel(Text("Discover")).tag(3)
            MyLists().tabItemLabel(Text("My Lists")).tag(4)
        }
            .edgesIgnoringSafeArea(.top)
            .accentColor(.red)
    }
}

#if DEBUG
struct Tabbar_Previews : PreviewProvider {
    static var previews: some View {
        Tabbar().environmentObject(sampleStore)
    }
}
#endif
