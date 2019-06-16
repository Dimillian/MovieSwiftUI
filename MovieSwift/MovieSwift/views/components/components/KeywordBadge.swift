//
//  KeywordBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct KeywordBadge : View {
    let keyword: Keyword
    
    var body: some View {
        NavigationButton(destination: MovieKeywordList(keyword: keyword)) {
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
