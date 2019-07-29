//
//  MoviesHome.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import SwiftUIFlux

struct MoviesHome : View {
    @EnvironmentObject private var store: Store<AppState>
    @ObservedObject private var selectedMenu = MoviesSelectedMenuStore(selectedMenu: .popular)
    @State private var isSettingPresented = false
    
    private var segmentedView: some View {
        ScrollableSelector(items: MoviesMenu.allCases.map{ $0.title() },
                           selection: $selectedMenu.menu.rawValue)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if selectedMenu.menu == .genres {
                    GenresList(headerView: AnyView(segmentedView))
                } else {
                    MoviesHomeList(menu: $selectedMenu.menu,
                                   pageListener: selectedMenu.pageListener,
                                   headerView: AnyView(segmentedView))
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.isSettingPresented = true
                }) {
                    HStack {
                        Image(systemName: "wrench").imageScale(.medium)
                    }.frame(width: 30, height: 30)
                }
            ).sheet(isPresented: $isSettingPresented,
                    content: { SettingsForm() })
        }
    }
}

#if DEBUG
struct MoviesHome_Previews : PreviewProvider {
    static var previews: some View {
        MoviesHome().environmentObject(sampleStore)
    }
}
#endif
