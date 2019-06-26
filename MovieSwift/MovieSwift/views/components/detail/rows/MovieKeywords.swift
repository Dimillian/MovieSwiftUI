//
//  MovieKeywords.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieKeywords : View {
    let keywords: [Keyword]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Keywords")
                .font(.FjallaOne(size: 20))
                .padding(.leading)
            ScrollView(showsHorizontalIndicator: false) {
                HStack {
                    ForEach(keywords) {keyword in
                        KeywordBadge(keyword: keyword)
                    }
                }.padding(.leading)
            }
        }
            .listRowInsets(EdgeInsets())
            .padding(.top)
            .padding(.bottom)
    }
}

#if DEBUG
struct MovieKeywords_Previews : PreviewProvider {
    static var previews: some View {
        MovieKeywords(keywords: [Keyword(id: 0, name: "Test")])
    }
}
#endif
