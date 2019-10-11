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
    private enum HomeMode {
        case list, grid
        
        func icon() -> String {
            switch self {
            case .list: return "rectangle.3.offgrid.fill"
            case .grid: return "rectangle.grid.1x2"
            }
        }
    }

    @EnvironmentObject private var store: Store<AppState>
    @ObservedObject private var selectedMenu = MoviesSelectedMenuStore(selectedMenu: .popular)
    @State private var isSettingPresented = false
    @State private var homeMode = HomeMode.list
    
    private var segmentedView: some View {
        ScrollableSelector(items: MoviesMenu.allCases.map{ $0.title() },
                           selection: Binding<Int>(
                            get: {
                                self.selectedMenu.menu.rawValue
                           },
                            set: {
                                self.selectedMenu.menu = MoviesMenu(rawValue: $0)!
                           })
        )
    }
    
    private var settingButton: some View {
        Button(action: {
            self.isSettingPresented = true
        }) {
            HStack {
                Image(systemName: "wrench").imageScale(.medium)
            }.frame(width: 30, height: 30)
        }
    }
    
    private var swapHomeButton: some View {
        Button(action: {
            self.homeMode = self.homeMode == .grid ? .list : .grid
        }) {
            HStack {
                Image(systemName: self.homeMode.icon()).imageScale(.medium)
            }.frame(width: 30, height: 30)
        }
    }
    
    private var homeAsList: some View {
        Group {
            if selectedMenu.menu == .genres {
                GenresList(headerView: AnyView(segmentedView))
            } else {
                MoviesHomeList(menu: $selectedMenu.menu,
                               pageListener: selectedMenu.pageListener,
                               headerView: AnyView(segmentedView))
            }
        }
    }
    
    private var homeAsGrid: some View {
        MoviesHomeGrid()
    }
    
    var body: some View {
        NavigationView {
            Group {
                if homeMode == .list {
                    homeAsList
                } else {
                    homeAsGrid
                }
            }
            .navigationBarItems(trailing:
                HStack {
                    swapHomeButton
                    settingButton
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
