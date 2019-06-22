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
            MoviesHome().tabItemLabel(Text("Movies")).tag(0)
            DiscoverView().tabItemLabel(Text("Discover")).tag(1)
            MyLists().tabItemLabel(Text("My Lists")).tag(2)
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
