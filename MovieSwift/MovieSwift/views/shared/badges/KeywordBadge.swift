//
//  KeywordBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct KeywordBadge : View {
    @EnvironmentObject var store: Store<AppState>
    let keyword: Keyword
    
    var body: some View {
        NavigationLink(destination: MovieKeywordList(keyword: keyword).environmentObject(store)) {
            RoundedBadge(text: keyword.name)
        }
    }
}

#if DEBUG
struct KeywordBadge_Previews : PreviewProvider {
    static var previews: some View {
        KeywordBadge(keyword: Keyword(id: 0, name: "Test"))
    }
}
#endif
