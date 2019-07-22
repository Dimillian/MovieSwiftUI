//
//  MoviesHome.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

final class MovieHomeSelectionStore: BindableObject {
    var willChange = PassthroughSubject<Void, Never>()
    
    var pageListener: MoviesHomeListPageListener
    var selectedMenu: MoviesMenu {
        willSet {
            willChange.send()
        }
        didSet {
            pageListener.menu = selectedMenu
        }
    }
        
    init(selectedMenu: MoviesMenu, pageListener: MoviesHomeListPageListener) {
        self.selectedMenu = selectedMenu
        self.pageListener = pageListener
    }
}

final class MoviesHomeListPageListener: MoviesPagesListener {
    var menu: MoviesMenu {
        didSet {
            currentPage = 1
        }
    }
    
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchMoviesMenuList(list: menu, page: currentPage))
    }
    
    init(menu: MoviesMenu) {
        self.menu = menu
        
        super.init()
        
        loadPage()
    }
}

struct MoviesHome : View {
    @ObjectBinding var selectedMenu = MovieHomeSelectionStore(selectedMenu: .popular,
                                                              pageListener: MoviesHomeListPageListener(menu: .popular))
    @State var isSettingPresented = false
    
    var segmentedView: some View {
        ScrollableSelector(items: MoviesMenu.allCases.map{ $0.title() },
                           selection: $selectedMenu.selectedMenu.rawValue)
    }
    
    var body: some View {
        NavigationView {
            Group {
                MoviesHomeList(menu: $selectedMenu.selectedMenu,
                               pageListener: selectedMenu.pageListener,
                               headerView: AnyView(segmentedView))
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
                    onDismiss: { self.isSettingPresented = false },
                    content: { SettingsForm() })
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
